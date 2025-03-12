// class Product {
//   String? productCode;
//   String? productName;
//   String? brand;
//   double? purchasePrice;
//   double? otherExpenses;
//   double? sellingPrice;
//   int? purchasedQuantity;
//   DateTime? purchasedDate;
//   int? remainingQuantity;
//   int? id;

//   Product({
//     this.productCode,
//     this.productName,
//     this.purchasePrice,
//     this.otherExpenses,
//     this.purchasedQuantity,
//     this.purchasedDate,
//     this.sellingPrice,
//     this.brand,
//     this.remainingQuantity,
//     this.id,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productCode: json['product_code'],
//       productName: json['productName'],
//       brand: json['brand'],
//       purchasePrice: (json['purchase_price'] is int)
//           ? (json['purchase_price'] as int).toDouble()
//           : json['purchase_price'],
//       purchasedQuantity: json['purchased_quantity'],
//       purchasedDate: json['purchased_date'] != null
//           ? DateTime.parse(json['purchased_date'])
//           : null,
//       sellingPrice: (json['selling_price'] is int)
//           ? (json['selling_price'] as int).toDouble()
//           : json['selling_price'],
//       remainingQuantity: json['remaining_quantity'],
//       otherExpenses: (json['other_expenses'] is int)
//           ? (json['other_expenses'] as int).toDouble()
//           : json['other_expenses'],
//       id: json['id'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'product_code': productCode,
//       'productName': productName,
//       'purchase_price': purchasePrice,
//       'purchased_quantity': purchasedQuantity,
//       'purchased_date': purchasedDate?.toIso8601String(),
//       'selling_price': sellingPrice,
//       'brand': brand,
//       'remaining_quantity': remainingQuantity,
//       'other_expenses': otherExpenses,
//       'id': id,
//     };
//   }

//   @override
//   String toString() {
//     return 'Product(productCode: $productCode, productName: $productName, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, purchasedQuantity: $purchasedQuantity, purchasedDate: $purchasedDate, remainingQuantity: $remainingQuantity,brand: $brand, other_expenses: $otherExpenses, id:$id)';
//   }
// }
class Product {
  String? productCode;
  String? productName;
  String? brand;
  double? purchasePrice;
  double? otherExpenses;
  double? sellingPrice;
  int? purchasedQuantity;
  DateTime? purchasedDate;
  int? remainingQuantity;
  int? id;

  Product({
    this.productCode,
    this.productName,
    this.purchasePrice,
    this.otherExpenses,
    this.purchasedQuantity,
    this.purchasedDate,
    this.sellingPrice,
    this.brand,
    this.remainingQuantity,
    this.id,
  });

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     productCode: json['product_code'],
  //     productName: json['product_name'],
  //     brand: json['brand'],
  //     purchasePrice: (json['purchase_price'] is int)
  //         ? (json['purchase_price'] as int).toDouble()
  //         : json['purchase_price'],
  //     purchasedQuantity: json['purchased_quantity'],
  //     purchasedDate: json['purchased_date'] != null
  //         ? DateTime.parse(json['purchased_date'])
  //         : null,
  //     sellingPrice: (json['selling_price'] is int)
  //         ? (json['selling_price'] as int).toDouble()
  //         : json['selling_price'],
  //     remainingQuantity: json['remaining_quantity'],
  //     otherExpenses: (json['other_expenses'] is int)
  //         ? (json['other_expenses'] as int).toDouble()
  //         : json['other_expenses'],
  //     id: json['id'],
  //   );
  // }
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productCode: json['productCode'],
      productName: json['productName'],
      brand: json['brand'],
      purchasePrice: (json['purchasePrice'] is int)
          ? (json['purchasePrice'] as int).toDouble()
          : json['purchasePrice'],
      purchasedQuantity: json['purchasedQuantity'],
      purchasedDate: json['purchasedDate'] != null
          ? DateTime.parse(json['purchasedDate'])
          : null,
      sellingPrice: (json['sellingPrice'] is int)
          ? (json['sellingPrice'] as int).toDouble()
          : json['sellingPrice'],
      remainingQuantity: json['remainingQuantity'],
      otherExpenses: (json['otherExpenses'] is int)
          ? (json['otherExpenses'] as int).toDouble()
          : json['otherExpenses'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productCode': productCode,
      'productName': productName,
      'purchasePrice': purchasePrice,
      'purchasedQuantity': purchasedQuantity,
      'purchasedDate': purchasedDate?.toIso8601String(),
      'sellingPrice': sellingPrice,
      'brand': brand,
      'remainingQuantity': remainingQuantity,
      'otherExpenses': otherExpenses,
      'id': id,
    };
  }
}
