import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/users.dart';
import 'package:le_coin_des_cuisiniers_app/services/aut_token.dart';
import 'package:le_coin_des_cuisiniers_app/services/base_url.dart';

class UserService {
  // final String baseUrl = "http://localhost:8080/api/users";
  final String userBaseUrl = "$baseUrl/api/users";
  List<User> userList = [];

  Future<List<User>> getAllUsers() async {
    final url = Uri.parse('$userBaseUrl/all');
    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        // print(jsonDecodeData);
        userList = List<User>.from(
            jsonDecodeData.map((e) => User.fromJson(e)).toList());
        return userList;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('Try to handle null values');
  }

  Future<User?> addUser(User user) async {
    final url = Uri.parse('$userBaseUrl/add');
    try {
      final response = await http.post(
        url,
        // headers: {'Content-Type': 'application/json'},
        headers: AuthToken.getHeaders(),
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 201) {
        dynamic jsonData = jsonDecode(response.body);
        return User.fromJson(jsonData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<User?> findUserById(int userId) async {
    final url = Uri.parse('$userBaseUrl/by-id?userId=$userId');
    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        return User.fromJson(jsonData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<User?> updateUser(int userId, User user) async {
    final url = Uri.parse('$userBaseUrl/update/$userId');
    try {
      final response = await http.put(
        url,

        headers: AuthToken.getHeaders(),
        //headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        return User.fromJson(jsonData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<bool> deleteUser(int userId) async {
    final url = Uri.parse('$userBaseUrl/delete/$userId');
    try {
      final response = await http.delete(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return false;
  }

  Future<User?> login(String phoneNumber, String password) async {
    final url = Uri.parse('$userBaseUrl/login');
    try {
      // Create a login request object with phone number and password
      Map<String, dynamic> loginRequest = {
        'phoneNumber': phoneNumber,
        'password': password
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequest),
      );

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);

        // Store the JWT token
        AuthToken.setToken(jsonData['myJWT']);

        // AuthToken.setToken(token);
        AuthToken.setUserRole(jsonData['role']);
        UsersController.userRole = jsonData['role'];
        // Parse the LoginResponse into a User object
        return User.fromJson(jsonData);
      } else {
        // Handle different status codes appropriately
        if (response.statusCode == 400 || response.statusCode == 401) {
          throw Exception('Invalid credentials');
        } else if (response.statusCode == 403) {
          throw Exception('Account blocked');
        } else {
          throw Exception(
              'Login failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }
}
