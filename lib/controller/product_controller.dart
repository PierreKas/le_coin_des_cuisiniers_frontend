import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/services/product_service.dart';
import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';

class ProductController {
  ProductService productService = ProductService();
  static List<Product> productsList = [];
  Future<void> addProduct(Product product, BuildContext context) async {
    if (!_isValidProduct(product)) {
      MySnackBar.showErrorMessage(
          'Complète toutes  les cases sans erreur', context);
    } else {
      try {
        await productService.addProduct(product);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } on Exception catch (e, stackTrace) {
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

  // Retrieve a specific product by product_code
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e, stackTrace) {
      log('An error occured while updating product: $e',
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
        product.remainingQuantity! >= 0 &&
        product.otherExpenses != null;
  }

  Future<void> deleteProduct(int productId, BuildContext context) async {
    try {
      await productService.deleteProduct(productId);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on Exception catch (e, stackTrace) {
      log('An error occured while trying to delete product: $e',
          error: e, stackTrace: stackTrace);
    }
  }
}
