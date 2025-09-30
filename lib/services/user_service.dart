import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:http/http.dart' as http;
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/users.dart';
import 'package:le_coin_des_cuisiniers_app/services/aut_token.dart';
import 'package:le_coin_des_cuisiniers_app/services/base_url.dart';

class UserService {
  // final String baseUrl = "http://localhost:8080/api/users";
  final String userBaseUrl = "$baseUrl/api/users";
  List<User> userList = [];
  String token = "";
  static String role = "";
  Future<List<User>> getAllUsers() async {
    final url = Uri.parse('$userBaseUrl/all');
    try {
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return [];
      }

      if (isTokenExpired) {
        print('Token is expired');
        return [];
      }
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $storedToken',
      });
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
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return null;
      }

      if (isTokenExpired) {
        print('Token is expired');
        return null;
      }
      final response = await http.post(
        url,
        // headers: {'Content-Type': 'application/json'},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
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
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return null;
      }

      if (isTokenExpired) {
        print('Token is expired');
        return null;
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
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
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return null;
      }

      if (isTokenExpired) {
        print('Token is expired');
        return null;
      }
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
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
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return false;
      }

      if (isTokenExpired) {
        print('Token is expired');
        return false;
      }
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return false;
  }

  Future<User?> login(
      String phoneNumber, String password, BuildContext context) async {
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

        token = jsonData['myJWT'];
        role = jsonData['role'];

        await FlutterSessionJwt.saveToken(token);
        print('Login successful');
        print('Role is $role');
        // // Store the JWT token
        // AuthToken.setToken(jsonData['myJWT']);

        // // AuthToken.setToken(token);
        // AuthToken.setUserRole(jsonData['role']);
        // UsersController.userRole = jsonData['role'];
        // Parse the LoginResponse into a User object
        return User.fromJson(jsonData);
      } else {
        dynamic errorMessage = jsonDecode(response.body);
        String error = errorMessage.toString();
        print(error);
        if (error.contains("Invalid password")) {
          MySnackBar.showErrorMessage('Mot de passe incorrect', context);
        } else if (error.contains("Phone number not found")) {
          MySnackBar.showErrorMessage('Ton numéro n\'est pas trouvé', context);
        } else if (error.contains("Blocked account")) {
          MySnackBar.showErrorMessage('Ce compte est bloqué', context);
        }
        // Handle different status codes appropriately
        // if (response.statusCode == 500 ||
        //     response.statusCode != 201 ||
        //     response.statusCode != 200) {
        //   MySnackBar.showErrorMessage('Invalid credentials', context);
        //   throw Exception('Invalid credentials');
        // } else if (response.statusCode == 403) {
        //   throw Exception('Account blocked');
        // } else {
        //   throw Exception(
        //       'Login failed with status code: ${response.statusCode}');
        // }
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
    return null;
  }

  void logout() async {
    await FlutterSessionJwt.deleteToken();
  }
}
