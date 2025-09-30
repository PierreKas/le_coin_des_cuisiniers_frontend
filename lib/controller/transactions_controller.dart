// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
// import 'package:le_coin_des_cuisiniers_app/models/products.dart';
// import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
// import 'package:le_coin_des_cuisiniers_app/services/transaction_service.dart';

// class TransactionsController extends ChangeNotifier {
//   final TransactionService _transactionService = TransactionService();
//   static List<Product> productsList = [];
//   final List<Transactions> _transactionsList = [];
//   List<Transactions> get transactionsList => _transactionsList;
//   String billCode = '';
//   static bool isValidTransaction(Transactions transaction) {
//     return transaction.productCode!.isNotEmpty &&
//         transaction.quantity != null &&
//         transaction.quantity! > 0;
//   }

//   Future<void> addItemOnTheBill(
//       Transactions transaction, BuildContext context) async {
//     if (!isValidTransaction(transaction)) {
//       MySnackBar.showErrorMessage(
//           'La quantité doit etre supériere à 0', context);
//     }
//     _transactionsList.add(transaction);

//     notifyListeners();
//   }

//   void updateTransaction(Transactions transaction, BuildContext context) {
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

//   Future<double> dailyTotal(String date) async {
//     double dailyTotal = await _transactionService.getDailyTotal(date);

//     return dailyTotal;
//   }

//   Future<double> monthlyTotal(String month) async {
//     double monthlyTotal = await _transactionService.getMonthlyTotal(month);

//     return monthlyTotal;
//   }

//   Future<double> generalTotalSold() async {
//     double generalTotalSold = await _transactionService.getGeneralTotalSold();
//     print('Tot: $generalTotalSold ');
//     return generalTotalSold;
//   }

//   void deleteTransaction(Transactions transaction, BuildContext context) {
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

//   Future<Transactions?> getTransactionByTransId(
//       int transId, BuildContext context) async {
//     try {
//       // Search for the transaction in the in-memory list
//       Transactions? transaction = _transactionsList
//           .cast<Transactions?>()
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
//     TransactionService transactionService = TransactionService();

//     try {
//       Map<String, dynamic> result = await transactionService
//           .saveTransactionBatch(transactionsList, context);
//       billCode = result['billCode'];
//       MySnackBar.showSuccessMessage('Transaction(s) enregistrée(s)', context);
//     } catch (e, stackTrace) {
//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite, enregistrement échoué', context);

//       print('Error: $e');
//       log('Error during transaction save: $e',
//           error: e, stackTrace: stackTrace);
//     }
//   }

//   void clearTransactions() {
//     transactionsList.clear();
//     notifyListeners();
//   }
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/services/transaction_service.dart';

class TransactionsController extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  static List<Product> productsList = [];
  final List<Transactions> _transactionsList = [];
  List<Transactions> get transactionsList => _transactionsList;
  String billCode = '';

  static bool isValidTransaction(Transactions transaction) {
    bool isValid = transaction.productCode != null &&
        transaction.productCode!.isNotEmpty &&
        transaction.quantity != null &&
        transaction.quantity! > 0 &&
        transaction.sellingDate != null;

    print(
        'Transaction validation: productCode=${transaction.productCode}, quantity=${transaction.quantity}, isValid=$isValid');

    return isValid;
  }

  Future<void> addItemOnTheBill(
      Transactions transaction, BuildContext context) async {
    // Add debug print to see the transaction being added
    print(
        'Attempting to add transaction: ${transaction.productCode}, quantity: ${transaction.quantity}');

    if (!isValidTransaction(transaction)) {
      MySnackBar.showErrorMessage(
          'La quantité doit être supérieure à 0', context);
      return; // FIXED: Added return to stop execution if validation fails
    }

    _transactionsList.add(transaction);
    print(
        'Transaction added successfully. Total transactions: ${_transactionsList.length}');

    notifyListeners();
  }

  void updateTransaction(Transactions transaction, BuildContext context) {
    if (transaction.productCode == null) {
      MySnackBar.showErrorMessage(
          'Veuillez entrer le code du produit', context);
      return;
    }

    int index = _transactionsList
        .indexWhere((trans) => trans.productCode == transaction.productCode);
    if (index == -1) {
      MySnackBar.showErrorMessage('produit non trouvé', context);
      return;
    }

    _transactionsList[index] = transaction;
    MySnackBar.showSuccessMessage('Données du produit à jour', context);
    notifyListeners();
  }

  Future<double> dailyTotal(String date) async {
    double dailyTotal = await _transactionService.getDailyTotal(date);
    return dailyTotal;
  }

  Future<double> monthlyTotal(String month) async {
    double monthlyTotal = await _transactionService.getMonthlyTotal(month);
    return monthlyTotal;
  }

  Future<double> generalTotalSold() async {
    double generalTotalSold = await _transactionService.getGeneralTotalSold();
    print('Tot: $generalTotalSold ');
    return generalTotalSold;
  }

  void deleteTransaction(Transactions transaction, BuildContext context) {
    try {
      // Find the index of the transaction to be deleted
      int index = _transactionsList.indexWhere(
          (trans) => trans.transactionId == transaction.transactionId);

      if (index != -1) {
        // Remove the transaction from the list
        _transactionsList.removeAt(index);
        MySnackBar.showSuccessMessage(
            'Transaction supprimée avec succès', context);
        notifyListeners(); // Notify listeners to update the UI
      } else {
        MySnackBar.showErrorMessage('Transaction introuvable', context);
      }
    } catch (e) {
      MySnackBar.showErrorMessage(
          'Une erreur est survenue lors de la suppression de la transaction',
          context);
      print('Error deleting transaction: $e');
    }
  }

  Future<Transactions?> getTransactionByTransId(
      int transId, BuildContext context) async {
    try {
      // Search for the transaction in the in-memory list
      Transactions? transaction = _transactionsList
          .cast<Transactions?>()
          .firstWhere((trans) => trans?.transactionId == transId,
              orElse: () => null);

      if (transaction == null) {
        MySnackBar.showErrorMessage('Transaction introuvable', context);
        return null;
      }

      print('Transaction fetched: ${transaction.toString()}');
      return transaction;
    } catch (e) {
      MySnackBar.showErrorMessage(
          'Une erreur s\'est produite lors de la récupération de la transaction',
          context);
      print('Error fetching transaction: $e');
      return null;
    }
  }

  Future<void> insertTheBillInTheDB(BuildContext context) async {
    // Add validation before attempting to save
    if (_transactionsList.isEmpty) {
      MySnackBar.showErrorMessage(
          'Aucune transaction à enregistrer. Ajoutez au moins un produit.',
          context);
      return;
    }

    print(
        'Attempting to save ${_transactionsList.length} transactions to database');

    TransactionService transactionService = TransactionService();

    try {
      print("Transaction List ${transactionsList.toString()}");
      Map<String, dynamic> result = await transactionService
          .saveTransactionBatch(transactionsList, context);
      if (result.isEmpty) {
        print('Empty Transactions');
      } else {
        print("Result $result");
      }
      billCode = result['billCode'];
      MySnackBar.showSuccessMessage('Transaction(s) enregistrée(s)', context);
    } catch (e, stackTrace) {
      MySnackBar.showErrorMessage(
          'Une erreur s\'est produite, enregistrement échoué', context);

      print('Error: $e');
      log('Error during transaction save: $e',
          error: e, stackTrace: stackTrace);
    }
  }

  void clearTransactions() {
    transactionsList.clear();
    notifyListeners();
  }
}
