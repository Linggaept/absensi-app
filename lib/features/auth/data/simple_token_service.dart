class SimpleTokenService {
  static String? _token;
  static String? _role;

  // Simpan token dan role
  static void saveToken(String token, String role) {
    _token = token;
    _role = role;
  }

  // Ambil token
  static String? getToken() {
    return _token;
  }

  // Ambil role
  static String? getRole() {
    return _role;
  }

  // Hapus token dan role (untuk logout)
  static void clearToken() {
    _token = null;
    _role = null;
  }

  // Cek apakah user sudah login
  static bool isLoggedIn() {
    return _token != null && _token!.isNotEmpty;
  }
}