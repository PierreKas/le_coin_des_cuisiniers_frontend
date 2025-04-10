// class AuthToken {
//   static String? _token;

//   // Set the token after successful login
//   static void setToken(String token) {
//     _token = token;
//   }

//   // Get the current token
//   static String? getToken() {
//     return _token;
//   }

//   // Clear the token (useful for logout)
//   static void clearToken() {
//     _token = null;
//   }

//   // Helper method to get headers with token
//   static Map<String, String> getHeaders() {
//     return {
//       'Content-Type': 'application/json',
//       if (_token != null) 'Authorization': 'Bearer $_token',
//     };
//   }
// }
import 'dart:html' as html;

class AuthToken {
  // Set the token after successful login
  static void setToken(String token) {
    html.window.localStorage['auth_token'] = token;
  }

  // Get the current token
  static String? getToken() {
    return html.window.localStorage['auth_token'];
  }

  // Clear the token (useful for logout)
  static void clearToken() {
    html.window.localStorage.remove('auth_token');
  }

  // Helper method to get headers with token
  static Map<String, String> getHeaders() {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
