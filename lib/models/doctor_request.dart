class DoctorRequest {
  final String? requestId;
  final String patientId;
  final String doctorId;
  final String patientName;
  final DateTime date;
  final String? isAccepted;
  final String? docNote;
  final String? patientNote;

  DoctorRequest({
    required this.requestId,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.date,
    this.isAccepted,
    this.docNote,
    this.patientNote,
  });

  factory DoctorRequest.fromJson(Map<String, dynamic> json) {
    return DoctorRequest(
      requestId: json['requestId'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      patientName: json['patientName'],
      date: DateTime.parse(json['date']),
      isAccepted: json['isAccepted'],
      docNote: json['docNote'],
      patientNote: json['patientNote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'patientId': patientId,
      'doctorId': doctorId,
      'patientName': patientName,
      'date': date.toIso8601String(),
      'isAccepted': isAccepted,
      'docNote': docNote,
      'patientNote': patientNote,
    };
  }
}
