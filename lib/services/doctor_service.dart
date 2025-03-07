import 'dart:convert';

import 'package:sickle_cell_app/models/user.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  final String baseUrl = 'http://localhost:3000/sicklecare-be/api/user';

  Future<List<User>> getAllDoctors() async {
    final Uri url = Uri.parse('$baseUrl/findall/doctors');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Doctors data not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }
}
