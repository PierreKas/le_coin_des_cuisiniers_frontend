import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:http/http.dart' as http;
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/services/aut_token.dart';
import 'package:le_coin_des_cuisiniers_app/services/base_url.dart';

class TransactionService {
  final String transactionBaseUrl = "$baseUrl/api/transactions";
  List<Transactions> transactionList = [];

  Future<List<Transactions>> getTransactionByDate(String date) async {
    final url = Uri.parse('$transactionBaseUrl/by-date/$date');

    try {
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return [];
      }

      if (isTokenExpired) {
        print('Token is expired');
        return [];
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
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
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return 0;
      }

      if (isTokenExpired) {
        print('Token is expired');
        return 0;
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
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
    final url = Uri.parse('$transactionBaseUrl/general-total-sold');

    try {
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return 0;
      }

      if (isTokenExpired) {
        print('Token is expired');
        return 0;
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        print('Gen tot sold: $jsonDecodeData');
        if (jsonDecodeData == null) {
          jsonDecodeData = 0;
          print('The value is null');
          return 0;
        }
        // transactionList = List<Transactions>.from(
        //     jsonDecodeData.map((e) => Transactions.fromJson(e)).toList());
        return jsonDecodeData;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('There is a null value');
  }

  Future<double> getMonthlyTotal(String month) async {
    final url = Uri.parse('$transactionBaseUrl/monthly-total/$month');

    try {
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return 0;
      }

      if (isTokenExpired) {
        print('Token is expired');
        return 0;
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = jsonDecode(response.body);
        print(jsonDecodeData);
        jsonDecodeData ??= 0;
        return jsonDecodeData;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    throw Exception('Try to handle null values');
  }

  Future<Map<String, dynamic>> saveTransactionBatch(
      List<Transactions> transactions, BuildContext context) async {
    final url = Uri.parse('$transactionBaseUrl/batch');

    try {
      String? storedToken = await FlutterSessionJwt.retrieveToken();
      bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

      if (storedToken == null || storedToken.isEmpty) {
        print('There is no token stored');
        return {"token": "There is no token stored"};
      }

      if (isTokenExpired) {
        print('Token is expired');

        return {"token": "Token is expired"};
      }
      print("Transactions: $transactions");
      final List<Map<String, dynamic>> jsonList =
          transactions.map((transaction) {
        return {
          'productCode': transaction.productCode,
          'quantity': transaction.quantity,
          'sellingDate': transaction.sellingDate?.toIso8601String(),
          'totalPrice': transaction.totalPrice,
        };
      }).toList();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
        body: jsonEncode(jsonList),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        Map<String, dynamic> errorData = jsonDecode(response.body);
        String error = errorData.toString();

        print(error);
        if (error.contains("Le stock n'est pas suffisant")) {
          MySnackBar.showErrorMessage(
              'Le stock n\'est pas suffisant pour ce produit', context);
        } else if (error.contains("No transactions provided")) {
          MySnackBar.showErrorMessage(
              'Ajoutez une transaction avant de vendre', context);
        }
        throw Exception(errorData['message'] ?? 'Failed to save transactions');
      }
    } catch (e) {
      throw Exception('Error submitting transactions: $e');
    }
  }

  // Future<Map<String, dynamic>> saveTransactionBatch(
  //     List<Transactions> transactions, BuildContext context) async {
  //   final url = Uri.parse('$transactionBaseUrl/batch');

  //   // DEBUG: Print the incoming transactions
  //   print('=== DEBUG: saveTransactionBatch called ===');
  //   print('Number of transactions received: ${transactions.length}');

  //   if (transactions.isEmpty) {
  //     print('ERROR: Empty transactions list received!');
  //     throw Exception('No transactions provided');
  //   }

  //   try {
  //     String? storedToken = await FlutterSessionJwt.retrieveToken();
  //     bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

  //     if (storedToken == null || storedToken.isEmpty) {
  //       print('There is no token stored');
  //       return {"token": "There is no token stored"};
  //     }

  //     if (isTokenExpired) {
  //       print('Token is expired');
  //       return {"token": "Token is expired"};
  //     }

  //     // DEBUG: Print each transaction before mapping
  //     for (int i = 0; i < transactions.length; i++) {
  //       var transaction = transactions[i];
  //       print('Transaction $i:');
  //       print('  productCode: ${transaction.productCode}');
  //       print('  quantity: ${transaction.quantity}');
  //       print('  sellingDate: ${transaction.sellingDate}');
  //       print('  totalPrice: ${transaction.totalPrice}');
  //     }

  //     final List<Map<String, dynamic>> jsonList =
  //         transactions.map((transaction) {
  //       var mapped = {
  //         'productCode': transaction.productCode,
  //         'quantity': transaction.quantity,
  //         'sellingDate': transaction.sellingDate?.toIso8601String(),
  //         'totalPrice': transaction.totalPrice,
  //       };
  //       print('Mapped transaction: $mapped');
  //       return mapped;
  //     }).toList();

  //     // DEBUG: Print the final JSON
  //     print('Final JSON list: $jsonList');
  //     print('JSON encoded: ${jsonEncode(jsonList)}');

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $storedToken',
  //       },
  //       body: jsonEncode(jsonList),
  //     );

  //     print('Response status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 201) {
  //       return jsonDecode(response.body);
  //     } else {
  //       Map<String, dynamic> errorData = jsonDecode(response.body);
  //       String error = errorData.toString();

  //       print(error);
  //       if (error.contains("Le stock n'est pas suffisant")) {
  //         MySnackBar.showErrorMessage(
  //             'Le stock n\'est pas suffisant pour ce produit', context);
  //       } else if (error.contains("No transactions provided")) {
  //         MySnackBar.showErrorMessage(
  //             'Ajoutez une transaction avant de vendre', context);
  //       }
  //       throw Exception(errorData['message'] ?? 'Failed to save transactions');
  //     }
  //   } catch (e) {
  //     print('Exception in saveTransactionBatch: $e');
  //     throw Exception('Error submitting transactions: $e');
  //   }
  // }
  // Future<Map<String, dynamic>> saveTransactionBatch(
  //     List<Transactions> transactions, BuildContext context) async {
  //   final url = Uri.parse('$transactionBaseUrl/batch');

  //   // DEBUG: Print the incoming transactions
  //   print('=== DEBUG: saveTransactionBatch called ===');
  //   print('Number of transactions received: ${transactions.length}');

  //   if (transactions.isEmpty) {
  //     print('ERROR: Empty transactions list received!');
  //     throw Exception('No transactions provided');
  //   }

  //   try {
  //     String? storedToken = await FlutterSessionJwt.retrieveToken();
  //     bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

  //     if (storedToken == null || storedToken.isEmpty) {
  //       print('There is no token stored');
  //       return {"token": "There is no token stored"};
  //     }

  //     if (isTokenExpired) {
  //       print('Token is expired');
  //       return {"token": "Token is expired"};
  //     }

  //     // DEBUG: Print each transaction before mapping
  //     for (int i = 0; i < transactions.length; i++) {
  //       var transaction = transactions[i];
  //       print('Transaction $i:');
  //       print('  productCode: ${transaction.productCode}');
  //       print('  quantity: ${transaction.quantity}');
  //       print('  sellingDate: ${transaction.sellingDate}');
  //       print('  totalPrice: ${transaction.totalPrice}');
  //     }

  //     final List<Map<String, dynamic>> jsonList = [];

  //     for (int i = 0; i < transactions.length; i++) {
  //       try {
  //         var transaction = transactions[i];
  //         print('Processing transaction $i for JSON mapping...');

  //         var mapped = {
  //           'productCode': transaction.productCode,
  //           'quantity': transaction.quantity,
  //           'sellingDate': transaction.sellingDate?.toIso8601String(),
  //           'totalPrice': transaction.totalPrice,
  //         };

  //         print('Successfully mapped transaction $i: $mapped');
  //         jsonList.add(mapped);
  //       } catch (e) {
  //         print('ERROR mapping transaction $i: $e');
  //         print('Transaction details: ${transactions[i]}');
  //       }
  //     }

  //     // DEBUG: Print the final JSON
  //     print('Final JSON list: $jsonList');
  //     print('JSON encoded: ${jsonEncode(jsonList)}');

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $storedToken',
  //       },
  //       body: jsonEncode(jsonList),
  //     );

  //     print('Response status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 201) {
  //       return jsonDecode(response.body);
  //     } else {
  //       Map<String, dynamic> errorData = jsonDecode(response.body);
  //       String error = errorData.toString();

  //       print(error);
  //       if (error.contains("Le stock n'est pas suffisant")) {
  //         MySnackBar.showErrorMessage(
  //             'Le stock n\'est pas suffisant pour ce produit', context);
  //       } else if (error.contains("No transactions provided")) {
  //         MySnackBar.showErrorMessage(
  //             'Ajoutez une transaction avant de vendre', context);
  //       }
  //       throw Exception(errorData['message'] ?? 'Failed to save transactions');
  //     }
  //   } catch (e) {
  //     print('Exception in saveTransactionBatch: $e');
  //     throw Exception('Error submitting transactions: $e');
  //   }
  // }
  // Future<Map<String, dynamic>> saveTransactionBatch(
  //     List<Transactions> transactions, BuildContext context) async {
  //   final url = Uri.parse('$transactionBaseUrl/batch');

  //   // DEBUG: Print the incoming transactions
  //   print('=== DEBUG: saveTransactionBatch called ===');
  //   print('Number of transactions received: ${transactions.length}');

  //   if (transactions.isEmpty) {
  //     print('ERROR: Empty transactions list received!');
  //     throw Exception('No transactions provided');
  //   }

  //   try {
  //     String? storedToken = await FlutterSessionJwt.retrieveToken();
  //     bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

  //     if (storedToken == null || storedToken.isEmpty) {
  //       print('There is no token stored');
  //       return {"token": "There is no token stored"};
  //     }

  //     if (isTokenExpired) {
  //       print('Token is expired');
  //       return {"token": "Token is expired"};
  //     }

  //     // DEBUG: Print each transaction before mapping
  //     for (int i = 0; i < transactions.length; i++) {
  //       var transaction = transactions[i];
  //       print('Transaction $i:');
  //       print('  productCode: ${transaction.productCode}');
  //       print('  quantity: ${transaction.quantity}');
  //       print('  sellingDate: ${transaction.sellingDate}');
  //       print('  totalPrice: ${transaction.totalPrice}');
  //     }

  //     final List<Map<String, dynamic>> jsonList = [];

  //     for (int i = 0; i < transactions.length; i++) {
  //       var transaction = transactions[i];
  //       print('Processing transaction $i for JSON mapping...');

  //       // Validate required fields before mapping
  //       if (transaction.productCode == null ||
  //           transaction.productCode!.isEmpty) {
  //         print('ERROR: Transaction $i has null or empty productCode');
  //         continue; // Skip this transaction
  //       }

  //       if (transaction.quantity == null || transaction.quantity! <= 0) {
  //         print(
  //             'ERROR: Transaction $i has invalid quantity: ${transaction.quantity}');
  //         continue; // Skip this transaction
  //       }

  //       if (transaction.totalPrice == null) {
  //         print('ERROR: Transaction $i has null totalPrice');
  //         continue; // Skip this transaction
  //       }

  //       try {
  //         var mapped = {
  //           'productCode': transaction.productCode!,
  //           'quantity': transaction.quantity!,
  //           'sellingDate': transaction.sellingDate?.toIso8601String() ??
  //               DateTime.now().toIso8601String(),
  //           'totalPrice': transaction.totalPrice!,
  //         };

  //         print('Successfully mapped transaction $i: $mapped');
  //         jsonList.add(mapped);
  //       } catch (e, stackTrace) {
  //         print('ERROR mapping transaction $i: $e');
  //         print('Stack trace: $stackTrace');
  //         print('Transaction details: ${transaction.toString()}');
  //         // Don't add this transaction to the list, but continue with others
  //         continue;
  //       }
  //     }

  //     // Check if we have any valid transactions after filtering
  //     if (jsonList.isEmpty) {
  //       print('ERROR: No valid transactions to send after filtering');
  //       throw Exception('No valid transactions to process');
  //     }

  //     // DEBUG: Print the final JSON
  //     print('Final JSON list: $jsonList');
  //     print('JSON list length: ${jsonList.length}');

  //     String jsonString = jsonEncode(jsonList);
  //     print('JSON encoded: $jsonString');
  //     print('JSON string length: ${jsonString.length}');

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $storedToken',
  //       },
  //       body: jsonString,
  //     );

  //     print('Response status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 201) {
  //       return jsonDecode(response.body);
  //     } else {
  //       Map<String, dynamic> errorData = jsonDecode(response.body);
  //       String error = errorData.toString();

  //       print(error);
  //       if (error.contains("Le stock n'est pas suffisant")) {
  //         MySnackBar.showErrorMessage(
  //             'Le stock n\'est pas suffisant pour ce produit', context);
  //       } else if (error.contains("No transactions provided")) {
  //         MySnackBar.showErrorMessage(
  //             'Ajoutez une transaction avant de vendre', context);
  //       }
  //       throw Exception(errorData['message'] ?? 'Failed to save transactions');
  //     }
  //   } catch (e, stackTrace) {
  //     print('Exception in saveTransactionBatch: $e');
  //     print('Stack trace: $stackTrace');
  //     throw Exception('Error submitting transactions: $e');
  //   }
  // }
  // Future<Map<String, dynamic>> saveTransactionBatch(
  //     List<Transactions> transactions, BuildContext context) async {
  //   final url = Uri.parse('$transactionBaseUrl/batch');

  //   // DEBUG: Print the incoming transactions
  //   print('=== DEBUG: saveTransactionBatch called ===');
  //   print('Number of transactions received: ${transactions.length}');

  //   if (transactions.isEmpty) {
  //     print('ERROR: Empty transactions list received!');
  //     throw Exception('No transactions provided');
  //   }

  //   try {
  //     String? storedToken = await FlutterSessionJwt.retrieveToken();
  //     bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

  //     if (storedToken == null || storedToken.isEmpty) {
  //       print('There is no token stored');
  //       return {"token": "There is no token stored"};
  //     }

  //     if (isTokenExpired) {
  //       print('Token is expired');
  //       return {"token": "Token is expired"};
  //     }

  //     // DEBUG: Print each transaction before mapping
  //     for (int i = 0; i < transactions.length; i++) {
  //       var transaction = transactions[i];
  //       print('Transaction $i:');
  //       print('  productCode: ${transaction.productCode}');
  //       print('  quantity: ${transaction.quantity}');
  //       print('  sellingDate: ${transaction.sellingDate}');
  //       print('  totalPrice: ${transaction.totalPrice}');
  //       print('  product: ${transaction.product}');
  //       print('  productName (getter): ${transaction.productName}');
  //       print('  unitPrice (getter): ${transaction.unitPrice}');
  //     }

  //     final List<Map<String, dynamic>> jsonList = [];

  //     for (int i = 0; i < transactions.length; i++) {
  //       var transaction = transactions[i];
  //       debugTransactionDetails(transaction, i);
  //       print('Processing transaction $i for JSON mapping...');

  //       // Validate required fields before mapping
  //       if (transaction.productCode == null ||
  //           transaction.productCode!.isEmpty) {
  //         print('ERROR: Transaction $i has null or empty productCode');
  //         continue; // Skip this transaction
  //       }

  //       if (transaction.quantity == null || transaction.quantity! <= 0) {
  //         print(
  //             'ERROR: Transaction $i has invalid quantity: ${transaction.quantity}');
  //         continue; // Skip this transaction
  //       }

  //       if (transaction.totalPrice == null || transaction.totalPrice! <= 0) {
  //         print(
  //             'ERROR: Transaction $i has invalid totalPrice: ${transaction.totalPrice}');
  //         continue; // Skip this transaction
  //       }

  //       if (transaction.sellingDate == null) {
  //         print('ERROR: Transaction $i has null sellingDate');
  //         continue; // Skip this transaction
  //       }

  //       try {
  //         // Use the model's toJson method instead of manual mapping
  //         var mapped = transaction.toJson();

  //         // The toJson method should handle the conversion properly
  //         print('Successfully mapped transaction $i using toJson(): $mapped');
  //         jsonList.add(mapped);
  //       } catch (e, stackTrace) {
  //         print('ERROR mapping transaction $i using toJson(): $e');
  //         print('Stack trace: $stackTrace');

  //         // Fallback to manual mapping if toJson fails
  //         try {
  //           var manualMapped = {
  //             'productCode': transaction.productCode!,
  //             'quantity': transaction.quantity!,
  //             'sellingDate': transaction.sellingDate!.toIso8601String(),
  //             'totalPrice': transaction.totalPrice!,
  //             'billCode': transaction.billCode,
  //             'userId': transaction.userId,
  //             'transactionId': transaction.transactionId,
  //             'productId': transaction.productId,
  //           };

  //           print('Successfully manually mapped transaction $i: $manualMapped');
  //           jsonList.add(manualMapped);
  //         } catch (manualError) {
  //           print('ERROR in manual mapping for transaction $i: $manualError');
  //           print(
  //               'Transaction details: productCode=${transaction.productCode}, quantity=${transaction.quantity}, totalPrice=${transaction.totalPrice}, sellingDate=${transaction.sellingDate}');
  //           continue; // Skip this transaction
  //         }
  //       }
  //     }

  //     // Check if we have any valid transactions after filtering
  //     if (jsonList.isEmpty) {
  //       print('ERROR: No valid transactions to send after filtering');
  //       throw Exception('No valid transactions to process');
  //     }

  //     // DEBUG: Print the final JSON
  //     print('Final JSON list: $jsonList');
  //     print('JSON list length: ${jsonList.length}');

  //     String jsonString = jsonEncode(jsonList);
  //     print('JSON encoded: $jsonString');
  //     print('JSON string length: ${jsonString.length}');

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $storedToken',
  //       },
  //       body: jsonString,
  //     );

  //     print('Response status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 201) {
  //       return jsonDecode(response.body);
  //     } else {
  //       Map<String, dynamic> errorData = jsonDecode(response.body);
  //       String error = errorData.toString();

  //       print(error);
  //       if (error.contains("Le stock n'est pas suffisant")) {
  //         MySnackBar.showErrorMessage(
  //             'Le stock n\'est pas suffisant pour ce produit', context);
  //       } else if (error.contains("No transactions provided")) {
  //         MySnackBar.showErrorMessage(
  //             'Ajoutez une transaction avant de vendre', context);
  //       }
  //       throw Exception(errorData['message'] ?? 'Failed to save transactions');
  //     }
  //   } catch (e, stackTrace) {
  //     print('Exception in saveTransactionBatch: $e');
  //     print('Stack trace: $stackTrace');
  //     throw Exception('Error submitting transactions: $e');
  //   }
  // }
  // Future<Map<String, dynamic>> saveTransactionBatch(
  //     List<Transactions> transactions, BuildContext context) async {
  //   final url = Uri.parse('$transactionBaseUrl/batch');

  //   // DEBUG: Print the incoming transactions
  //   print('=== DEBUG: saveTransactionBatch called ===');
  //   print('Number of transactions received: ${transactions.length}');

  //   if (transactions.isEmpty) {
  //     print('ERROR: Empty transactions list received!');
  //     throw Exception('No transactions provided');
  //   }

  //   try {
  //     String? storedToken = await FlutterSessionJwt.retrieveToken();
  //     bool isTokenExpired = await FlutterSessionJwt.isTokenExpired();

  //     if (storedToken == null || storedToken.isEmpty) {
  //       print('There is no token stored');
  //       return {"token": "There is no token stored"};
  //     }

  //     if (isTokenExpired) {
  //       print('Token is expired');
  //       return {"token": "Token is expired"};
  //     }

  //     // DEBUG: Print each transaction before mapping
  //     for (int i = 0; i < transactions.length; i++) {
  //       var transaction = transactions[i];
  //       print('Transaction $i:');
  //       print('  productCode: ${transaction.productCode}');
  //       print('  quantity: ${transaction.quantity}');
  //       print('  sellingDate: ${transaction.sellingDate}');
  //       print('  totalPrice: ${transaction.totalPrice}');
  //       print('  product: ${transaction.product}');
  //       print('  productName (getter): ${transaction.productName}');
  //       print('  unitPrice (getter): ${transaction.unitPrice}');
  //     }

  //     final List<Map<String, dynamic>> jsonList = [];

  //     for (int i = 0; i < transactions.length; i++) {
  //       var transaction = transactions[i];
  //       print('Processing transaction $i for JSON mapping...');

  //       // Debug each field individually
  //       print('  Checking productCode: ${transaction.productCode}');
  //       if (transaction.productCode == null ||
  //           transaction.productCode!.isEmpty) {
  //         print('ERROR: Transaction $i has null or empty productCode');
  //         continue; // Skip this transaction
  //       }

  //       print('  Checking quantity: ${transaction.quantity}');
  //       if (transaction.quantity == null || transaction.quantity! <= 0) {
  //         print(
  //             'ERROR: Transaction $i has invalid quantity: ${transaction.quantity}');
  //         continue; // Skip this transaction
  //       }

  //       print(
  //           '  Checking totalPrice: ${transaction.totalPrice} (type: ${transaction.totalPrice.runtimeType})');
  //       if (transaction.totalPrice == null) {
  //         print('ERROR: Transaction $i has null totalPrice');
  //         continue; // Skip this transaction
  //       }
  //       if (transaction.totalPrice! <= 0) {
  //         print(
  //             'ERROR: Transaction $i has totalPrice <= 0: ${transaction.totalPrice}');
  //         continue; // Skip this transaction
  //       }

  //       print('  Checking sellingDate: ${transaction.sellingDate}');
  //       // if (transaction.sellingDate == null) {
  //       //   print('ERROR: Transaction $i has null sellingDate');
  //       //   continue; // Skip this transaction
  //       // }
  //       if (transaction.sellingDate == null) {
  //         print(
  //             'WARNING: Transaction $i has null sellingDate, assigning DateTime.now()');
  //         transaction.sellingDate = DateTime.now();
  //       }

  //       print('  All validations passed for transaction $i');

  //       try {
  //         // Use the model's toJson method instead of manual mapping
  //         var mapped = transaction.toJson();

  //         // The toJson method should handle the conversion properly
  //         print('Successfully mapped transaction $i using toJson(): $mapped');
  //         jsonList.add(mapped);
  //       } catch (e, stackTrace) {
  //         print('ERROR mapping transaction $i using toJson(): $e');
  //         print('Stack trace: $stackTrace');

  //         // Fallback to manual mapping if toJson fails
  //         try {
  //           var manualMapped = {
  //             'productCode': transaction.productCode!,
  //             'quantity': transaction.quantity!,
  //             'sellingDate': transaction.sellingDate!.toIso8601String(),
  //             'totalPrice': transaction.totalPrice!,
  //             'billCode': transaction.billCode,
  //             'userId': transaction.userId,
  //             'transactionId': transaction.transactionId,
  //             'productId': transaction.productId,
  //           };

  //           print('Successfully manually mapped transaction $i: $manualMapped');
  //           jsonList.add(manualMapped);
  //         } catch (manualError) {
  //           print('ERROR in manual mapping for transaction $i: $manualError');
  //           print(
  //               'Transaction details: productCode=${transaction.productCode}, quantity=${transaction.quantity}, totalPrice=${transaction.totalPrice}, sellingDate=${transaction.sellingDate}');
  //           continue; // Skip this transaction
  //         }
  //       }
  //     }

  //     // Check if we have any valid transactions after filtering
  //     if (jsonList.isEmpty) {
  //       print('ERROR: No valid transactions to send after filtering');
  //       throw Exception('No valid transactions to process');
  //     }

  //     // DEBUG: Print the final JSON
  //     print('Final JSON list: $jsonList');
  //     print('JSON list length: ${jsonList.length}');

  //     String jsonString = jsonEncode(jsonList);
  //     print('JSON encoded: $jsonString');
  //     print('JSON string length: ${jsonString.length}');

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $storedToken',
  //       },
  //       body: jsonString,
  //     );

  //     print('Response status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 201) {
  //       return jsonDecode(response.body);
  //     } else {
  //       Map<String, dynamic> errorData = jsonDecode(response.body);
  //       String error = errorData.toString();

  //       print(error);
  //       if (error.contains("Le stock n'est pas suffisant")) {
  //         MySnackBar.showErrorMessage(
  //             'Le stock n\'est pas suffisant pour ce produit', context);
  //       } else if (error.contains("No transactions provided")) {
  //         MySnackBar.showErrorMessage(
  //             'Ajoutez une transaction avant de vendre', context);
  //       }
  //       throw Exception(errorData['message'] ?? 'Failed to save transactions');
  //     }
  //   } catch (e, stackTrace) {
  //     print('Exception in saveTransactionBatch: $e');
  //     print('Stack trace: $stackTrace');
  //     throw Exception('Error submitting transactions: $e');
  //   }
  // }

  // void debugTransactionDetails(Transactions transaction, int index) {
  //   print('=== DETAILED DEBUG FOR TRANSACTION $index ===');
  //   print('Raw transaction object: $transaction');
  //   print(
  //       'productCode: ${transaction.productCode} (type: ${transaction.productCode.runtimeType})');
  //   print(
  //       'quantity: ${transaction.quantity} (type: ${transaction.quantity.runtimeType})');
  //   print(
  //       'sellingDate: ${transaction.sellingDate} (type: ${transaction.sellingDate.runtimeType})');
  //   print(
  //       'totalPrice: ${transaction.totalPrice} (type: ${transaction.totalPrice.runtimeType})');
  //   print('product object: ${transaction.product}');
  //   print('billCode: ${transaction.billCode}');
  //   print('userId: ${transaction.userId}');
  //   print('transactionId: ${transaction.transactionId}');
  //   print('productId: ${transaction.productId}');

  //   // Test the getters
  //   try {
  //     print('productName getter: ${transaction.productName}');
  //   } catch (e) {
  //     print('ERROR accessing productName getter: $e');
  //   }

  //   try {
  //     print('unitPrice getter: ${transaction.unitPrice}');
  //   } catch (e) {
  //     print('ERROR accessing unitPrice getter: $e');
  //   }

  //   // Test toJson method
  //   try {
  //     var jsonResult = transaction.toJson();
  //     print('toJson() result: $jsonResult');
  //   } catch (e, stackTrace) {
  //     print('ERROR in toJson(): $e');
  //     print('Stack trace: $stackTrace');
  //   }

  //   print('=== END DETAILED DEBUG FOR TRANSACTION $index ===\n');
  // }
}
