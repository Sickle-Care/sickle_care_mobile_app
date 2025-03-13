import 'dart:convert';

class MedicineSchedule {
  final List<String> morning;
  final List<String> day;
  final List<String> night;

  MedicineSchedule({
    required this.morning,
    required this.day,
    required this.night,
  });

  /// Convert JSON to MedicineSchedule object
  factory MedicineSchedule.fromJson(Map<String, dynamic> json) {
    return MedicineSchedule(
      morning: List<String>.from(json['morning'] ?? []),
      day: List<String>.from(json['day'] ?? []),
      night: List<String>.from(json['night'] ?? []),
    );
  }

  /// Convert MedicineSchedule object to JSON
  Map<String, dynamic> toJson() {
    return {
      'morning': morning,
      'day': day,
      'night': night,
    };
  }
}

class MedicineData {
  final String userId;
  final String patientId;
  final String? medicineId;
  final MedicineSchedule medicines;
  final bool isDeleted;

  MedicineData({
    required this.userId,
    required this.patientId,
    this.medicineId,
    required this.medicines,
    this.isDeleted = false,
  });

  /// Convert JSON to Medicine object
  factory MedicineData.fromJson(Map<String, dynamic> json) {
    return MedicineData(
      userId: json['userId'],
      patientId: json['patientId'],
      medicineId: json['medicineId'],
      medicines: MedicineSchedule.fromJson(json['medicines'] ?? {}),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  /// Convert Medicine object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'patientId': patientId,
      'medicineId': medicineId,
      'medicines': medicines.toJson(),
      'isDeleted': isDeleted,
    };
  }

  /// Convert JSON String to Medicine object
  static MedicineData fromJsonString(String jsonString) {
    return MedicineData.fromJson(json.decode(jsonString));
  }

  /// Convert Medicine object to JSON String
  String toJsonString() {
    return json.encode(toJson());
  }
}
