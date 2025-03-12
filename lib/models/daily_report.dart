class DailyReport {
  final String reportId;
  final String recordId;
  final String userId;
  final String patientId;
  final String? date;
  final WaterIntake? waterIntake;
  final Diet? diet;
  final Sleep? sleep;
  final AlcoholConsumption? alcoholConsumption;
  final Medicine? medicine;

  DailyReport({
    required this.reportId,
    required this.recordId,
    required this.userId,
    required this.patientId,
    this.date,
    this.waterIntake,
    this.diet,
    this.sleep,
    this.alcoholConsumption,
    this.medicine,
  });

  factory DailyReport.fromJson(Map<String, dynamic> json) {
    return DailyReport(
      reportId: json['reportId'],
      recordId: json['recordId'],
      userId: json['userId'],
      patientId: json['patientId'],
      date: json['date'],
      waterIntake: json['waterIntake'] != null ? WaterIntake.fromJson(json['waterIntake']) : null,
      diet: json['diet'] != null ? Diet.fromJson(json['diet']) : null,
      sleep: json['sleep'] != null ? Sleep.fromJson(json['sleep']) : null,
      alcoholConsumption: json['alcoholConsumption'] != null ? AlcoholConsumption.fromJson(json['alcoholConsumption']) : null,
      medicine: json['medicine'] != null ? Medicine.fromJson(json['medicine']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'recordId': recordId,
      'userId': userId,
      'patientId': patientId,
      'date': date,
      'waterIntake': waterIntake?.toJson(),
      'diet': diet?.toJson(),
      'sleep': sleep?.toJson(),
      'alcoholConsumption': alcoholConsumption?.toJson(),
      'medicine': medicine?.toJson(),
    };
  }
}

class WaterIntake {
  final int? taken;
  final String? recommended;
  final int? percentage;

  WaterIntake({this.taken, this.recommended, this.percentage});

  factory WaterIntake.fromJson(Map<String, dynamic> json) => WaterIntake(
        taken: json['taken'],
        recommended: json['recommended'],
        percentage: json['percentage'],
      );

  Map<String, dynamic> toJson() => {
        'taken': taken,
        'recommended': recommended,
        'percentage': percentage,
      };
}

class Diet {
  final List<String>? eaten;
  final List<String>? recommended;
  final int? percentage;

  Diet({this.eaten, this.recommended, this.percentage});

  factory Diet.fromJson(Map<String, dynamic> json) => Diet(
        eaten: List<String>.from(json['eaten'] ?? []),
        recommended: List<String>.from(json['recommended'] ?? []),
        percentage: json['percentage'],
      );

  Map<String, dynamic> toJson() => {
        'eaten': eaten,
        'recommended': recommended,
        'percentage': percentage,
      };
}

class Sleep {
  final int? slept;
  final int? recommended;
  final int? percentage;

  Sleep({this.slept, this.recommended, this.percentage});

  factory Sleep.fromJson(Map<String, dynamic> json) => Sleep(
        slept: json['slept'],
        recommended: json['recommended'],
        percentage: json['percentage'],
      );

  Map<String, dynamic> toJson() => {
        'slept': slept,
        'recommended': recommended,
        'percentage': percentage,
      };
}

class AlcoholConsumption {
  final int? shotsTaken;
  final int? recommendedShots;
  final int? percentage;

  AlcoholConsumption({this.shotsTaken, this.recommendedShots, this.percentage});

  factory AlcoholConsumption.fromJson(Map<String, dynamic> json) => AlcoholConsumption(
        shotsTaken: json['shotsTaken'],
        recommendedShots: json['recommended'] != null ? json['recommended']['shots'] : null,
        percentage: json['percentage'],
      );

  Map<String, dynamic> toJson() => {
        'shotsTaken': shotsTaken,
        'recommended': {'shots': recommendedShots},
        'percentage': percentage,
      };
}

class Medicine {
  final List<String>? notTaken;
  final int? percentage;

  Medicine({this.notTaken, this.percentage});

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
        notTaken: List<String>.from(json['notTaken'] ?? []),
        percentage: json['percentage'],
      );

  Map<String, dynamic> toJson() => {
        'notTaken': notTaken,
        'percentage': percentage,
      };
}
