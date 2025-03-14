import 'dart:io';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/appbar_text.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/dashboard/dashboard_home.dart';
import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';
import 'package:le_coin_des_cuisiniers_app/views/acceuil.dart';
import 'package:le_coin_des_cuisiniers_app/views/login.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/add_transactions.dart';
import 'package:le_coin_des_cuisiniers_app/views/user/users_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // // Define pages for navigation
  // final List<Widget> _pages = [
  //   const Acceuil(),
  //   //if (UsersController.userRole == 'ADMIN')
  //   const ProductsList(),
  //   //if (UsersController.userRole == 'ADMIN')
  //   const UsersList(),
  //   const AddTransaction(),
  // ];
  List<Widget> get _pages {
    List<Widget> availablePages = [
      const Acceuil(),
      if (UsersController.userRole == 'ADMIN') const ProductsList(),
      if (UsersController.userRole == 'ADMIN') const UsersList(),
      const AddTransaction(),
    ];
    return availablePages;
  }

  List<BottomNavigationBarItem> get _bottomNavItems {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Acceuil',
      ),
      if (UsersController.userRole == 'ADMIN')
        const BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Produits',
        ),
      if (UsersController.userRole == 'ADMIN')
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Utilisateurs',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Page des ventes',
      ),
    ];
    return items;
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
  // void _onItemTapped(int index) {
  //   // Adjust index if user is not an admin
  //   int adjustedIndex = index;
  //   if (UsersController.userRole != 'ADMIN') {
  //     // Map the index to the correct page for non-admin users
  //     if (index >= 1 && _pages.length < 4) {
  //       adjustedIndex = index + 1;
  //     }
  //   }
  //   setState(() {
  //     _selectedIndex = adjustedIndex;
  //   });
  // }
  void _onItemTapped(int index) {
    // Calculate the correct page index based on user role
    int adjustedIndex = 0;
    if (UsersController.userRole == 'ADMIN') {
      // Admin has full access to all pages
      adjustedIndex = index;
    } else {
      // Non-admin navigation mapping
      switch (index) {
        case 0: // Home
          adjustedIndex = 0;
          break;
        case 1: // Sales Page (for non-admin)
          adjustedIndex = _pages.length - 1;
          break;
      }
    }

    setState(() {
      _selectedIndex = adjustedIndex;
    });
  }

  Future<void> relaunchApp() async {
    // Get the current executable path
    final executable = Platform.resolvedExecutable;
    final arguments = Platform.executableArguments;

    // Relaunch the app
    await Process.start(executable, arguments);

    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MyAppBarText(content: 'Le coin des cuisiniers'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                if (UsersController.userRole == 'ADMIN' &&
                    MediaQuery.of(context).size.width > mobileWidth)
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () async {
                      // showLoadingDialog(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashboardHome()),
                      );
                    },
                    child: const Text(
                      'Dashboard',
                      style: TextStyle(color: chocolateColor),
                    ),
                  ),
                const SizedBox(
                  width: 15,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false,
                    );

                    // await relaunchApp();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
        backgroundColor: chocolateColor,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _bottomNavItems,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: chocolateColor,
      ),
    );
  }
}
