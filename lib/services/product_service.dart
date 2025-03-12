// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:le_coin_des_cuisiniers_app/models/products.dart';

// class ProductService {
//   // final String baseUrl = "http://localhost:8080/api/products";
//   final String baseUrl =
//       "https://le-coin-des-cuisiners-backend.onrender.com/api/products";
//   List<Product> productList = [];
//   Future<List<Product>> getAllProducts() async {
//     final url = Uri.parse('$baseUrl/all');

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         //print(response.body);
//         dynamic jsonDecodeData = jsonDecode(response.body);
//         // print(jsonDecodeData);

//         productList = List<Product>.from(
//             jsonDecodeData.map((e) => Product.fromJson(e)).toList());
//         return productList;
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//     throw Exception('Try to handle null values');
//   }

//   Future<List<Product>?> getLowStockProducts() async {
//     final url = Uri.parse('$baseUrl/low-qty');

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         dynamic jsonDecodeData = jsonDecode(response.body);
//         // print(jsonDecodeData);

//         productList = List<Product>.from(
//             jsonDecodeData.map((e) => Product.fromJson(e)).toList());
//         return productList;
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//     return null;
//   }

//   Future<List<Product>?> getOutOfStockProducts() async {
//     final url = Uri.parse('$baseUrl/out-of-stock');

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         dynamic jsonDecodeData = jsonDecode(response.body);
//         //  print(jsonDecodeData);

//         productList = List<Product>.from(
//             jsonDecodeData.map((e) => Product.fromJson(e)).toList());
//         return productList;
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//     return null;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:le_coin_des_cuisiniers_app/models/products.dart';

class ProductService {
  // final String baseUrl = "http://localhost:8080/api/products";
  final String baseUrl =
      "https://le-coin-des-cuisiners-backend.onrender.com/api/products";
  List<Product> productList = [];

  Future<List<Product>> getAllProducts() async {
    final url = Uri.parse('$baseUrl/all');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        //print(response.body);
        dynamic jsonDecodeData = jsonDecode(response.body);
        // print(jsonDecodeData);
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
    final url = Uri.parse('$baseUrl/low-qty');
    try {
      final response = await http.get(url);
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
    final url = Uri.parse('$baseUrl/out-of-stock');
    try {
      final response = await http.get(url);
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

  Future<Product?> addProduct(Product product) async {
    final url = Uri.parse('$baseUrl/add');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 201) {
        dynamic jsonData = jsonDecode(response.body);
        return Product.fromJson(jsonData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return null;
  }

  Future<Product?> findProductByCode(String code) async {
    final url = Uri.parse('$baseUrl/by-code?code=$code');
    try {
      final response = await http.get(url);
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
    final url = Uri.parse('$baseUrl/update/$productId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
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
    final url = Uri.parse('$baseUrl/delete/$productId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return false;
  }
}
