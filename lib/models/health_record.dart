class HealthRecord {
  final String recordId;
  final String patientId;
  final String userId;
  final String date;
  final WaterIntake? waterIntake;
  final Diet? diet;
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
    required this.date,
    this.waterIntake,
    this.diet,
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
      waterIntake: WaterIntake.fromJson(json['waterIntake']),
      diet: Diet.fromJson(json['diet']),
      alcoholConsumption:
          AlcoholConsumption.fromJson(json['alcoholConsumption']),
      sleep: Sleep.fromJson(json['sleep']),
      medicine: Medicine.fromJson(json['medicine']),
      waterIntakePercentage: json['waterIntakePercentage']?.toDouble() ?? 0.0,
      dietPercentage: json['dietPercentage']?.toDouble() ?? 0.0,
      alcoholPercentage: json['alcoholPercentage']?.toDouble() ?? 0.0,
      sleepPercentage: json['sleepPercentage']?.toDouble() ?? 0.0,
      medicinePercentage: json['medicinePercentage']?.toDouble() ?? 0.0,
      notes: json['notes'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'patientId': patientId,
      'userId': userId,
      'date': date,
      'waterIntake': waterIntake!.toJson(),
      'diet': diet!.toJson(),
      'alcoholConsumption': alcoholConsumption!.toJson(),
      'sleep': sleep!.toJson(),
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

  WaterIntake({
    required this.glassAmount,
    required this.glassCount,
  });

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
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;

  Diet({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      breakfast: Meal.fromJson(json['breakfast']),
      lunch: Meal.fromJson(json['lunch']),
      dinner: Meal.fromJson(json['dinner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.toJson(),
      'lunch': lunch.toJson(),
      'dinner': dinner.toJson(),
    };
  }

  Diet copyWith({
    Meal? breakfast,
    Meal? lunch,
    Meal? dinner,
  }) {
    return Diet(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
    );
  }
}

class Meal {
  final String? iron;
  final String? folateVitaminB9;
  final String? vitaminB12;
  final String? vitaminC;
  final String? zinc;
  final String? magnesium;
  final String? omega3FattyAcids;
  final String? protein;
  final String? calciumVitaminD;
  final String? hydrationFluids;

  Meal({
    this.iron,
    this.folateVitaminB9,
    this.vitaminB12,
    this.vitaminC,
    this.zinc,
    this.magnesium,
    this.omega3FattyAcids,
    this.protein,
    this.calciumVitaminD,
    this.hydrationFluids,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      iron: json['Iron'],
      folateVitaminB9: json['Folate_VitaminB9'],
      vitaminB12: json['VitaminB12'],
      vitaminC: json['VitaminC'],
      zinc: json['Zinc'],
      magnesium: json['Magnesium'],
      omega3FattyAcids: json['Omega_3FattyAcids'],
      protein: json['Protein'],
      calciumVitaminD: json['Calcium_VitaminD'],
      hydrationFluids: json['Hydration_Fluids'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Iron': iron,
      'Folate_VitaminB9': folateVitaminB9,
      'VitaminB12': vitaminB12,
      'VitaminC': vitaminC,
      'Zinc': zinc,
      'Magnesium': magnesium,
      'Omega_3FattyAcids': omega3FattyAcids,
      'Protein': protein,
      'Calcium_VitaminD': calciumVitaminD,
      'Hydration_Fluids': hydrationFluids,
    };
  }

  Meal copyWith({
    String? iron,
    String? folateVitaminB9,
    String? vitaminB12,
    String? vitaminC,
    String? zinc,
    String? magnesium,
    String? omega3FattyAcids,
    String? protein,
    String? calciumVitaminD,
    String? hydrationFluids,
  }) {
    return Meal(
      iron: iron ?? this.iron,
      folateVitaminB9: folateVitaminB9 ?? this.folateVitaminB9,
      vitaminB12: vitaminB12 ?? this.vitaminB12,
      vitaminC: vitaminC ?? this.vitaminC,
      zinc: zinc ?? this.zinc,
      magnesium: magnesium ?? this.magnesium,
      omega3FattyAcids: omega3FattyAcids ?? this.omega3FattyAcids,
      protein: protein ?? this.protein,
      calciumVitaminD: calciumVitaminD ?? this.calciumVitaminD,
      hydrationFluids: hydrationFluids ?? this.hydrationFluids,
    );
  }
}

class AlcoholConsumption {
  final int shotCount;

  AlcoholConsumption({
    required this.shotCount,
  });

  factory AlcoholConsumption.fromJson(Map<String, dynamic> json) {
    return AlcoholConsumption(
      shotCount: json['shotCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shotCount': shotCount,
    };
  }

  AlcoholConsumption copyWith({
    int? shotCount,
  }) {
    return AlcoholConsumption(
      shotCount: shotCount ?? this.shotCount,
    );
  }
}

class Sleep {
  final int hours;
  final String quality;

  Sleep({
    required this.hours,
    required this.quality,
  });

  factory Sleep.fromJson(Map<String, dynamic> json) {
    return Sleep(
      hours: json['hours'] ?? 0,
      quality: json['quality'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hours': hours,
      'quality': quality,
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

class Medicine {
  final List<MedicineDose> morning;
  final List<MedicineDose> day;
  final List<MedicineDose> night;

  Medicine({
    required this.morning,
    required this.day,
    required this.night,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      morning: (json['morning'] as List<dynamic>?)
              ?.map((e) => MedicineDose.fromJson(e))
              .toList() ??
          [],
      day: (json['day'] as List<dynamic>?)
              ?.map((e) => MedicineDose.fromJson(e))
              .toList() ??
          [],
      night: (json['night'] as List<dynamic>?)
              ?.map((e) => MedicineDose.fromJson(e))
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
    List<MedicineDose>? morning,
    List<MedicineDose>? day,
    List<MedicineDose>? night,
  }) {
    return Medicine(
      morning: morning ?? this.morning,
      day: day ?? this.day,
      night: night ?? this.night,
    );
  }
}

class MedicineDose {
  final String name;
  final bool isTaken;

  MedicineDose({
    required this.name,
    required this.isTaken,
  });

  factory MedicineDose.fromJson(Map<String, dynamic> json) {
    return MedicineDose(
      name: json['name'],
      isTaken: json['isTaken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isTaken': isTaken,
    };
  }

  MedicineDose copyWith({
    String? name,
    bool? isTaken,
  }) {
    return MedicineDose(
      name: name ?? this.name,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}
