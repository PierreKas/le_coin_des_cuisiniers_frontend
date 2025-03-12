import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:le_coin_des_cuisiniers_app/models/product_restock_history.dart';

class ProductHistoryService {
  //final String baseUrl = "http://localhost:8080/api/history";
  final String baseUrl =
      "https://le-coin-des-cuisiners-backend.onrender.com/api/history";
  List<ProductRestockHistoryModel> historyList = [];

  Future<List<ProductRestockHistoryModel>> getHistoryByCode(
      String productCode) async {
    final url = Uri.parse('$baseUrl/by-code/$productCode');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        // print(jsonDecodeData);

        historyList = List<ProductRestockHistoryModel>.from(jsonDecodeData
            .map((e) => ProductRestockHistoryModel.fromJson(e))
            .toList());
        return historyList;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('Try to handle null values');
  }
}
