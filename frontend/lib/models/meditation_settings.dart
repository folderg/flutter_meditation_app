class MeditationSettings {
  final int meditationDurationSec;
  final int breathInSec;
  final int breathOutSec;
  final int holdSec;

  MeditationSettings({
    required this.meditationDurationSec,
    required this.breathInSec,
    required this.breathOutSec,
    this.holdSec = 0,
  });

  factory MeditationSettings.defaults() {
    return MeditationSettings(
      meditationDurationSec: 600,
      breathInSec: 4,
      breathOutSec: 6,
      holdSec: 0,
    );
  }

  factory MeditationSettings.fromJson(Map<String, dynamic> json) {
    return MeditationSettings(
      meditationDurationSec: json['meditationDurationSec'] as int,
      breathInSec: json['breathInSec'] as int,
      breathOutSec: json['breathOutSec'] as int,
      holdSec: (json['holdSec'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meditationDurationSec': meditationDurationSec,
      'breathInSec': breathInSec,
      'breathOutSec': breathOutSec,
      'holdSec': holdSec,
    };
  }

  MeditationSettings copyWith({
    int? meditationDurationSec,
    int? breathInSec,
    int? breathOutSec,
    int? holdSec,
  }) {
    return MeditationSettings(
      meditationDurationSec: meditationDurationSec ?? this.meditationDurationSec,
      breathInSec: breathInSec ?? this.breathInSec,
      breathOutSec: breathOutSec ?? this.breathOutSec,
      holdSec: holdSec ?? this.holdSec,
    );
  }
}
