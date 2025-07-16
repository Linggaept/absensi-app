import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/common/models/student_model.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';

class StudentService {
  static const String baseUrl = 'http://192.168.1.14:3000/api/siswa';
  
  // Helper method to get headers with authorization
  Map<String, String> _getHeaders() {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    
    final token = SimpleTokenService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // GET - Retrieve all students
  Future<List<Student>> getStudents() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching students: $e');
    }
  }

  // POST - Add new student
  Future<void> addStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _getHeaders(),
        body: json.encode(student.toJson()),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to add student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding student: $e');
    }
  }

  // PUT - Update existing student
  Future<void> updateStudent(Student student) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${student.id}'),
        headers: _getHeaders(),
        body: json.encode(student.toJsonForUpdate()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating student: $e');
    }
  }

  // DELETE - Delete student
  Future<void> deleteStudent(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting student: $e');
    }
  }
}