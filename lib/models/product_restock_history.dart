// class ProductRestockHistoryModel {
//   int? id;
//   String? productCode;
//   String? newProductName;
//   String? oldProductName;
//   double? newPurchasePrice;
//   double? oldPurchasePrice;
//   double? newOtherExpenses;
//   double? oldOtherExpenses;
//   double? newSellingPrice;
//   double? oldSellingPrice;
//   int? newPurchasedQuantity;
//   int? oldPurchasedQuantity;
//   int? newRemainingQuantity;
//   int? oldRemainingQuantity;
//   String? newPurchasedDate;
//   String? oldPurchasedDate;
//   String? newBrand;
//   String? oldBrand;

//   ProductRestockHistoryModel({
//     this.id,
//     this.productCode,
//     this.newProductName,
//     this.oldProductName,
//     this.newPurchasePrice,
//     this.oldPurchasePrice,
//     this.newOtherExpenses,
//     this.oldOtherExpenses,
//     this.newSellingPrice,
//     this.oldSellingPrice,
//     this.newPurchasedQuantity,
//     this.oldPurchasedQuantity,
//     this.newRemainingQuantity,
//     this.oldRemainingQuantity,
//     this.newPurchasedDate,
//     this.oldPurchasedDate,
//     this.newBrand,
//     this.oldBrand,
//   });

//   factory ProductRestockHistoryModel.fromJson(Map<String, dynamic> json) {
//     double? parseDouble(dynamic value) {
//       if (value is int) {
//         return value.toDouble();
//       } else if (value is String) {
//         return double.tryParse(value);
//       } else {
//         return value as double?;
//       }
//     }

//     return ProductRestockHistoryModel(
//       id: json['id'] as int?,
//       productCode: json['product_code'] as String?,
//       newProductName: json['new_product_name'] as String?,
//       oldProductName: json['old_product_name'] as String?,
//       newPurchasePrice: parseDouble(json['new_purchase_price']),
//       oldPurchasePrice: parseDouble(json['old_purchase_price']),
//       newOtherExpenses: parseDouble(json['new_other_expenses']),
//       oldOtherExpenses: parseDouble(json['old_other_expenses']),
//       newSellingPrice: parseDouble(json['new_selling_price']),
//       oldSellingPrice: parseDouble(json['old_selling_price']),
//       newPurchasedQuantity: json['new_purchased_quantity'] as int?,
//       oldPurchasedQuantity: json['old_purchased_quantity'] as int?,
//       newRemainingQuantity: json['new_remaining_quantity'] as int?,
//       oldRemainingQuantity: json['old_remaining_quantity'] as int?,
//       newPurchasedDate: json['new_purchased_date'] as String?,
//       oldPurchasedDate: json['old_purchased_date'] as String?,
//       newBrand: json['new_brand'] as String?,
//       oldBrand: json['old_brand'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'product_code': productCode,
//       'new_product_name': newProductName,
//       'old_product_name': oldProductName,
//       'new_purchase_price': newPurchasePrice,
//       'old_purchase_price': oldPurchasePrice,
//       'new_other_expenses': newOtherExpenses,
//       'old_other_expenses': oldOtherExpenses,
//       'new_selling_price': newSellingPrice,
//       'old_selling_price': oldSellingPrice,
//       'new_purchased_quantity': newPurchasedQuantity,
//       'old_purchased_quantity': oldPurchasedQuantity,
//       'new_remaining_quantity': newRemainingQuantity,
//       'old_remaining_quantity': oldRemainingQuantity,
//       'new_purchased_date': newPurchasedDate,
//       'old_purchased_date': oldPurchasedDate,
//       'new_brand': newBrand,
//       'old_brand': oldBrand,
//     };
//   }
// }

class ProductRestockHistoryModel {
  int? id;
  String? productCode;
  String? newProductName;
  String? oldProductName;
  double? newPurchasePrice;
  double? oldPurchasePrice;
  double? newOtherExpenses;
  double? oldOtherExpenses;
  double? newSellingPrice;
  double? oldSellingPrice;
  int? newPurchasedQuantity;
  int? oldPurchasedQuantity;
  int? newRemainingQuantity;
  int? oldRemainingQuantity;
  String? newPurchasedDate;
  String? oldPurchasedDate;
  String? newBrand;
  String? oldBrand;

  ProductRestockHistoryModel({
    this.id,
    this.productCode,
    this.newProductName,
    this.oldProductName,
    this.newPurchasePrice,
    this.oldPurchasePrice,
    this.newOtherExpenses,
    this.oldOtherExpenses,
    this.newSellingPrice,
    this.oldSellingPrice,
    this.newPurchasedQuantity,
    this.oldPurchasedQuantity,
    this.newRemainingQuantity,
    this.oldRemainingQuantity,
    this.newPurchasedDate,
    this.oldPurchasedDate,
    this.newBrand,
    this.oldBrand,
  });

  factory ProductRestockHistoryModel.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value is int) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value);
      } else {
        return value as double?;
      }
    }

    return ProductRestockHistoryModel(
      id: json['id'] as int?,
      productCode: json['productCode'] as String?,
      newProductName: json['newProductName'] as String?,
      oldProductName: json['oldProductName'] as String?,
      newPurchasePrice: parseDouble(json['newPurchasePrice']),
      oldPurchasePrice: parseDouble(json['oldPurchasePrice']),
      newOtherExpenses: parseDouble(json['newOtherExpenses']),
      oldOtherExpenses: parseDouble(json['oldOtherExpenses']),
      newSellingPrice: parseDouble(json['newSellingPrice']),
      oldSellingPrice: parseDouble(json['oldSellingPrice']),
      newPurchasedQuantity: json['newPurchasedQuantity'] as int?,
      oldPurchasedQuantity: json['oldPurchasedQuantity'] as int?,
      newRemainingQuantity: json['newRemainingQuantity'] as int?,
      oldRemainingQuantity: json['oldRemainingQuantity'] as int?,
      newPurchasedDate: json['newPurchasedDate'] as String?,
      oldPurchasedDate: json['oldPurchasedDate'] as String?,
      newBrand: json['newBrand'] as String?,
      oldBrand: json['oldBrand'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCode': productCode,
      'newProductName': newProductName,
      'oldProductName': oldProductName,
      'newPurchasePrice': newPurchasePrice,
      'oldPurchasePrice': oldPurchasePrice,
      'newOtherExpenses': newOtherExpenses,
      'oldOtherExpenses': oldOtherExpenses,
      'newSellingPrice': newSellingPrice,
      'oldSellingPrice': oldSellingPrice,
      'newPurchasedQuantity': newPurchasedQuantity,
      'oldPurchasedQuantity': oldPurchasedQuantity,
      'newRemainingQuantity': newRemainingQuantity,
      'oldRemainingQuantity': oldRemainingQuantity,
      'newPurchasedDate': newPurchasedDate,
      'oldPurchasedDate': oldPurchasedDate,
      'newBrand': newBrand,
      'oldBrand': oldBrand,
    };
  }
}
