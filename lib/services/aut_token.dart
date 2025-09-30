// import 'dart:html' as html;

// class AuthToken {
//   // Set the token after successful login
//   static void setToken(String token) {
//     html.window.localStorage['auth_token'] = token;
//   }

//   // Get the current token
//   static String? getToken() {
//     return html.window.localStorage['auth_token'];
//   }

//   // Clear the token (useful for logout)
//   static void clearToken() {
//     html.window.localStorage.remove('auth_token');
//     html.window.localStorage.remove('role');
//   }

//   // Store user role
//   static void setUserRole(String role) {
//     html.window.localStorage['role'] = role;
//   }

//   // Get user role
//   static String? getUserRole() {
//     return html.window.localStorage['role'];
//   }

//   // Helper method to get headers with token
//   static Map<String, String> getHeaders() {
//     final token = getToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }
// }
