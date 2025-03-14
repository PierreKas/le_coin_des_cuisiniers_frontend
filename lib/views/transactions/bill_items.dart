import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/controller/transactions_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/update_transaction.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BillItems extends StatefulWidget {
  final Transactions? transaction;

  const BillItems({super.key, required this.transaction});

  @override
  State<BillItems> createState() => _BillItemsState();
}

class _BillItemsState extends State<BillItems> {
  Future<void> _downloadBillAsPDF(TransactionsController controller) async {
    var pdf = pw.Document();
    final dateFormatter = DateFormat('dd-MM-yyyy');
    // Calculate total
    final total = controller.transactionsList.fold<double>(
      0.0,
      (sum, transaction) => sum + (transaction.totalPrice ?? 0.0),
    );
    final ByteData logoBytes = await rootBundle.load('assets/logo.PNG');
    final Uint8List logoUint8List = logoBytes.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoUint8List);
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a6,
      build: (pw.Context context) => pw.Stack(
        children: [
          pw.Center(
            child: pw.Opacity(
              opacity: 0.5,
              child: pw.Image(logoImage, width: 100, height: 100),
            ),
          ),
          pw.Column(children: [
            pw.Text(
                '------------------------------------------------------------'),
            pw.Text('LE COIN DES CUISINIERS',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text(
                '------------------------------------------------------------'),
            pw.Text('RDC/Goma/Himbi (en face de l\'école KAMI)'),
            pw.Text('lecoindescuisiniers@gmail.com '),
            pw.Text('+243 975 477 338'),
            pw.SizedBox(height: 18),

            // Header for transactions table
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Produit'),
                  pw.Text('Prix Unit.'),
                  pw.Text('Qté'),
                  pw.Text('Total'),
                  // pw.Text('Date'),
                ]),
            pw.Text(
                '---------------------------------------------------------'),

            // Transaction items
            ...controller.transactionsList.map((transaction) => pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(transaction.productName ?? ''),
                      pw.Text('${transaction.unitPrice} \$'),
                      pw.Text('${transaction.quantity}'),
                      pw.Text('${transaction.totalPrice} \$'),

                      // pw.Text(transaction.sellingDate != null
                      //     ? DateFormat('dd-MM-yyyy')
                      //         .format(transaction.sellingDate!)
                      //     : ''),
                    ])),

            pw.Text(
                '---------------------------------------------------------'),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date:'),
                  pw.Text(dateFormatter.format(DateTime.now()),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Montant Total:'),
                  pw.Text('${total.toStringAsFixed(2)} \$',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]),
            pw.Text(
                '---------------------------------------------------------'),
            pw.SizedBox(height: 20),
            pw.Text('***************************************************'),
            pw.Text('Merci de votre confiance!'),
            pw.Text('***************************************************'),
            pw.Text('Application developée par: Pierre KASANANI',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('chikukaspierre@gmail.com ',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Jésus sauve ',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))
          ])
        ],
      ),
    ));

    try {
      // Show save file dialog
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Enregistrer la facture',
        fileName:
            'Facture_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (outputFile != null) {
        // Save the PDF
        final file = File(outputFile);
        await file.writeAsBytes(await pdf.save());

        // Show success message using SnackBar instead of Fluttertoast
        MySnackBar.showSuccessMessage(
            'Facture téléchargée avec succès', context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomePage()),
        // );
        controller.insertTheBillInTheDB(context);
      }
    } catch (e) {
      MySnackBar.showErrorMessage('Erreur lors du téléchargement', context);
      print('Erreur lors du téléchargement: ${e.toString()}');
    }
  }

  void _showDeleteConfirmationDialog(Transactions transaction) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Veux-tu réellement enlever ce produit de la liste de vente?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Non',
                  style: TextStyle(color: Color.fromARGB(255, 70, 103, 71))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Provider.of<TransactionsController>(context, listen: false)
                    .deleteTransaction(transaction, context);
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

  Widget _buildDataTable(TransactionsController controller) {
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
              label: Text('Prix Unitaire',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Quantité',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Prix Total',
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
          rows: controller.transactionsList.map((transaction) {
            return DataRow(
              cells: [
                DataCell(Text(
                  '${transaction.productName}',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  '${transaction.unitPrice} \$',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  '${transaction.quantity}',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  '${transaction.totalPrice} \$',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(Text(
                  transaction.sellingDate != null
                      ? DateFormat('dd-MM-yyyy')
                          .format(transaction.sellingDate!)
                      : '',
                  style: const TextStyle(color: chocolateColor),
                )),
                DataCell(_buildActionButtons(transaction)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Transactions transaction) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateTransaction(
                  transId: transaction.transactionId!,
                ),
              ),
            );
          },
          icon: Icons.edit,
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildIconButton(
          onTap: () => _showDeleteConfirmationDialog(transaction),
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

  Widget _buildMobileTransactionsList(TransactionsController controller) {
    return ListView.builder(
      itemCount: controller.transactionsList.length,
      itemBuilder: (context, index) {
        final transaction = controller.transactionsList[index];
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
                        '${transaction.productName}',
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
                        '${transaction.totalPrice} \$',
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
                      'Prix: ${transaction.unitPrice} \$',
                      style: const TextStyle(color: chocolateColor),
                    ),
                    Text(
                      'Qté: ${transaction.quantity}',
                      style: const TextStyle(color: chocolateColor),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(transaction.sellingDate!),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateTransaction(
                              transId: transaction.transactionId!,
                            ),
                          ),
                        );
                      },
                      icon: Icons.edit,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildIconButton(
                      onTap: () => _showDeleteConfirmationDialog(transaction),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _downloadBillAsPDF(
            Provider.of<TransactionsController>(context, listen: false)),
        backgroundColor: chocolateColor,
        child: const Icon(
          Icons.download_rounded,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Consumer<TransactionsController>(
                  builder: (context, controller, _) {
                    final total = controller.transactionsList.fold<double>(
                      0.0,
                      (sum, transaction) =>
                          sum + (transaction.totalPrice ?? 0.0),
                    );

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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Liste des transactions',
                                  style: TextStyle(
                                    color: chocolateColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chocolateColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'Total: ${total.toStringAsFixed(2)} \$',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Liste des transactions',
                                  style: TextStyle(
                                    color: chocolateColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chocolateColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'Total: ${total.toStringAsFixed(2)} \$',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                  child: Consumer<TransactionsController>(
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
                Consumer<TransactionsController>(
                  builder: (context, controller, _) => MyButtons(
                    onPressed: () {
                      controller.insertTheBillInTheDB(context);
                      // _downloadBillAsPDF(Provider.of<TransactionsController>(
                      //     context,
                      //     listen: false));
                      controller.clearTransactions();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
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
}
