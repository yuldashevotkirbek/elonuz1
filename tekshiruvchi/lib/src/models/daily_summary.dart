class DailySummary {
  final DateTime date;
  final Duration screenTime;
  final double distanceMeters;
  final Duration sleep;

  const DailySummary({
    required this.date,
    required this.screenTime,
    required this.distanceMeters,
    required this.sleep,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'screenTime': screenTime.inSeconds,
        'distanceMeters': distanceMeters,
        'sleep': sleep.inSeconds,
      };

  factory DailySummary.fromJson(Map<String, dynamic> json) => DailySummary(
        date: DateTime.parse(json['date'] as String),
        screenTime: Duration(seconds: (json['screenTime'] as num).toInt()),
        distanceMeters: (json['distanceMeters'] as num).toDouble(),
        sleep: Duration(seconds: (json['sleep'] as num).toInt()),
      );
}

