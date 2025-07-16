import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/common/models/class_model.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';

class ClassService {
  static const String baseUrl = 'http://192.168.1.14:3000/api';

  Future<List<ClassModel>> getClasses() async {
    final token = SimpleTokenService.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali.');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kelas'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> classesJson = jsonDecode(response.body);
        return classesJson.map((json) => ClassModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Gagal memuat data kelas: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat memuat data kelas: $e');
    }
  }

  Future<void> addClass(ClassModel classModel) async {
    final token = SimpleTokenService.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali.');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kelas'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(classModel.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Berhasil menambahkan kelas
        return;
      } else {
        throw Exception(
            'Gagal menambahkan kelas: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat menambahkan kelas: $e');
    }
  }

  Future<void> updateClass(ClassModel classModel) async {
    final token = SimpleTokenService.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali.');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/kelas/${classModel.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(classModel.toJson()),
      );

      if (response.statusCode == 200) {
        // Berhasil memperbarui kelas
        return;
      } else {
        throw Exception(
            'Gagal memperbarui kelas: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat memperbarui kelas: $e');
    }
  }

  Future<void> deleteClass(String id) async {
    final token = SimpleTokenService.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali.');
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/kelas/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Berhasil menghapus kelas
        return;
      } else {
        throw Exception(
            'Gagal menghapus kelas: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat menghapus kelas: $e');
    }
  }
}