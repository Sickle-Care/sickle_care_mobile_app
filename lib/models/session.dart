class Session {
  final String? sessionId;
  final String? patientId;
  final String? doctorId;
  final String? doctorName;
  final String? patientName;
  final DateTime? dateTime;
  final String? isAccepted;

  Session({
    this.sessionId,
    this.patientId,
    this.doctorId,
    this.doctorName,
    this.patientName,
    this.dateTime,
    this.isAccepted,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['sessionId'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      patientName: json['patientName'],
      dateTime:
          json['dateTime'] != null ? DateTime.parse(json['dateTime']) : null,
      isAccepted: json['isAccepted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientName': patientName,
      'dateTime': dateTime?.toIso8601String(),
      'isAccepted': isAccepted,
    };
  }
}
