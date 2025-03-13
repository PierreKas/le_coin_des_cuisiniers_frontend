import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/services/transaction_service.dart';

class TransactionsController extends ChangeNotifier {
  static List<Product> productsList = [];
  final List<Transactions> _transactionsList = [];
  List<Transactions> get transactionsList => _transactionsList;
  String billCode = '';
  static bool isValidTransaction(Transactions transaction) {
    return transaction.productCode!.isNotEmpty &&
        transaction.quantity != null &&
        transaction.quantity! > 0;
  }

  Future<void> addItemOnTheBill(
      Transactions transaction, BuildContext context) async {
    if (!isValidTransaction(transaction)) {
      MySnackBar.showErrorMessage(
          'La quantité doit etre supériere à 0', context);
    }
    _transactionsList.add(transaction);

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
    TransactionService transactionService = TransactionService();

    try {
      Map<String, dynamic> result =
          await transactionService.saveTransactionBatch(transactionsList);
      billCode = result['billCode'];
      MySnackBar.showSuccessMessage('Transaction(s) enregistrée(s)', context);
    } catch (e, stackTrace) {
      MySnackBar.showErrorMessage(
          'Une erreur s\'est produite, enregistrement échoué', context);

      //print('Error: $e');
      log('Error during transaction save: $e',
          error: e, stackTrace: stackTrace);
    }
  }

  void clearTransactions() {
    transactionsList.clear();
    notifyListeners();
  }
}
