class SessionChat {
  final String? chatId;
  final String? requestId;
  final String? patientId;
  final String? doctorId;
  final String? patientName;
  final String? doctorName;

  SessionChat({
    this.chatId,
    this.requestId,
    this.patientId,
    this.doctorId,
    this.patientName,
    this.doctorName,
  });

  factory SessionChat.fromJson(Map<String, dynamic> json) {
    return SessionChat(
      chatId: json['chatId'],
      requestId: json['requestId'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      patientName: json['patientName'],
      doctorName: json['doctorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'requestId': requestId,
      'patientId': patientId,
      'doctorId': doctorId,
      'patientName': patientName,
      'doctorName': doctorName,
    };
  }
}