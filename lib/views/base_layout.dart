import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';

class BaseLayout extends StatefulWidget {
  final int initialIndex;
  final List<Widget> pages;
  final Widget? initialPage; // Add this optional parameter

  const BaseLayout({
    super.key,
    required this.initialIndex,
    required this.pages,
    this.initialPage, // Optional initial page
  });

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  late int _selectedIndex;
  late List<Widget> _availablePages;

  @override
  void initState() {
    super.initState();

    // Prepare pages based on user role
    _availablePages = UsersController.userRole == 'ADMIN'
        ? widget.pages
        : [
            widget.pages[0], // Home
            widget.pages[widget.pages.length - 1] // Sales/Transaction page
          ];

    // Adjust initial index for non-admin users
    _selectedIndex = UsersController.userRole == 'ADMIN'
        ? widget.initialIndex
        : (widget.initialIndex >= _availablePages.length
            ? 0
            : widget.initialIndex);
  }

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
          adjustedIndex = _availablePages.length - 1;
          break;
      }
    }

    setState(() {
      _selectedIndex = adjustedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Le coin des cuisiniers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: chocolateColor,
      ),
      // Use initialPage if provided, otherwise use _availablePages
      body: widget.initialPage ?? _availablePages[_selectedIndex],
      bottomNavigationBar: UsersController.userRole != 'ADMIN'
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 1, // Always highlight Sales page for non-admin
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Acceuil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Page des ventes',
                ),
              ],
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              backgroundColor: chocolateColor,
            )
          : BottomNavigationBar(
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
}
