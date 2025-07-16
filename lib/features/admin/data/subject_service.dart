import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/common/models/subject_model.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';

class SubjectService {
  static const String baseUrl = 'http://192.168.1.14:3000/api/matkul';

  // Get headers with authorization
  Map<String, String> _getHeaders() {
    final token = SimpleTokenService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get all subjects
  Future<List<Subject>> getSubjects() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Subject.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subjects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subjects: $e');
    }
  }

  // Add new subject
  Future<Subject> addSubject(Subject subject) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _getHeaders(),
        body: json.encode(subject.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Subject.fromJson(jsonData);
      } else {
        throw Exception('Failed to add subject: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding subject: $e');
    }
  }

  // Update subject
  Future<Subject> updateSubject(Subject subject) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${subject.id}'),
        headers: _getHeaders(),
        body: json.encode(subject.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Subject.fromJson(jsonData);
      } else {
        throw Exception('Failed to update subject: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating subject: $e');
    }
  }

  // Delete subject
  Future<void> deleteSubject(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete subject: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting subject: $e');
    }
  }
}