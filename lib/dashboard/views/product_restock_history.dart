import 'dart:io';

import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/appbar_text.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_content.dart';
import 'package:le_coin_des_cuisiniers_app/models/product_restock_history.dart';
import 'package:le_coin_des_cuisiniers_app/services/prod_history_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

class ProductRestockHistory extends StatefulWidget {
  final String prCode;
  const ProductRestockHistory({super.key, required this.prCode});

  @override
  State<ProductRestockHistory> createState() => _ProductRestockHistoryState();
}

class _ProductRestockHistoryState extends State<ProductRestockHistory> {
  List<ProductRestockHistoryModel> _productRestockHistory = [];

  Future<List<ProductRestockHistoryModel>> getHistory(String prCode) async {
    _productRestockHistory =
        await ProductHistoryService().getHistoryByCode(prCode);
    setState(() {});
    return _productRestockHistory;
  }

  @override
  void initState() {
    getHistory(widget.prCode);
    super.initState();
  }

  Widget cardDetails(String label, String oldValue, String newValue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: chocolateColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Ancien: ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      oldValue,
                      style: const TextStyle(
                        color: chocolateColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Nouveau: ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      newValue,
                      style: const TextStyle(
                        color: chocolateColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarText(content: 'Historique de ravitaillement'),
        backgroundColor: chocolateColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              _downloadProductRestockHistory(_productRestockHistory);
            },
          ),
        ],
      ),
      body: _productRestockHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: chocolateColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const MyTextContent(
                    content:
                        'Il n\'y a aucune historique de ravitaillement pour ce produit',
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: chocolateColor.withOpacity(0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: chocolateColor.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: MyTextContent(
                    content:
                        'Produit: ${_productRestockHistory[0].newProductName}',
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _productRestockHistory.length,
                    itemBuilder: (context, index) {
                      final record = _productRestockHistory[index];
                      String date = DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(record.newPurchasedDate!));

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: chocolateColor.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: chocolateColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Date d\'achat: $date',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: chocolateColor,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              cardDetails(
                                'Quantité achetée',
                                '${record.oldPurchasedQuantity}',
                                '${record.newPurchasedQuantity}',
                              ),
                              cardDetails(
                                'Prix d\'achat',
                                '${record.oldPurchasePrice} \$',
                                '${record.newPurchasePrice} \$',
                              ),
                              cardDetails(
                                'Autres dépenses',
                                '${record.oldOtherExpenses.toString()} \$',
                                '${record.newOtherExpenses.toString()} \$',
                              ),
                              cardDetails(
                                'Prix de vente',
                                '${record.oldSellingPrice.toString()} \$',
                                '${record.newSellingPrice.toString()} \$',
                              ),
                              cardDetails(
                                'Quantité restante',
                                record.oldRemainingQuantity.toString(),
                                record.newRemainingQuantity.toString(),
                              ),
                              cardDetails(
                                'Marque',
                                '${record.oldBrand}',
                                '${record.newBrand}',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _downloadProductRestockHistory(
      List<ProductRestockHistoryModel> restockHistory) async {
    if (restockHistory.isEmpty) {
      return;
    }

    final pdf = pw.Document();
    final dateFormatter = DateFormat('dd-MM-yyyy');
//Here I load the logo image
    final ByteData logoBytes = await rootBundle.load('assets/logo.PNG');
    final Uint8List logoUint8List = logoBytes.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoUint8List);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (pw.Context context) {
          return pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoImage, width: 100, height: 100),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('LE COIN DES CUISINIERS',
                            style: pw.TextStyle(
                                fontSize: 20, fontWeight: pw.FontWeight.bold)),
                        pw.Text('RDC/Goma/Himbi (en face de l\'école KAMI)'),
                        pw.Text('lecoindescuisiniers@gmail.com'),
                        pw.Text('+243 975 477 338'),
                      ])
                ]),
            pw.SizedBox(
              height: 20,
            ),
            pw.Divider(thickness: 2),
            pw.SizedBox(height: 10),
          ]);
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      'Date d\'impression: ${dateFormatter.format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(
                    'Page ${context.pageNumber} sur ${context.pagesCount}',
                    style: const pw.TextStyle(fontSize: 10),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('Application developée par: Pierre KASANANI',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text('chikukaspierre@gmail.com',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Jésus sauve',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10)),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Historique de ravitaillement',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Produit: ${restockHistory[0].newProductName}',
                      style: const pw.TextStyle(fontSize: 16)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            ...restockHistory.map(
              (record) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(width: 1),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(10),
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Date d\'achat: ${dateFormatter.format(DateTime.parse(record.newPurchasedDate!))}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Divider(),
                        _buildRestockDetailRow(
                            'Quantité achetée',
                            '${record.oldPurchasedQuantity}',
                            '${record.newPurchasedQuantity}'),
                        _buildRestockDetailRow(
                            'Prix d\'achat',
                            '${record.oldPurchasePrice} \$',
                            '${record.newPurchasePrice} \$'),
                        _buildRestockDetailRow(
                            'Autres dépenses',
                            '${record.oldOtherExpenses} \$',
                            '${record.newOtherExpenses} \$'),
                        _buildRestockDetailRow(
                            'Prix de vente',
                            '${record.oldSellingPrice} \$',
                            '${record.newSellingPrice} \$'),
                        _buildRestockDetailRow(
                            'Quantité restante',
                            '${record.oldRemainingQuantity}',
                            '${record.newRemainingQuantity}'),
                        _buildRestockDetailRow('Marque', '${record.oldBrand}',
                            '${record.newBrand}'),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                ],
              ),
            ),
          ];
        },
      ),
    );
    // try {
    //   String? outputFile = await FilePicker.platform.saveFile(
    //     dialogTitle: 'Enregistrer la l\'historique',
    //     fileName:
    //         'Historique_${restockHistory[0].newProductName}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
    //     type: FileType.custom,
    //     allowedExtensions: ['pdf'],
    //   );
    //   if (outputFile != null) {
    //     final file = File(outputFile);
    //     await file.writeAsBytes(await pdf.save());
    //     MySnackBar.showSuccessMessage('Historique téléchargé', context);
    //   }
    // } catch (e) {
    //   MySnackBar.showErrorMessage('Erreur lors du téléchargement', context);
    //   print('Erreur lors du téléchargement: ${e.toString()}');
    // }

    try {
      if (kIsWeb) {
        // Web platform approach
        final bytes = await pdf.save();
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement()
          ..href = url
          ..style.display = 'none'
          ..download =
              'Historique_${restockHistory[0].newProductName}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
        html.document.body?.appendText(anchor.toString()); //appendChild
        anchor.click();
        html.document.body?.removeAttribute(anchor.toString()); //removeChild
        html.Url.revokeObjectUrl(url);
        MySnackBar.showSuccessMessage('Historique téléchargé', context);
      } else {
        // Mobile/Desktop platform approach
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregistrer l\'historique',
          fileName:
              'Historique_${restockHistory[0].newProductName}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        if (outputFile != null) {
          final file = File(outputFile);
          await file.writeAsBytes(await pdf.save());
          MySnackBar.showSuccessMessage('Historique téléchargé', context);
        }
      }
    } catch (e) {
      MySnackBar.showErrorMessage('Erreur lors du téléchargement', context);
      print('Erreur lors du téléchargement: ${e.toString()}');
    }
  }

  pw.Widget _buildRestockDetailRow(
      String label, String oldValue, String newValue) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Row(
                  children: [
                    pw.Text('Ancien: ',
                        style: const pw.TextStyle(color: PdfColors.grey)),
                    pw.Text(oldValue),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Row(
                  children: [
                    pw.Text('Nouveau: ',
                        style: const pw.TextStyle(color: PdfColors.grey)),
                    pw.Text(newValue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
