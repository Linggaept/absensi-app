class SimpleTokenService {
  static String? _token;
  static String? _role;
  static int? _id;

  // Simpan token dan role
  static void saveToken(String token, String role, int id) {
    _token = token;
    _role = role;
    _id = id;
  }

  // Ambil token
  static String? getToken() {
    return _token;
  }

  // Ambil ID pengguna
  static int? getUserId() {
    return _id;
  }

  // Ambil role
  static String? getRole() {
    return _role;
  }

  // Hapus token dan role (untuk logout)
  static void clearToken() {
    _token = null;
    _role = null;
    _id = null;
  }

  // Cek apakah user sudah login
  static bool isLoggedIn() {
    return _token != null && _token!.isNotEmpty;
  }
}