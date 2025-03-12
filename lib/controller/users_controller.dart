import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/database/database_helper.dart';
import 'package:le_coin_des_cuisiniers_app/models/users.dart';
import 'package:le_coin_des_cuisiniers_app/services/user_service.dart';
import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';

class UsersController {
  UserService productHistory = UserService();
  static String userRole = '';
  Future<void> addUser(User user, BuildContext context) async {
    if (user.fullName.isEmpty ||
        user.email.isEmpty ||
        user.phoneNumber.isEmpty ||
        user.address.isEmpty ||
        user.password!.isEmpty) {
      MySnackBar.showErrorMessage('Complète toutes les cases', context);
    } else {
      await productHistory.addUser(user);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  Future<List<User>> getUsers(BuildContext context) async {
    List<User> allUsers = await productHistory.getAllUsers();
    print(allUsers);
    return allUsers;
  }

  Future<void> updateUser(int userId, User user, BuildContext context) async {
    await productHistory.updateUser(userId, user);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<void> deleteUser(int userId, BuildContext context) async {
    await productHistory.deleteUser(userId);
  }

  // Future<bool> login(
  //     String phoneNumber, String password, BuildContext context) async {
  //   if (phoneNumber.isEmpty || password.isEmpty) {
  //     MySnackBar.showErrorMessage('Veuillez remplir tous les champs', context);
  //     return false;
  //   }

  //   final user = await DatabaseHelper.instance
  //       .authenticateUser(phoneNumber, password, context);

  //   if (user != null) {
  //     // Navigate to HomePage or desired screen
  //     userRole = user.role;
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => const HomePage()));
  //     return true;
  //   } else {
  //     MySnackBar.showErrorMessage('Le login a échoué', context);

  //     return false;
  //   }
  // }
}
