// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
// import 'package:le_coin_des_cuisiniers_app/database/database_helper.dart';
// import 'package:le_coin_des_cuisiniers_app/models/products.dart';
// import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
// import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';

// class TransactionsController extends ChangeNotifier {
//   static List<Product> productsList = [];
//   final List<Transaction> _transactionsList = [];
//   List<Transaction> get transactionsList => _transactionsList;
//   Future<void> addItemOnTheBill(
//       Transaction transaction, BuildContext context) async {
//     _transactionsList.add(transaction);
//     print('Adding transaction:');
//     print('Product Code: ${transaction.productCode}');
//     print('Other Details: ${transaction.toString()}');
//     notifyListeners();
//   }

//   void updateTransaction(Transaction transaction, BuildContext context) {
//     if (transaction.productCode == null) {
//       MySnackBar.showErrorMessage(
//           'Veuillez entrer le code du produit', context);
//       return;
//     }

//     int index = _transactionsList
//         .indexWhere((trans) => trans.productCode == transaction.productCode);
//     if (index == -1) {
//       MySnackBar.showErrorMessage('produit non trouvé', context);
//       return;
//     }

//     _transactionsList[index] = transaction;
//     MySnackBar.showSuccessMessage('Données du produit à jour', context);
//     notifyListeners();
//   }

//   void deleteTransaction(Transaction transaction, BuildContext context) {
//     try {
//       // Find the index of the transaction to be deleted
//       int index = _transactionsList.indexWhere(
//           (trans) => trans.transactionId == transaction.transactionId);

//       if (index != -1) {
//         // Remove the transaction from the list
//         _transactionsList.removeAt(index);
//         MySnackBar.showSuccessMessage(
//             'Transaction supprimée avec succès', context);
//         notifyListeners(); // Notify listeners to update the UI
//       } else {
//         MySnackBar.showErrorMessage('Transaction introuvable', context);
//       }
//     } catch (e) {
//       MySnackBar.showErrorMessage(
//           'Une erreur est survenue lors de la suppression de la transaction',
//           context);
//       print('Error deleting transaction: $e');
//     }
//   }

//   Future<Transaction?> getTransactionByTransId(
//       int transId, BuildContext context) async {
//     try {
//       // Search for the transaction in the in-memory list
//       Transaction? transaction = _transactionsList
//           .cast<Transaction?>()
//           .firstWhere((trans) => trans?.transactionId == transId,
//               orElse: () => null);

//       if (transaction == null) {
//         MySnackBar.showErrorMessage('Transaction introuvable', context);
//         return null;
//       }

//       print('Transaction fetched: ${transaction.toString()}');
//       return transaction;
//     } catch (e) {
//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite lors de la récupération de la transaction',
//           context);
//       print('Error fetching transaction: $e');
//       return null;
//     }
//   }

//   Future<void> insertTheBillInTheDB(BuildContext context) async {
//     try {
//       final db = await DatabaseHelper.instance.database;

//       // Generate bill code
//       final random = Random();
//       final randomNumber = random.nextInt(900000) + 100000;
//       String billCode = '${DateTime.now().toIso8601String()}_$randomNumber';

//       // Iterate over transactions and find the corresponding product ID
//       for (var transaction in _transactionsList) {
//         // Find the product ID based on the product code
//         final productResult = await db.query('products',
//             where: 'product_code = ?', whereArgs: [transaction.productCode]);

//         if (productResult.isNotEmpty) {
//           // Get the product ID from the query result
//           final productId = productResult.first['id'];

//           // Insert transaction with the found product ID
//           await db.insert('transactions', {
//             'product_code': transaction.productCode,
//             'product_Id': productId,
//             'quantity': transaction.quantity,
//             'bill_code': billCode,
//             'selling_date': transaction.sellingDate?.toIso8601String(),
//             'total_price': transaction.totalPrice,
//           });
//         } else {
//           // Handle case where product is not found
//           throw Exception(
//               'Product not found for code: ${transaction.productCode}');
//         }
//       }

//       // Clear the transactions list and notify
//       _transactionsList.clear();
//       notifyListeners();
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//       MySnackBar.showSuccessMessage('Marchandise(s) vendue(s)', context);
//     } catch (e) {
//       if (e.toString().contains('Le stock n\'est pas suffisant')) {
//         MySnackBar.showErrorMessage('Le stock n\'est pas suffisant', context);
//       } else {
//         print('Error inserting transactions: $e');
//         MySnackBar.showErrorMessage('Une erreur est survenue', context);
//       }
//     }
//   }
// }
