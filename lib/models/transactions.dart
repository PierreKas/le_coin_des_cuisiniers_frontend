// class Transactions {
//   int? billCode;
//   int? productId;
//   String? productCode;
//   double? unitPrice;
//   int? quantity;
//   DateTime? sellingDate;
//   double? totalPrice;
//   int? userId;
//   int? transactionId;
//   String? productName;

//   Transactions({
//     this.billCode,
//     this.productCode,
//     this.unitPrice,
//     this.quantity,
//     this.sellingDate,
//     this.totalPrice,
//     this.userId,
//     this.transactionId,
//     this.productName,
//     this.productId,
//   });

//   factory Transactions.fromJson(Map<String, dynamic> json) {
//     return Transactions(
//       billCode: json['bill_code'],
//       productCode: json['product_code'],
//       unitPrice: json['unit_price'],
//       quantity: json['quantity'],
//       sellingDate: json['selling_date'] != null
//           ? DateTime.parse(json['selling_date'])
//           : null,
//       totalPrice: json['total_price'],
//       userId: json['user_id'],
//       transactionId: json['TransactionId'],
//       productName: json['product_name'],
//       productId: json['product_id'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'bill_code': billCode,
//       'product_code': productCode,
//       'unit_price': unitPrice,
//       'quantity': quantity,
//       'selling_date': sellingDate?.toIso8601String(),
//       'total_price': totalPrice,
//       'user_id': userId,
//       'TransactionId': transactionId,
//       'product_name': productName,
//       'product_id': productId,
//     };
//   }
// }

import 'package:le_coin_des_cuisiniers_app/models/products.dart';

class Transactions {
  String? billCode;
  int? productId;
  String? productCode;
  //double? unitPrice;
  int? quantity;
  DateTime? sellingDate;
  double? totalPrice;
  int? userId;
  int? transactionId;
  String? get productName => product.productName;
  final Product product;
  double? get unitPrice => product.sellingPrice;

  Transactions({
    this.billCode,
    this.productCode,
    required this.product,
    this.quantity,
    this.sellingDate,
    this.totalPrice,
    this.userId,
    this.transactionId,
    // this.productName,
    this.productId,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      billCode: json['billCode'],
      productCode: json['productCode'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      sellingDate: json['sellingDate'] != null
          ? DateTime.parse(json['sellingDate'])
          : null,
      // sellingDate: json['sellingDate'],
      totalPrice: json['totalPrice'],
      userId: json['userId'],
      transactionId: json['TransactionId'],
      // productName: json['productName'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billCode': billCode,
      'productCode': productCode,
      //  'unit_price': unitPrice,
      'quantity': quantity,
      'sellingDate': sellingDate, //?.toIso8601String(),
      'totalPrice': totalPrice,
      'userId': userId,
      'TransactionId': transactionId,
      // 'product_name': productName,
      'productId': productId,
    };
  }
}
