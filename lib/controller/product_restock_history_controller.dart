import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/database/database_helper.dart';
import 'package:le_coin_des_cuisiniers_app/models/product_restock_history.dart';
import 'package:le_coin_des_cuisiniers_app/services/prod_history_service.dart';

class ProductRestockHistoryController {
  ProductHistoryService productHistory = ProductHistoryService();
  static List<ProductRestockHistoryModel> productRestockHistory = [];

  Future<List<ProductRestockHistoryModel>> getHistoryByCode(
      String prodCode, BuildContext context) async {
    List<ProductRestockHistoryModel> restockHistory =
        await productHistory.getHistoryByCode(prodCode);

    return restockHistory;
  }
}
