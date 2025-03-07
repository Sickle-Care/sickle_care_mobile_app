class HealthRecord {
  final String recordId;
  final String patientId;
  final String userId;
  final String? date;
  final WaterIntake waterIntake;
  final Diet diet;
  final AlcoholConsumption? alcoholConsumption;
  final Sleep? sleep;
  final Medicine medicine;
  final double waterIntakePercentage;
  final double dietPercentage;
  final double alcoholPercentage;
  final double sleepPercentage;
  final double medicinePercentage;
  final String? notes;
  final bool isDeleted;

  HealthRecord({
    required this.recordId,
    required this.patientId,
    required this.userId,
    this.date,
    required this.waterIntake,
    required this.diet,
    this.alcoholConsumption,
    this.sleep,
    required this.medicine,
    required this.waterIntakePercentage,
    required this.dietPercentage,
    required this.alcoholPercentage,
    required this.sleepPercentage,
    required this.medicinePercentage,
    this.notes,
    required this.isDeleted,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      recordId: json['recordId'],
      patientId: json['patientId'],
      userId: json['userId'],
      date: json['date'],
      waterIntake: WaterIntake.fromJson(json['waterIntake'] ?? {}),
      diet: Diet.fromJson(json['diet'] ?? {}),
      alcoholConsumption: json['alcoholConsumption'] != null
          ? AlcoholConsumption.fromJson(json['alcoholConsumption'])
          : null,
      sleep: json['sleep'] != null ? Sleep.fromJson(json['sleep']) : null,
      medicine: Medicine.fromJson(json['medicine'] ?? {}),
      waterIntakePercentage: (json['waterIntakePercentage'] ?? 0).toDouble(),
      dietPercentage: (json['dietPercentage'] ?? 0).toDouble(),
      alcoholPercentage: (json['alcoholPercentage'] ?? 0).toDouble(),
      sleepPercentage: (json['sleepPercentage'] ?? 0).toDouble(),
      medicinePercentage: (json['medicinePercentage'] ?? 0).toDouble(),
      notes: json['notes'],
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'patientId': patientId,
      'userId': userId,
      'date': date,
      'waterIntake': waterIntake.toJson(),
      'diet': diet.toJson(),
      'alcoholConsumption': alcoholConsumption?.toJson(),
      'sleep': sleep?.toJson(),
      'medicine': medicine.toJson(),
      'waterIntakePercentage': waterIntakePercentage,
      'dietPercentage': dietPercentage,
      'alcoholPercentage': alcoholPercentage,
      'sleepPercentage': sleepPercentage,
      'medicinePercentage': medicinePercentage,
      'notes': notes,
      'isDeleted': isDeleted,
    };
  }
}

class WaterIntake {
  final int glassAmount;
  final int glassCount;

  WaterIntake({this.glassAmount = 0, this.glassCount = 0});

  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    return WaterIntake(
      glassAmount: json['glassAmount'] ?? 0,
      glassCount: json['glassCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'glassAmount': glassAmount,
      'glassCount': glassCount,
    };
  }

  WaterIntake copyWith({
    int? glassAmount,
    int? glassCount,
  }) {
    return WaterIntake(
      glassAmount: glassAmount ?? this.glassAmount,
      glassCount: glassCount ?? this.glassCount,
    );
  }
}

class Diet {
  final Map<String, List<String>> breakfast;
  final Map<String, List<String>> lunch;
  final Map<String, List<String>> dinner;

  Diet({
    this.breakfast = const {},
    this.lunch = const {},
    this.dinner = const {},
  });

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      breakfast: (json['breakfast']?['nutrition'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, List<String>.from(value))) ??
          {},
      lunch: (json['lunch']?['nutrition'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, List<String>.from(value))) ??
          {},
      dinner: (json['dinner']?['nutrition'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, List<String>.from(value))) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': {'nutrition': breakfast},
      'lunch': {'nutrition': lunch},
      'dinner': {'nutrition': dinner},
    };
  }

  Diet copyWith({
    Map<String, List<String>>? breakfast,
    Map<String, List<String>>? lunch,
    Map<String, List<String>>? dinner,
  }) {
    return Diet(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
    );
  }
}

class Medicine {
  final List<MedicineItem> morning;
  final List<MedicineItem> day;
  final List<MedicineItem> night;

  Medicine({
    this.morning = const [],
    this.day = const [],
    this.night = const [],
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      morning: (json['morning'] as List<dynamic>?)
              ?.map((e) => MedicineItem.fromJson(e))
              .toList() ??
          [],
      day: (json['day'] as List<dynamic>?)
              ?.map((e) => MedicineItem.fromJson(e))
              .toList() ??
          [],
      night: (json['night'] as List<dynamic>?)
              ?.map((e) => MedicineItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'morning': morning.map((e) => e.toJson()).toList(),
      'day': day.map((e) => e.toJson()).toList(),
      'night': night.map((e) => e.toJson()).toList(),
    };
  }

  Medicine copyWith({
    List<MedicineItem>? morning,
    List<MedicineItem>? day,
    List<MedicineItem>? night,
  }) {
    return Medicine(
      morning: morning ?? this.morning,
      day: day ?? this.day,
      night: night ?? this.night,
    );
  }
}

class MedicineItem {
  final String name;
  final bool isTaken;

  MedicineItem({required this.name, required this.isTaken});

  factory MedicineItem.fromJson(Map<String, dynamic> json) {
    return MedicineItem(
      name: json['name'] ?? '',
      isTaken: json['isTaken'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isTaken': isTaken,
    };
  }
}

class Sleep {
  final int? hours;
  final String? quality;

  Sleep({this.hours, this.quality});

  factory Sleep.fromJson(Map<String, dynamic> json) {
    return Sleep(
      hours: json['hours'],
      quality: json['quality'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hours': hours,
    };
  }

  Sleep copyWith({
    int? hours,
    String? quality,
  }) {
    return Sleep(
      hours: hours ?? this.hours,
      quality: quality ?? this.quality,
    );
  }
}

class AlcoholConsumption {
  final int shotCount;
  final int canCount;

  AlcoholConsumption({
    this.shotCount = 0,
    this.canCount = 0,
  });

  factory AlcoholConsumption.fromJson(Map<String, dynamic> json) {
    return AlcoholConsumption(
      shotCount: json['shotCount'] ?? 0,
      canCount: json['canCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shotCount': shotCount,
      'canCount': canCount,
    };
  }

  AlcoholConsumption copyWith({
    int? shotCount,
    int? canCount,
  }) {
    return AlcoholConsumption(
      shotCount: shotCount ?? this.shotCount,
      canCount: canCount ?? this.canCount,
    );
  }
}
