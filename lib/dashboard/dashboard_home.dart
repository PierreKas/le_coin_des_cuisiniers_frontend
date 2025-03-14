import 'dart:async';

import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/appbar_text.dart';
import 'package:le_coin_des_cuisiniers_app/components/drawer_label.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_content.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_hearder.dart';
import 'package:le_coin_des_cuisiniers_app/dashboard/views/low_stock_product_list.dart';
import 'package:le_coin_des_cuisiniers_app/dashboard/views/out_of_stock_product_list.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/models/users.dart';
import 'package:le_coin_des_cuisiniers_app/services/product_service.dart';
import 'package:le_coin_des_cuisiniers_app/services/transaction_service.dart';
import 'package:le_coin_des_cuisiniers_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_coin_des_cuisiniers_app/dashboard/views/products_list_dashboard.dart';
import 'package:le_coin_des_cuisiniers_app/views/user/users_list.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  @override
  void initState() {
    super.initState();
    loadProductList();
    loadLowStockProductList();
    loadOutOfProductList();
    loadUserList();
    loadDailyTransaction();
  }

  List<Product>? _productList = [];
  List<Product>? _outOfStockProductList = [];
  List<Product>? _lowStockProductList = [];
  List<User> _userList = [];
  List<Transactions> _dailyTransactionList = [];
  //DateTime theDate = DateTime.now();
  final TextEditingController _searchedDate = TextEditingController();
  DateTime? _selectedDate;
  double generalTotal = 0;
  final dateFormatter = DateFormat('yyyy-MM-dd');

  Future<void> loadProductList() async {
    _productList = await ProductService().getAllProducts();
    setState(() {});
  }

  Future<void> loadLowStockProductList() async {
    _lowStockProductList = await ProductService().getLowStockProducts();
    setState(() {});
  }

  Future<void> loadOutOfProductList() async {
    _outOfStockProductList = await ProductService().getOutOfStockProducts();
    setState(() {});
  }

  Future<void> loadUserList() async {
    _userList = await UserService().getAllUsers();
    setState(() {});
  }

  Future<void> loadDailyTransaction() async {
    String formattedDate = dateFormatter.format(_selectedDate!);
    _dailyTransactionList =
        await TransactionService().getTransactionByDate(formattedDate);
    setState(() {});
  }

  Widget mobile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyTextContent(content: 'Dashboard'),
            const SizedBox(
              height: 25,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 430,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                              )
                            ]),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: Text(
                                'Dites moi ce que vous voulezque je mette ici comme information(Ce qui va la peine bien sur)'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 430,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                              )
                            ]),
                        child: dailyReport(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget desktop() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyTextHeader(content: 'Le coin des cuisiniers'),
          const SizedBox(
            height: 15,
          ),
          const MyTextContent(content: 'Dashboard'),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: upCards(
                  'Nombre des produits',
                  _productList!.length.toString(),
                  Colors.green.shade100,
                  Icons.inventory,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductsList()));
                  },
                  Colors.green,
                  context,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: upCards(
                  'Faible stock',
                  _lowStockProductList!.length.toString(),
                  Colors.orange.shade100,
                  Icons.warning,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LowStockProductsList(),
                      ),
                    );
                  },
                  Colors.orange,
                  context,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: upCards(
                  'Stock épuisé',
                  _outOfStockProductList!.length.toString(),
                  Colors.red.shade100,
                  Icons.error_outline,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OutOfStockProductsList(),
                      ),
                    );
                  },
                  Colors.red,
                  context,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: upCards(
                  'Utilisateurs',
                  _userList.length.toString(),
                  Colors.green.shade100,
                  Icons.people,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UsersList(),
                      ),
                    );
                  },
                  Colors.green,
                  context,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 430,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 4,
                                )
                              ]),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30.0),
                              child: Text(
                                  'Da Chino ni ambiye détails financiers zenye ni tiye apa'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          height: 430,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 4,
                                )
                              ]),
                          child: dailyReport(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }

  Widget dailyReport() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyTextContent(content: 'Rapport Journalier'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextFormField(
                          controller: _searchedDate,
                          cursorColor: chocolateColor,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Sélectionner une date',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.calendar_today,
                              color: chocolateColor,
                              size: 20,
                            ),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2026),
                              initialDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: chocolateColor,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: chocolateColor,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            setState(() {
                              _selectedDate = pickedDate;
                              _searchedDate.text = _selectedDate!
                                  .toIso8601String()
                                  .split('T')
                                  .first;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        loadDailyTransaction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: chocolateColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.search, size: 20),
                      label: const Text(
                        'Rechercher',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 430,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _dailyTransactionList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune vente pour cette date',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _dailyTransactionList.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final transaction = _dailyTransactionList[index];
                            final total = (transaction.quantity ?? 0) *
                                (transaction.unitPrice ?? 0);

                            // for (var i = 0; i < _dailyTransactionList.length; i++) {
                            //   final totalBytransaction = (transaction.quantity ?? 0) *
                            //       (transaction.unitPrice ?? 0);
                            //   generalTotal += totalBytransaction;
                            // }
                            for (var transaction in _dailyTransactionList) {
                              final transactionTotal =
                                  (transaction.quantity ?? 0) *
                                      (transaction.unitPrice ?? 0);
                              generalTotal += transactionTotal;
                            }
                            // print('Daily total: $generalTotal \$');
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${transaction.productName}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Qté: ${transaction.quantity}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Prix: ${transaction.unitPrice} \$',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Total: $total \$',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: chocolateColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Text('Total journalier = $generalTotal'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget upCards(
      final String title,
      final String value,
      final Color iconBackgroundColor,
      final IconData icon,
      void Function()? onTap,
      final Color? valueColor,
      BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: chocolateColor,
                ),
              ),
              IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.arrow_forward),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // double currentWidth = MediaQuery.of(context).size.width;
    // double currentHeight = MediaQuery.of(context).size.height;
    final drawer = ListView(
      children: [
        SizedBox(
          height: 160,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Image.asset(
                  height: 60,
                  width: 60,
                  'assets/logo.PNG',
                ),
                const SizedBox(
                  height: 50,
                ),
                // const MyTextHeader(content: 'Kingdom Believers Church')
              ],
            ),
          ),
        ),
        ListTile(
          title: const DrawerLabel(labelContent: 'Tout les produits'),
          leading: const Icon(Icons.checklist_rtl_outlined),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProductsList()));
          },
        ),
        const Divider(
          color: Colors.white,
          height: 20,
          //thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
          title: const DrawerLabel(labelContent: 'Faible stock'),
          leading: const Icon(Icons.checklist_rtl_outlined),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LowStockProductsList()));
          },
        ),
        const Divider(
          color: Colors.white,
          height: 20,
          //thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
          title: const DrawerLabel(labelContent: 'Stock épuisé'),
          leading: const Icon(Icons.checklist_rtl_outlined),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OutOfStockProductsList()));
          },
        ),
        const Divider(
          color: Colors.white,
          height: 20,
          //thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
          title: const DrawerLabel(labelContent: 'Utilisateur'),
          leading: const Icon(Icons.checklist_rtl_outlined),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UsersList()));
          },
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const MyAppBarText(content: 'Le coin des cuisiniers'),
        backgroundColor: chocolateColor,
      ),
      body: desktop(),
    );
  }
}
