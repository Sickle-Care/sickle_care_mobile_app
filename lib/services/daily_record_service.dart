import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sickle_cell_app/models/daily_report.dart';

class DailyRecordService {
  final String baseUrl = 'http://localhost:3000/sicklecare-be/api/dailyReport';

  Future<DailyReport?> getDailyReportByUserId(
      String userId, String selectedDate) async {
    final Uri url = Uri.parse(
        '$baseUrl/find/userId/date?userId=$userId&date=$selectedDate');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return DailyReport.fromJson(data);
        } else {
          return null;
        }
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
}
