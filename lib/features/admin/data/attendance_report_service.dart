import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/features/admin/models/attendance_report_model.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';

class AttendanceReportService {
  static const String baseUrl = 'http://10.5.48.67:3000/api/laporan';

  // Method untuk mengambil semua laporan absensi
  static Future<List<AttendanceReportModel>> getAllReports() async {
    try {
      final token = SimpleTokenService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => AttendanceReportModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data laporan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method untuk menambahkan laporan baru
  static Future<AttendanceReportModel> createReport(AttendanceReportModel report) async {
    try {
      final token = SimpleTokenService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(report.toJson()),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return AttendanceReportModel.fromJson(jsonResponse);
      } else {
        throw Exception('Gagal membuat laporan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method untuk mengupdate laporan
  static Future<AttendanceReportModel> updateReport(int laporanId, AttendanceReportModel report) async {
    try {
      final token = SimpleTokenService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/$laporanId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(report.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return AttendanceReportModel.fromJson(jsonResponse);
      } else {
        throw Exception('Gagal mengupdate laporan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method untuk menghapus laporan
  static Future<bool> deleteReport(int laporanId) async {
    try {
      final token = SimpleTokenService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/$laporanId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Gagal menghapus laporan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}