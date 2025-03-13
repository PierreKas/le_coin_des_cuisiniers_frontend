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
  String? get productName => product?.productName;
  Product? product;
  double? get unitPrice => product?.sellingPrice;

  Transactions({
    this.billCode,
    this.productCode,
    this.product,
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
      'quantity': quantity,
      'sellingDate': sellingDate!.toIso8601String(), //?.toIso8601String(),
      'totalPrice': totalPrice,
      'userId': userId,
      'TransactionId': transactionId,
      'productId': productId,
    };
  }
}
