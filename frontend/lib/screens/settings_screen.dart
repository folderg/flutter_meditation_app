import 'package:flutter/material.dart';
import '../models/meditation_settings.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;
  final MeditationSettings currentSettings;
  final VoidCallback onSaved;

  const SettingsScreen({
    super.key,
    required this.settingsService,
    required this.currentSettings,
    required this.onSaved,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _duration;
  late double _breathIn;
  late double _breathOut;
  late double _hold;

  @override
  void initState() {
    super.initState();
    _duration = widget.currentSettings.meditationDurationSec.toDouble();
    _breathIn = widget.currentSettings.breathInSec.toDouble();
    _breathOut = widget.currentSettings.breathOutSec.toDouble();
    _hold = widget.currentSettings.holdSec.toDouble();
  }

  void _save() {
    final settings = MeditationSettings(
      meditationDurationSec: _duration.round(),
      breathInSec: _breathIn.round(),
      breathOutSec: _breathOut.round(),
      holdSec: _hold.round(),
    );
    widget.settingsService.updateSettings(settings);
    widget.onSaved();
    Navigator.of(context).pop();
  }

  void _reset() {
    final defaults = widget.settingsService.getDefaults();
    setState(() {
      _duration = defaults.meditationDurationSec.toDouble();
      _breathIn = defaults.breathInSec.toDouble();
      _breathOut = defaults.breathOutSec.toDouble();
      _hold = defaults.holdSec.toDouble();
    });
  }

  Widget _buildSlider({
    required String label,
    required String valueLabel,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  label: valueLabel,
                  onChanged: onChanged,
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(valueLabel, textAlign: TextAlign.right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: _reset,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSlider(
              label: 'Meditation Duration',
              valueLabel: '${_duration.round()} sec',
              value: _duration,
              min: 30,
              max: 3600,
              onChanged: (v) => setState(() => _duration = v),
            ),
            const Divider(),
            _buildSlider(
              label: 'Breath In',
              valueLabel: '${_breathIn.round()} sec',
              value: _breathIn,
              min: 1,
              max: 30,
              onChanged: (v) => setState(() => _breathIn = v),
            ),
            _buildSlider(
              label: 'Breath Out',
              valueLabel: '${_breathOut.round()} sec',
              value: _breathOut,
              min: 1,
              max: 30,
              onChanged: (v) => setState(() => _breathOut = v),
            ),
            _buildSlider(
              label: 'Hold (after exhale)',
              valueLabel: '${_hold.round()} sec',
              value: _hold,
              min: 0,
              max: 30,
              onChanged: (v) => setState(() => _hold = v),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Save'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
