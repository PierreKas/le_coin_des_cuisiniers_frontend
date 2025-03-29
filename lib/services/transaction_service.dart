import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/services/aut_token.dart';
import 'package:le_coin_des_cuisiniers_app/services/base_url.dart';

class TransactionService {
  final String transactionBaseUrl = "$baseUrl/api/transactions";
  List<Transactions> transactionList = [];

  Future<List<Transactions>> getTransactionByDate(String date) async {
    final url = Uri.parse('$transactionBaseUrl/by-date/$date');

    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        //print(jsonDecodeData);

        transactionList = List<Transactions>.from(
            jsonDecodeData.map((e) => Transactions.fromJson(e)).toList());
        return transactionList;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('Try to handle null values');
  }

  Future<double> getDailyTotal(String date) async {
    final url = Uri.parse('$transactionBaseUrl/daily-total/$date');

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

  Future<double> getGeneralTotalSold() async {
    final url = Uri.parse('$transactionBaseUrl/general-total');

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

  Future<double> getMonthlyTotal(String month) async {
    final url = Uri.parse('$transactionBaseUrl/monthly-total/$month');

    try {
      final response = await http.get(
        url,
        headers: AuthToken.getHeaders(),
      );
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        print(jsonDecodeData);

        return jsonDecodeData;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('Try to handle null values');
  }

  Future<Map<String, dynamic>> saveTransactionBatch(
      List<Transactions> transactions) async {
    final url = Uri.parse('$transactionBaseUrl/batch');

    try {
      final List<Map<String, dynamic>> jsonList =
          transactions.map((transaction) {
        return {
          'productCode': transaction.productCode,
          'quantity': transaction.quantity,
          'sellingDate': transaction.sellingDate?.toIso8601String(),
          'totalPrice': transaction.totalPrice,
          // Add any other fields needed by your backend
        };
      }).toList();
      final response = await http.post(
        url,
        //headers: {'Content-Type': 'application/json'},
        headers: AuthToken.getHeaders(),
        body: jsonEncode(
            jsonList), //transactions.map((transaction) => transaction.toJson()).toList()
      );

      if (response.statusCode == 201) {
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
