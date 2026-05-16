import 'dart:async';
import 'package:flutter/material.dart';
import '../models/meditation_settings.dart';
import '../services/settings_service.dart';
import 'settings_screen.dart';

enum BreathPhase { inhale, exhale, hold }

class MeditationScreen extends StatefulWidget {
  final SettingsService settingsService;

  const MeditationScreen({super.key, required this.settingsService});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with TickerProviderStateMixin {
  late MeditationSettings _settings;

  bool _isMeditating = false;
  bool _paused = false;
  int _remainingSec = 0;
  BreathPhase _phase = BreathPhase.inhale;
  int _phaseRemainingSec = 0;

  Timer? _timer;

  late AnimationController _breathController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _settings = widget.settingsService.getSettings();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  void _startMeditation() {
    setState(() {
      _isMeditating = true;
      _paused = false;
      _remainingSec = _settings.meditationDurationSec;
      _phase = BreathPhase.inhale;
      _phaseRemainingSec = _settings.breathInSec;
    });
    _breathController.duration = Duration(seconds: _settings.breathInSec);
    _breathController.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer timer) {
    if (_paused) return;

    setState(() {
      _remainingSec--;
      _phaseRemainingSec--;

      if (_phaseRemainingSec <= 0) {
        _advancePhase();
      }

      if (_remainingSec <= 0) {
        _endMeditation();
      }
    });
  }

  void _advancePhase() {
    switch (_phase) {
      case BreathPhase.inhale:
        _phase = BreathPhase.exhale;
        _phaseRemainingSec = _settings.breathOutSec;
        _breathController.duration = Duration(seconds: _settings.breathOutSec);
        _breathController.reverse();
        break;
      case BreathPhase.exhale:
        if (_settings.holdSec > 0) {
          _phase = BreathPhase.hold;
          _phaseRemainingSec = _settings.holdSec;
        } else {
          _phase = BreathPhase.inhale;
          _phaseRemainingSec = _settings.breathInSec;
          _breathController.duration = Duration(seconds: _settings.breathInSec);
          _breathController.forward();
        }
        break;
      case BreathPhase.hold:
        _phase = BreathPhase.inhale;
        _phaseRemainingSec = _settings.breathInSec;
        _breathController.duration = Duration(seconds: _settings.breathInSec);
        _breathController.forward();
        break;
    }
  }

  void _endMeditation() {
    _timer?.cancel();
    _breathController.reset();
    setState(() {
      _isMeditating = false;
      _paused = false;
    });
  }

  void _togglePause() {
    setState(() {
      _paused = !_paused;
      if (_paused) {
        _breathController.stop();
      } else {
        if (_phase == BreathPhase.inhale) {
          _breathController.forward();
        } else {
          _breathController.reverse();
        }
      }
    });
  }

  void _openSettings() async {
    final wasMeditating = _isMeditating;
    if (wasMeditating) _togglePause();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          settingsService: widget.settingsService,
          currentSettings: _settings,
          onSaved: () {
            setState(() {
              _settings = widget.settingsService.getSettings();
            });
          },
        ),
      ),
    );

    if (wasMeditating && mounted) _togglePause();
  }

  String get _formattedTime {
    final min = _remainingSec ~/ 60;
    final sec = _remainingSec % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String get _phaseLabel {
    switch (_phase) {
      case BreathPhase.inhale:
        return 'Breathe In';
      case BreathPhase.exhale:
        return 'Breathe Out';
      case BreathPhase.hold:
        return 'Hold';
    }
  }

  Color get _phaseColor {
    switch (_phase) {
      case BreathPhase.inhale:
        return const Color(0xFF4FC3F7);
      case BreathPhase.exhale:
        return const Color(0xFF81C784);
      case BreathPhase.hold:
        return const Color(0xFFFFD54F);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Center(
        child: _isMeditating ? _buildMeditationView() : _buildStartView(),
      ),
    );
  }

  Widget _buildStartView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.self_improvement,
            size: 100, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 32),
        Text(
          '${_settings.meditationDurationSec ~/ 60} min meditation',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'In: ${_settings.breathInSec}s  Out: ${_settings.breathOutSec}s${_settings.holdSec > 0 ? '  Hold: ${_settings.holdSec}s' : ''}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 48),
        FilledButton.icon(
          onPressed: _startMeditation,
          icon: const Icon(Icons.play_arrow, size: 32),
          label: const Text('Start', style: TextStyle(fontSize: 18)),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationView() {
    return AnimatedBuilder(
      animation: _breathController,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_formattedTime,
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 8),
            Text(_phaseLabel,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: _phaseColor)),
            const SizedBox(height: 16),
            Text('${_phaseRemainingSec}s',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: _phaseColor)),
            const SizedBox(height: 32),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _phaseColor.withOpacity(0.15),
              ),
              child: Transform.scale(
                scale: _isMeditating && !_paused ? _scaleAnim.value : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _phaseColor.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _phaseColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_paused ? Icons.play_arrow : Icons.pause,
                      size: 40),
                  onPressed: _togglePause,
                ),
                const SizedBox(width: 32),
                IconButton(
                  icon: const Icon(Icons.stop, size: 40),
                  onPressed: _endMeditation,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    super.key,
    required Listenable animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
