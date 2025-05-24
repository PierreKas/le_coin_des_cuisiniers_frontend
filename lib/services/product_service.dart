import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/services/aut_token.dart';
import 'package:le_coin_des_cuisiniers_app/services/base_url.dart';

class ProductService {
  // final String baseUrl = "http://localhost:8080/api/products";
  final String productBaseUrl = "$baseUrl/api/products";
  List<Product> productList = [];

  Future<List<Product>> getAllProducts() async {
    final url = Uri.parse('$productBaseUrl/all');

    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      // print('URL: $url');
      // print('Headers: ${AuthToken.getHeaders()}');
      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        //print(response.body);
        final utf8DecodedBody = utf8.decode(response.bodyBytes);
        dynamic jsonDecodeData = jsonDecode(utf8DecodedBody);
        //dynamic jsonDecodeData = jsonDecode(response.body);
        print(jsonDecodeData);
        productList = List<Product>.from(
            jsonDecodeData.map((e) => Product.fromJson(e)).toList());
        return productList;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('Try to handle null values');
  }

  Future<List<Product>?> getLowStockProducts() async {
    final url = Uri.parse('$productBaseUrl/low-qty');
    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        // print(jsonDecodeData);
        productList = List<Product>.from(
            jsonDecodeData.map((e) => Product.fromJson(e)).toList());
        return productList;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<List<Product>?> getOutOfStockProducts() async {
    final url = Uri.parse('$productBaseUrl/out-of-stock');
    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        // print(jsonDecodeData);
        productList = List<Product>.from(
            jsonDecodeData.map((e) => Product.fromJson(e)).toList());
        return productList;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<Product?> addProduct(Product product, BuildContext context) async {
    final url = Uri.parse('$productBaseUrl/add');
    try {
      final response = await http.post(
        url,
        // headers: {
        //   'Content-Type': 'application/json',
        //   'aut-token': '${AuthToken.getHeaders()}'
        // },
        headers: AuthToken.getHeaders(),
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 201) {
        dynamic jsonData = jsonDecode(response.body);
        // print('Added ${response.body}');
        MySnackBar.showSuccessMessage('Produit ajouté', context);
        return Product.fromJson(jsonData);
      } else {
        dynamic errorMessage = jsonDecode(response.body);
        String error = errorMessage.toString();
        print(error);
        if (error.contains("Product code exists")) {
          MySnackBar.showErrorMessage('Ce code du produit existe', context);
        }
      }
    } catch (e) {
      print('Error $e');
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<Product?> findProductByCode(String code) async {
    final url = Uri.parse('$productBaseUrl/by-code/$code');
    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        return Product.fromJson(jsonData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<Product?> updateProduct(int productId, Product product) async {
    final url = Uri.parse('$productBaseUrl/update/$productId');
    try {
      final response = await http.put(
        url,
        //headers: {'Content-Type': 'application/json'},
        headers: AuthToken.getHeaders(),
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        return Product.fromJson(jsonData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<Product?> restockProduct(int productId, Product product) async {
    final url = Uri.parse('$productBaseUrl/update/$productId');
    try {
      final response = await http.put(
        url,
        //headers: {'Content-Type': 'application/json'},
        headers: AuthToken.getHeaders(),
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        return Product.fromJson(jsonData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<bool> deleteProduct(int productId) async {
    final url = Uri.parse('$productBaseUrl/delete/$productId');
    try {
      final response = await http.delete(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return false;
  }

  Future<double> getTotalMoneySpent() async {
    final url = Uri.parse('$productBaseUrl/total-money-spent');

    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        print(jsonDecodeData);

        // transactionList = List<Transactions>.from(
        //     jsonDecodeData.map((e) => Transactions.fromJson(e)).toList());
        return jsonDecodeData;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('Try to handle null values');
  }
}
