import 'dart:convert';

import 'package:sickle_cell_app/models/health_record.dart';
import 'package:http/http.dart' as http;

class HealthrecordService {
  final String baseUrl = 'http://localhost:3000/sicklecare-be/api/healthrecord';

  Future<HealthRecord?> getHealthDetails(
      String userId, String selectedDate) async {
    final Uri url =
        Uri.parse('$baseUrl/userId/date?userId=$userId&date=$selectedDate');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(response.body);
        return HealthRecord.fromJson(data);
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Healthdata data not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<HealthRecord> updateWaterIntake(
      WaterIntake waterIntake, String recordId) async {
    final Uri url = Uri.parse('$baseUrl/patch/waterIntake?recordId=$recordId');
    final response = await http.patch(
      url,
      body: jsonEncode(waterIntake.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HealthRecord.fromJson(data);
    } else {
      throw Exception('Failed to update water intake');
    }
  }

  Future<HealthRecord> updateAlchoholIntake(
      AlcoholConsumption alcoholConsumption, String recordId) async {
    final Uri url =
        Uri.parse('$baseUrl/patch/alcoholConsumption?recordId=$recordId');
    final response = await http.patch(
      url,
      body: jsonEncode(alcoholConsumption.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HealthRecord.fromJson(data);
    } else {
      throw Exception('Failed to update alchohol consumption');
    }
  }

  Future<HealthRecord> updateSleep(Sleep sleep, String recordId) async {
    final Uri url = Uri.parse('$baseUrl/patch/sleep?recordId=$recordId');
    final response = await http.patch(
      url,
      body: jsonEncode(sleep.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HealthRecord.fromJson(data);
    } else {
      throw Exception('Failed to update sleep');
    }
  }

  Future<HealthRecord> updateDiet(Diet diet, String recordId) async {
    final Uri url = Uri.parse('$baseUrl/patch/diet?recordId=$recordId');
    final response = await http.patch(
      url,
      body: jsonEncode(diet.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HealthRecord.fromJson(data);
    } else {
      throw Exception('Failed to update sleep');
    }
  }

  Future<HealthRecord> updateMedicine(
      Medicine medicine, String recordId) async {
    final Uri url = Uri.parse('$baseUrl/patch/medicine?recordId=$recordId');
    final response = await http.patch(
      url,
      body: jsonEncode(medicine.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HealthRecord.fromJson(data);
    } else {
      throw Exception('Failed to update sleep');
    }
  }
}
