import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/services/product_service.dart';
import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';

class ProductController extends ChangeNotifier {
  ProductService productService = ProductService();
  static List<Product> productsList = [];
  static double totalOtherExp = 0;
  ///////////////////////////
  final List<Product> _productsList = [];
  List<Product> get producttsList => _productsList;
  Future<void> addProductOnList(Product product, BuildContext context) async {
    // Add debug print to see the transaction being added
    print(
        'Attempting to add transaction: ${product.productCode}, quantity: ${product.purchasedQuantity}');

    _productsList.add(product);
    print(
        'Product added successfully. Total products: ${_productsList.length}');

    notifyListeners();
  }

  void removeProduct(Product product, BuildContext context) {
    try {
      // Find the index of the transaction to be deleted
      int index = _productsList.indexWhere((prod) => prod.id == product.id);

      if (index != -1) {
        // Remove the transaction from the list
        _productsList.removeAt(index);
        MySnackBar.showSuccessMessage('Produit supprimé avec succès', context);
        notifyListeners(); // Notify listeners to update the UI
      } else {
        MySnackBar.showErrorMessage('Produit introuvable', context);
      }
    } catch (e) {
      MySnackBar.showErrorMessage(
          'Une erreur est survenue lors de la suppression du produit', context);
      print('Error removing product: $e');
    }
  }

  Future<void> insertProductsTheDB(BuildContext context) async {
    // Add validation before attempting to save
    if (_productsList.isEmpty) {
      MySnackBar.showErrorMessage(
          'Aucune transaction à enregistrer. Ajoutez au moins un produit.',
          context);
      return;
    }

    print(
        'Attempting to save ${_productsList.length} transactions to database');

    ProductService productService = ProductService();

    try {
      print("Product List ${_productsList}");
      double sumOfPurchasePrice = 0;
      for (var product in _productsList) {
        sumOfPurchasePrice += product.purchasePrice!;
      }
      for (var product in _productsList) {
        product.otherExpenses =
            ((((product.purchasePrice! * 100) / sumOfPurchasePrice)) / 100) *
                totalOtherExp;
        print('Total expenses: $totalOtherExp');
        print(
            '${product.productName} has the purchase price of ${product.purchasePrice} and of expense of ${product.otherExpenses}');
        /**
                 * 1. To have the sum of purchase prices
                 * 2. To have the pourcentage of a single purchase price in the sum of purchase prices
                 * 3. Extract the ppercentage in (2) and assign its value in other expenses total
                 */
      }

      Map<String, dynamic> result =
          await productService.saveProductBatch(_productsList, context);
      if (result.isEmpty) {
        print('Empty products list');
      } else {
        print("Result $result");
      }

      MySnackBar.showSuccessMessage('Produit(s) enregistré(s)', context);
    } catch (e, stackTrace) {
      MySnackBar.showErrorMessage(
          'Une erreur s\'est produite, enregistrement échoué', context);

      print('Error: $e');
      log('Error during product recording: $e',
          error: e, stackTrace: stackTrace);
    }
  }

  void clearProducts() {
    _productsList.clear();
    notifyListeners();
  }

  ///////////////////////////
  Future<void> addProduct(Product product, BuildContext context) async {
    if (!_isValidProduct(product)) {
      MySnackBar.showErrorMessage(
          'Complète toutes  les cases sans erreur', context);
    } else {
      try {
        await productService.addProduct(product, context);

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => const HomePage()));
        context.go("/home");
      } on Exception catch (e, stackTrace) {
        MySnackBar.showErrorMessage(
            'Une erreur s\'est produite lors de l\'enregistrement du produit',
            context);
        log('An error occured while adding product: $e',
            error: e, stackTrace: stackTrace);
      }
    }
  }

  Future<List<Product>> getProducts() async {
    List<Product> allProducts = await productService.getAllProducts();
    print(allProducts);
    return allProducts;
  }

  Future<Product?> getProductByCode(String prodCode) async {
    Product? product = await productService.findProductByCode(prodCode);

    return product;
  }

  Future<void> updateProduct(
      int prodId, Product product, BuildContext context) async {
    if (!_isValidProduct(product)) {
      MySnackBar.showErrorMessage(
          'Veuillez remplir tous les champs correctement', context);
      return;
    }

    try {
      await productService.updateProduct(prodId, product);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => const HomePage()));
      context.go("home");
    } catch (e, stackTrace) {
      log('An error occured while updating product: $e',
          error: e, stackTrace: stackTrace);
    }
  }

  Future<void> restockProduct(
      int prodId, Product product, BuildContext context) async {
    if (!_isValidProduct(product)) {
      MySnackBar.showErrorMessage(
          'Veuillez remplir tous les champs correctement', context);
      return;
    }

    try {
      await productService.updateProduct(prodId, product);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => const HomePage()));
      context.go("/home");
    } catch (e, stackTrace) {
      log('An error occured while restocking the product ${product.productName}: $e',
          error: e, stackTrace: stackTrace);
    }
  }

  bool _isValidProduct(Product product) {
    return product.productCode!.isNotEmpty &&
        product.productName!.isNotEmpty &&
        product.purchasePrice != null &&
        product.purchasePrice! > 0 &&
        product.purchasedDate != null &&
        product.purchasedQuantity != null &&
        product.purchasedQuantity! > 0 &&
        product.sellingPrice != null &&
        product.sellingPrice! > 0 &&
        product.brand!.isNotEmpty &&
        product.remainingQuantity != null &&
        product.remainingQuantity! >= 0; //&&
    //product.otherExpenses != null;
  }

  Future<void> deleteProduct(int productId, BuildContext context) async {
    try {
      await productService.deleteProduct(productId);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const HomePage()));
      context.go("/home");
    } on Exception catch (e, stackTrace) {
      log('An error occured while trying to delete product: $e',
          error: e, stackTrace: stackTrace);
    }
  }

  Future<double> totalAmountSpent() async {
    double totalAmountSpent = await productService.getTotalMoneySpent();

    return totalAmountSpent;
  }
}
