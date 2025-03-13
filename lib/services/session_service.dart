import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sickle_cell_app/models/session.dart';

class SessionService {
  final String baseUrl = 'http://localhost:3000/sicklecare-be/api/session';

  Future<Session> createSession(Session request) async {
    final Uri url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Session.fromJson(data);
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        return Session.fromJson(errorData);
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<List<Session>> getAllSessionByDoctorId(String doctorId) async {
    final Uri url = Uri.parse('$baseUrl/findall/doctorId?doctorId=$doctorId');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Session.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Patients data not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<List<Session>> getAllSessionByChatIdAndDoctorId(
      String chatId, String doctorId) async {
    final Uri url = Uri.parse(
        '$baseUrl/findall/chatId/doctorId?doctorId=$doctorId&chatId=$chatId');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Session.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Patients data not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<List<Session>> getAllSessionByChatIdAndPatientId(
      String chatId, String patientId) async {
    final Uri url = Uri.parse(
        '$baseUrl/findall/chatId/patientId?patientId=$patientId&chatId=$chatId');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Session.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Patients data not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<Session> acceptSessionByrequestId(String sessionId) async {
    final Uri url = Uri.parse('$baseUrl/sessionId/accept?sessionId=$sessionId');
    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);
      return Session.fromJson(data);
    } else {
      throw Exception("Failed to accept request");
    }
  }

  Future<Session> declineSessionByrequestId(String sessionId) async {
    final Uri url =
        Uri.parse('$baseUrl/sessionId/decline?sessionId=$sessionId');
    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);
      return Session.fromJson(data);
    } else {
      throw Exception("Failed to accept request");
    }
  }
}
