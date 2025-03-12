import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';

class TransactionService {
  // final String baseUrl = "http://localhost:8080/api/transactions";
  final String baseUrl =
      "https://le-coin-des-cuisiners-backend.onrender.com/api/transactions";
  List<Transactions> transactionList = [];

  Future<List<Transactions>> getTransactionByDate(String date) async {
    final url = Uri.parse('$baseUrl/by-date/$date');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        print(jsonDecodeData);

        transactionList = List<Transactions>.from(
            jsonDecodeData.map((e) => Transactions.fromJson(e)).toList());
        return transactionList;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('Try to handle null values');
  }

  Future<Map<String, dynamic>> saveTransactionBatch(
      List<Transactions> transactions) async {
    final url = Uri.parse('$baseUrl/batch');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            transactions.map((transaction) => transaction.toJson()).toList()),
      );

      if (response.statusCode == 201) {
        // Successfully created
        return jsonDecode(response.body);
      } else {
        Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to save transactions');
      }
    } catch (e) {
      throw Exception('Error submitting transactions: $e');
    }
  }
}
