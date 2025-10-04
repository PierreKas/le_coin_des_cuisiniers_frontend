import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_content.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/update_transaction.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RecordingList extends StatefulWidget {
  final Product? product;

  const RecordingList({super.key, required this.product});

  @override
  State<RecordingList> createState() => _RecordingListState();
}

class _RecordingListState extends State<RecordingList> {
  TextEditingController _OtherExpenses = TextEditingController();
  void _showDeleteConfirmationDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Veux-tu réellement enlever ce produit de la liste d\'enregistrement ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Non',
                  style: TextStyle(color: Color.fromARGB(255, 70, 103, 71))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Provider.of<ProductController>(context, listen: false)
                    .removeProduct(product, context);
              },
              child: const Text(
                'Oui',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataTable(ProductController controller) {
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
              label: Text('Nom du Produit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Prix d\'achat',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Quantité acheté',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Prix de vente',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Date de Vente',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Action',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
          rows: controller.producttsList.map((product) {
            return DataRow(
              cells: [
                DataCell(Text(
                  '${product.productName}',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  '${product.purchasePrice} \$',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  '${product.purchasedQuantity}',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  '${product.sellingPrice} \$',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  product.purchasedDate != null
                      ? DateFormat('dd-MM-yyyy').format(product.purchasedDate!)
                      : '',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(_buildActionButtons(product)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildIconButton(
          onTap: () {
            if (UsersController.userRole != 'ADMIN') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  width: 200,
                  content: Text(
                      'Click sur "Page des ventes" pour acceder à la page des modifications'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 5),
                ),
              );
            }
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => UpdateTransaction(
            //       transId: transaction.transactionId!,
            //     ),
            //   ),
            // );
          },
          icon: Icons.edit,
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildIconButton(
          onTap: () => _showDeleteConfirmationDialog(product),
          icon: Icons.delete,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
      ),
    );
  }

  Widget _buildMobileTransactionsList(ProductController controller) {
    return ListView.builder(
      itemCount: controller.producttsList.length,
      itemBuilder: (context, index) {
        final product = controller.producttsList[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product name with larger font
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${product.productName}',
                        style: const TextStyle(
                          color: chocolateColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Price info
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${product.purchasePrice} \$',
                        style: const TextStyle(
                          color: chocolateColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Transaction details in a single row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prix: ${product.purchasedQuantity} \$',
                      style: const TextStyle(color: chocolateColor),
                    ),
                    Text(
                      'Qté: ${product.purchasedQuantity}',
                      style: const TextStyle(color: chocolateColor),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(product.purchasedDate!),
                      style:
                          const TextStyle(color: chocolateColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildIconButton(
                      onTap: () {
                        if (UsersController.userRole != 'ADMIN') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              width: 200,
                              content: Text(
                                  'Click sur "Page des ventes" pour acceder à la page des modifications'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }

                        ///To modify
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => UpdateTransaction(
                        //       transId: transaction.transactionId!,
                        //     ),
                        //   ),
                        // );
                      },
                      icon: Icons.edit,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildIconButton(
                      onTap: () => _showDeleteConfirmationDialog(product),
                      icon: Icons.delete,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _downloadBillAsPDF(
      //       Provider.of<TransactionsController>(context, listen: false)),
      //   backgroundColor: chocolateColor,
      //   child: const Icon(
      //     Icons.download_rounded,
      //     color: Colors.white,
      //   ),
      // ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Consumer<ProductController>(
                  builder: (context, controller, _) {
                    // final total = controller.producttsList.fold<double>(
                    //   0.0,
                    //   (sum, transaction) =>
                    //       sum + (transaction.totalPrice ?? 0.0),
                    // );

                    return Container(
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > mobileWidth) {
                            return const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Liste des produits',
                                  style: TextStyle(
                                    color: chocolateColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 16,
                                //     vertical: 8,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color: chocolateColor,
                                //     borderRadius: BorderRadius.circular(30),
                                //   ),
                                //   child: Text(
                                //     'Total: ${total.toStringAsFixed(2)} \$',
                                //     style: const TextStyle(
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ),
                              ],
                            );
                          } else {
                            return const Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Liste des transactions',
                                  style: TextStyle(
                                    color: chocolateColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 16,
                                //     vertical: 8,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color: chocolateColor,
                                //     borderRadius: BorderRadius.circular(30),
                                //   ),
                                //   child: Text(
                                //     'Total: ${total.toStringAsFixed(2)} \$',
                                //     style: const TextStyle(
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ),
                              ],
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Consumer<ProductController>(
                      builder: (context, controller, _) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > mobileWidth) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: _buildDataTable(controller),
                            ),
                          );
                        } else {
                          return _buildMobileTransactionsList(controller);
                        }
                      },
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Consumer<ProductController>(
                  builder: (context, controller, _) => MyButtons(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => _otherExpenseDialog());
                      await controller.insertProductsTheDB(context);

                      // _downloadBillAsPDF(Provider.of<TransactionsController>(
                      //     context,
                      //     listen: false));
                      controller.clearProducts();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const HomePage()),
                      // );
                      context.go("/home");
                    },
                    text: 'Vendre',
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

  Widget _otherExpenseDialog() {
    return AlertDialog(
      title: const MyTextContent(content: 'Autres depenses'),
      content: Column(
        children: [
          const MyTextContent(content: 'Le total des autres depenses'),
          MyTextField(
            controller: _OtherExpenses,
            enabled: true,
            hintText: 'Expenses',
            obscureText: false,
            prefixIcon: Icons.monetization_on_outlined,
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop(context);
            },
            child: const MyTextContent(
              content: 'cancel',
            )),
        MyButtons(
            onPressed: () {
              String otherExpensesStr = _OtherExpenses.text;

              ProductController.totalOtherExp =
                  double.tryParse(otherExpensesStr) ?? 0.0;
              context.pop(context);
            },
            text: 'Confirmer')
      ],
    );
  }
}
