import 'dart:convert';

import 'package:sickle_cell_app/models/blog.dart';
import 'package:http/http.dart' as http;

class BlogService {
  final String baseUrl = 'http://localhost:3000/sicklecare-be/api/blog';

  Future<Blog> createBlog(Blog request) async {
    final Uri url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Blog.fromJson(data);
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        return Blog.fromJson(errorData);
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data! Error: $e");
    }
  }

  Future<List<Blog>> getAllBlogs() async {
    final Uri url = Uri.parse('$baseUrl/findall/');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Blog.fromJson(json)).toList();
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
}
