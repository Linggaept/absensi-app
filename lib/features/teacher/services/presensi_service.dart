// presensi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/features/auth/data/simple_token_service.dart';
import 'package:absensi/features/teacher/models/presensi_model.dart';

class PresensiService {
  static const String baseUrl = 'http://10.5.48.67:3000';

  static Map<String, String> _getHeaders() {
    final token = SimpleTokenService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Mulai presensi
  static Future<PresensiSessionModel> mulaiPresensi(int kelasId) async {
    final url = Uri.parse('$baseUrl/api/presensi-guru/presensi/$kelasId');

    try {
      final response = await http.post(url, headers: _getHeaders());

      // FIX: Handle status code 201 (Created) sebagai sukses
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return PresensiSessionModel.fromJson(jsonData);
      } else {
        throw Exception('Gagal memulai presensi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Ambil kode presensi current
  static Future<CurrentPresensiModel> getCurrentPresensi(int kelasId) async {
    final url = Uri.parse(
      '$baseUrl/api/presensi-guru/presensi/current/$kelasId',
    );

    try {
      final response = await http.get(url, headers: _getHeaders());

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CurrentPresensiModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Gagal mengambil kode presensi: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Input manual NIS siswa
  static Future<InputManualModel> inputManualSiswa(int kelasId, int nis) async {
    final url = Uri.parse(
      '$baseUrl/api/presensi-guru/presensi/input-manual/$kelasId',
    );

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        // FIX: Mengubah 'Hadir' -> 'hadir' dan memastikan NIS dikirim sebagai string
        body: json.encode({'nis': nis.toString(), "status": 'hadir'}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return InputManualModel.fromJson(jsonData);
      } else {
        // Coba decode body untuk mendapatkan pesan error dari server
        try {
          final errorData = json.decode(response.body);
          final errorMessage =
              errorData['message'] as String? ?? 'Gagal input manual siswa';
          throw Exception(errorMessage);
        } catch (e) {
          // Jika body bukan JSON atau tidak ada 'message'
          throw Exception(
            'Gagal input manual siswa: Status ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Ambil daftar siswa presensi (realtime)
  static Future<DaftarSiswaPresensiModel> getDaftarSiswaPresensi(
    int kelasId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/presensi-guru/presensi/daftar-siswa/$kelasId',
    );

    try {
      final response = await http.get(url, headers: _getHeaders());

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DaftarSiswaPresensiModel.fromJson(jsonData);
      } else {
        throw Exception('Gagal mengambil daftar siswa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Selesai presensi
  static Future<SelesaiPresensiModel> selesaiPresensi(int kelasId) async {
    final url = Uri.parse(
      '$baseUrl/api/presensi-guru/presensi/selesai/$kelasId',
    );

    try {
      final response = await http.put(url, headers: _getHeaders());

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SelesaiPresensiModel.fromJson(jsonData);
      } else {
        throw Exception('Gagal menyelesaikan presensi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Batalkan presensi
  static Future<BatalkanPresensiModel> batalkanPresensi(int kelasId, int nis) async {
    final url = Uri.parse('$baseUrl/api/presensi-guru/presensi/batalkan/$kelasId');

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: json.encode({'nis': nis.toString()}), // Kirim NIS dalam body
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return BatalkanPresensiModel.fromJson(jsonData);
      } else {
        throw Exception('Gagal membatalkan presensi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
