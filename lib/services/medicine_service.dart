import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sickle_cell_app/models/medicine.dart';

class MedicineService {
  final String baseUrl =
      'http://localhost:3000/sicklecare-be/api/medicineRecord';

  Future<MedicineData?> createMedicineData(MedicineData medicineData) async {
    final Uri url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(medicineData.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return MedicineData.fromJson(data);
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Medicine submission failed");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to submit the data! Error: $e");
    }
  }
}
