import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/appbar_text.dart';
import 'package:le_coin_des_cuisiniers_app/components/search_textfields.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_content.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/services/product_service.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/product_restock_history.dart';

class OutOfStockProductsList extends StatefulWidget {
  const OutOfStockProductsList({super.key});

  @override
  State<OutOfStockProductsList> createState() => _OutOfStockProductsListState();
}

class _OutOfStockProductsListState extends State<OutOfStockProductsList> {
  @override
  void initState() {
    super.initState();
    loadAllProducts();
  }

  List<Product> productsList = [];
  List<Product> filteredProductsList = [];
  // final ProductService _productService = ProductService();

  TextEditingController searchController = TextEditingController();
  Future<List<Product>> loadAllProducts() async {
    try {
      final products = await ProductService()
          .getOutOfStockProducts(); //(await _productService.getAllProducts())!;
      productsList = products!;
      filteredProductsList = productsList;
      setState(() {});
      print('List of products: ${productsList.toList()}');
      return productsList;
    } on Exception catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Future<List<Product>> loadLowStockProducts() async {
  //   productsList = (await _databaseServices.getLowStockProducts())!;
  //   filteredProductsList = productsList;
  //   setState(() {});
  //   return productsList;
  // }

  // Future<List<Product>> loadOutOfProducts() async {
  //   productsList = (await _databaseServices.getOutOfStockProducts())!;
  //   filteredProductsList = productsList;
  //   setState(() {});
  //   return productsList;
  // }

  void filterProducts(String query) {
    final filtered = productsList.where((product) {
      final productName = product.productName?.toLowerCase() ?? "";
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

  List<DataRow> getRows(List<Product> productsList) {
    final dateFormatter = DateFormat('dd-MM-yyyy');

    return productsList.map((product) {
      return DataRow(cells: [
        DataCell(Text(
          product.productCode ?? "",
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          product.productName ?? "",
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
          dateFormatter.format(product.purchasedDate ?? DateTime.now()),
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Text(
          product.brand ?? "",
          style: const TextStyle(color: chocolateColor),
        )),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: getQuantityColor(product.remainingQuantity ?? 0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            product.remainingQuantity.toString(),
            style: TextStyle(
                color: getQuantityColor(product.remainingQuantity ?? 0)
                    .withGreen(100)
                    .withRed(100)
                    .withBlue(100),
                fontWeight: FontWeight.bold),
          ),
        )),
        DataCell(
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductRestockHistory(
                              prCode: product.productCode ?? "",
                            )));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Historique de ravitaillement',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
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
      appBar: AppBar(
        backgroundColor: chocolateColor,
        title: const MyAppBarText(
          content: 'Le coin des cuisiniers',
        ),
      ),
      backgroundColor: Colors.white,
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
                      const MyTextContent(
                          content: 'Liste des produits à stock épuisé'),
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
