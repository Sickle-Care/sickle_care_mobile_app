import 'dart:convert';

import 'package:sickle_cell_app/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://localhost:3000/sicklecare-be/api/';

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    final Uri url = Uri.parse('${baseUrl}user/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestModel.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponseModel.fromJson(data);
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Invalid credentials");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<SignUpResponseModel> signUp(SignUpRequestModel user) async {
    final Uri url = Uri.parse('${baseUrl}user');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SignUpResponseModel.fromJson(data);
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Invalid credentials");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<User?> getUserDetails(String userId) async {
    final Uri url = Uri.parse('${baseUrl}user/id/?id=$userId');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "User data not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }


  Future<User?> updateUserDetails(String userId, SignUpRequestModel user) async {
    final Uri url = Uri.parse('${baseUrl}update/user/id/?id=$userId');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "User data not found");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }
}
