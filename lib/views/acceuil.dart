import 'dart:async';
import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/components/search_textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  static const chocolateColor = Color.fromARGB(255, 118, 76, 46);

  @override
  void initState() {
    super.initState();
    getProductLists();
  }

  List<Product> productsList = [];
  List<Product> filteredProductsList = [];
  TextEditingController searchController = TextEditingController();

  Future<List<Product>> getProductLists() async {
    productsList = await ProductController().getProducts();
    filteredProductsList = productsList;
    setState(() {});
    return productsList;
  }

  void filterProducts(String query) {
    final filtered = productsList.where((product) {
      final productName = product.productName?.toLowerCase() ?? '';
      final input = query.toLowerCase();
      return productName.contains(input);
    }).toList();

    setState(() {
      filteredProductsList = filtered;
    });
  }

  Color getQuantityColor(int quantity) {
    if (quantity > 40) return Colors.green.shade100;
    if (quantity > 20) return Colors.orange.shade100;
    return Colors.red.shade100;
  }

  Widget dataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(chocolateColor),
          dataRowHeight: 65,
          columnSpacing: 30,
          horizontalMargin: 20,
          columns: const [
            DataColumn(
              label: Text('Code du produit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Nom du produit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Prix de vente',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Marque',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Quantité restante',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
          rows: filteredProductsList.map((Product product) {
            return DataRow(
              cells: [
                DataCell(Text(
                  product.productCode!,
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  product.productName!,
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  '${product.sellingPrice?.toStringAsFixed(2)} \$',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  product.brand!,
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: getQuantityColor(product.remainingQuantity!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.remainingQuantity.toString(),
                      style: TextStyle(
                        color: getQuantityColor(product.remainingQuantity!)
                            .withGreen(100)
                            .withRed(100)
                            .withBlue(100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Liste des produits',
                        style: TextStyle(
                          color: chocolateColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: MySearchTextField(
                          onChanged: filterProducts,
                          controller: searchController,
                          enabled: true,
                          hintText: 'Chercher un produit',
                          obscureText: false,
                          prefixIcon: Icons.search,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: dataTable(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/logo.PNG',
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
