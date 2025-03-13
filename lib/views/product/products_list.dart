import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/search_textfields.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_content.dart';
import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/add_product.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/product_restock_history.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/restock.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/update_product.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
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
    final columns = [
      'Code du produit',
      'Nom du produit',
      'Prix d\'achat',
      'Autres dépenses',
      'Prix de revient',
      'Prix de vente',
      'Bénefice estimé',
      'Quantité acheté',
      'Date d\'achat',
      'Marque',
      'Quantité restante',
      'Actions 1',
      'Actions 2',
    ];
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(chocolateColor),
          dataRowHeight: 65,
          columnSpacing: 30,
          horizontalMargin: 20,
          columns: getColumns(columns),
          rows: getRows(filteredProductsList),
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns
        .map((String column) => DataColumn(
              label: Text(
                column,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ))
        .toList();
  }

  void _showDeleteConfirmationDialog(int productId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Veux-tu réellement supprimé ce produit?\n Toutes ses données seront perdues'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Non',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Dismiss the dialog first
                Navigator.of(dialogContext).pop();

                // Perform the deletion
                ProductController().deleteProduct(productId, context);
              },
              child: const Text(
                'Oui',
                style: TextStyle(color: Color.fromARGB(255, 70, 103, 71)),
              ),
            ),
          ],
        );
      },
    );
  }

  List<DataRow> getRows(List<Product> productsList) {
    final dateFormatter = DateFormat('dd-MM-yyyy');

    return productsList.map((Product product) {
      return DataRow(cells: [
        DataCell(Text(
          product.productCode!,
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          product.productName!,
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          '${product.purchasePrice.toString()} \$',
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          '${product.otherExpenses.toString()} \$',
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          '${((product.purchasePrice ?? 0.0) + (product.otherExpenses ?? 0.0)).toString()} \$',
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          '${product.sellingPrice.toString()} \$',
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          '${((product.sellingPrice ?? 0.0) - ((product.purchasePrice ?? 0.0) + (product.otherExpenses ?? 0.0))).toStringAsFixed(3)} \$',
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          product.purchasedQuantity.toString(),
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          dateFormatter.format(product.purchasedDate!),
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          product.brand!,
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                fontWeight: FontWeight.bold),
          ),
        )),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Restock(
                                  prCode: product.productCode!,
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Ravitailler le stock',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    // const Icon(Icons.inventory, color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductRestockHistory(
                                  prCode: product.productCode!,
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Historique',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    // const Icon(Icons.history_edu, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProduct(
                                  productCode: product.productCode!,
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit, color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _showDeleteConfirmationDialog(product.id!),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  List<DataCell> getCells(List<dynamic> cells) {
    return cells
        .map((data) => DataCell(
              Text('$data'),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Center(
      //       child: MyTextHeader(content: 'Le coin des cuisiniers')),
      //   backgroundColor: Colors.white,
      // ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 5,
                          //  offset: Offset(0, 3),
                        )
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MyTextContent(content: 'Liste des produits'),
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
                      MyButtons(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddProduct()),
                          );
                        },
                        text: 'Ajouter un nouveau produit',
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
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
              opacity: 0.5,
              child: Image.asset(
                'assets/logo.PNG',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
