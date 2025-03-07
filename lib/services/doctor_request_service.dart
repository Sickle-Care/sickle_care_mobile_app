import 'dart:convert';

import 'package:sickle_cell_app/models/doctor_request.dart';
import 'package:http/http.dart' as http;

class DoctorRequestService {
  final String baseUrl =
      'http://localhost:3000/sicklecare-be/api/doctorRequest';

  Future<DoctorRequest> createRequest(DoctorRequest request) async {
    final Uri url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DoctorRequest.fromJson(data);
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        return DoctorRequest.fromJson(errorData);
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }
}
