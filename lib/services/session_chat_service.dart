import 'dart:convert';

import 'package:sickle_cell_app/models/session_chat.dart';
import 'package:http/http.dart' as http;

class SessionChatService {
  final String baseUrl = 'http://localhost:3000/sicklecare-be/api/chat';

  Future<List<SessionChat>> getAllChatsByDoctorId(String doctorId) async {
    final Uri url = Uri.parse('$baseUrl/findall/doctorId?doctorId=$doctorId');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SessionChat.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Chats not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<List<SessionChat>> getAllChatsByPatientId(String patientId) async {
    final Uri url =
        Uri.parse('$baseUrl/findall/patientId?patientId=$patientId');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SessionChat.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Chats not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }
}
