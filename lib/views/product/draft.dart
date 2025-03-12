// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:le_coin_des_cuisiniers_app/database/database_helper.dart';

// class ProductRestockHistory extends StatefulWidget {
//   final String prCode;
//   const ProductRestockHistory({super.key, required this.prCode});

//   @override
//   State<ProductRestockHistory> createState() => _ProductRestockHistoryState();
// }

// class _ProductRestockHistoryState extends State<ProductRestockHistory> {
//   List<Map<String, dynamic>> historyRecords = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadHistoryData();
//   }

//   Future<void> loadHistoryData() async {
//     try {
//       // Get database instance
//       final db = await DatabaseHelper.instance.database;

//       // Query the product_history table
//       final records = await db.rawQuery('''
//         SELECT * FROM product_history 
//         WHERE product_code = ? 
//         ORDER BY new_purchased_date DESC
//       ''', [widget.prCode]);

//       setState(() {
//         historyRecords = records;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading history: $e'); // For debugging
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Historique des ravitaillements'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : historyRecords.isEmpty
//               ? const Center(
//                   child: Text('Aucun historique trouvé pour ce produit'),
//                 )
//               : SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Produit: ${historyRecords.isNotEmpty ? historyRecords.first['new_product_name'] : ''}',
//                           style: Theme.of(context).textTheme.titleLarge,
//                         ),
//                         const SizedBox(height: 20),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: historyRecords.length,
//                           itemBuilder: (context, index) {
//                             final record = historyRecords[index];
//                             final dateStr = record['new_purchased_date'];
//                             final date = DateTime.parse(dateStr);
//                             final formattedDate =
//                                 DateFormat('dd/MM/yyyy').format(date);

//                             return Card(
//                               margin: const EdgeInsets.only(bottom: 16),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Date d\'achat: $formattedDate',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const Divider(),
//                                     _buildComparisonRow(
//                                       'Quantité achetée',
//                                       record['old_purchased_quantity']
//                                           .toString(),
//                                       record['new_purchased_quantity']
//                                           .toString(),
//                                     ),
//                                     _buildComparisonRow(
//                                       'Prix d\'achat',
//                                       '${record['old_purchase_price']} FCFA',
//                                       '${record['new_purchase_price']} FCFA',
//                                     ),
//                                     _buildComparisonRow(
//                                       'Autre dépenses',
//                                       '${record['old_other_expenses']} FCFA',
//                                       '${record['new_other_expenses']} FCFA',
//                                     ),
//                                     _buildComparisonRow(
//                                       'Prix de vente',
//                                       '${record['old_selling_price']} FCFA',
//                                       '${record['new_selling_price']} FCFA',
//                                     ),
//                                     _buildComparisonRow(
//                                       'Quantité restante',
//                                       record['old_remaining_quantity']
//                                           .toString(),
//                                       record['new_remaining_quantity']
//                                           .toString(),
//                                     ),
//                                     _buildComparisonRow(
//                                       'Marque',
//                                       record['old_brand'],
//                                       record['new_brand'],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }

//   Widget _buildComparisonRow(String label, String oldValue, String newValue) {
//     if (oldValue == newValue) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4),
//         child: Row(
//           children: [
//             Text('$label: ',
//                 style: const TextStyle(fontWeight: FontWeight.w500)),
//             Text(newValue),
//           ],
//         ),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
//           Row(
//             children: [
//               const Text('Ancien: '),
//               Text(
//                 oldValue,
//                 style: const TextStyle(
//                   decoration: TextDecoration.lineThrough,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               const Text('Nouveau: '),
//               Text(
//                 newValue,
//                 style: const TextStyle(
//                   color: Colors.green,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
