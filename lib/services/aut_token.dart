class AuthToken {
  static String? _token;

  // Set the token after successful login
  static void setToken(String token) {
    _token = token;
  }

  // Get the current token
  static String? getToken() {
    return _token;
  }

  // Clear the token (useful for logout)
  static void clearToken() {
    _token = null;
  }

  // Helper method to get headers with token
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }
}
