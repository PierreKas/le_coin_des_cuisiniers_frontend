import 'dart:math';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/label.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';

class UpdateProduct extends StatefulWidget {
  final String productCode;
  const UpdateProduct({super.key, required this.productCode});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  @override
  void initState() {
    super.initState();
    getProductInfo(widget.productCode);
  }

  Product? productInfo;
  Future<Product?> getProductInfo(String productCode) async {
    productInfo = await ProductController().getProductByCode(productCode);

    if (productInfo != null) {
      _productCode.text = productInfo!.productCode ?? '';
      _productName.text = productInfo!.productName ?? '';
      _brand.text = productInfo!.brand ?? '';
      _purchasePrice.text = productInfo!.purchasePrice?.toString() ?? '';
      _otherExpenses.text = productInfo!.otherExpenses?.toString() ?? '';
      _sellingPrice.text = productInfo!.sellingPrice?.toString() ?? '';
      _purchaseQty.text = productInfo!.purchasedQuantity?.toString() ?? '';
      _purchaseDate.text = productInfo!.purchasedDate != null
          ? productInfo!.purchasedDate!.toIso8601String().split('T').first
          : '';
    } else {
      MySnackBar.showErrorMessage(
          'Une erreur \'est produite, réessayez dans un instant', context);
    }

    setState(() {});
    return productInfo;
  }

  final TextEditingController _productName = TextEditingController();

  final TextEditingController _purchasePrice = TextEditingController();

  final TextEditingController _productCode = TextEditingController();

  final TextEditingController _sellingPrice = TextEditingController();

  final TextEditingController _purchaseQty = TextEditingController();

  final TextEditingController _purchaseDate = TextEditingController();

  final TextEditingController _brand = TextEditingController();

  final TextEditingController _otherExpenses = TextEditingController();
  bool isLoading = false;
  DateTime? _selectedDate;
  Widget desktopBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Text(
                'Modifiez les informations du produit',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 240.0),
                            child: MyLabel(labelContent: 'Code du produit')),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _productCode,
                          enabled: false,
                          hintText: '${productInfo?.productCode}',
                          obscureText: false,
                          prefixIcon: Icons.qr_code_2,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 240.0),
                            child: MyLabel(labelContent: 'Nom du produit')),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _productName,
                          enabled: false,
                          hintText: '${productInfo?.productName}',
                          obscureText: false,
                          prefixIcon: Icons.circle,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 240.0),
                            child: MyLabel(labelContent: 'Marque')),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _brand,
                          enabled: true,
                          hintText: '${productInfo?.brand}',
                          obscureText: false,
                          prefixIcon: Icons.circle,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 240.0),
                            child: MyLabel(labelContent: 'Prix d\'achat')),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _purchasePrice,
                          enabled: false,
                          hintText: '${productInfo?.purchasePrice}',
                          obscureText: false,
                          prefixIcon: Icons.monetization_on,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 200.0),
                            child: MyLabel(labelContent: 'Prix de vente')),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _sellingPrice,
                          enabled: true,
                          hintText: '${productInfo?.sellingPrice}',
                          obscureText: false,
                          prefixIcon: Icons.monetization_on,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 200.0),
                            child: MyLabel(labelContent: 'Autres depenses')),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _otherExpenses,
                          enabled: true,
                          hintText: '',
                          obscureText: false,
                          prefixIcon: Icons.monetization_on,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 260.0),
                            child: MyLabel(labelContent: 'Quantité acheté')),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _purchaseQty,
                          enabled: false,
                          hintText: '${productInfo?.purchasePrice}',
                          obscureText: false,
                          prefixIcon: Icons.numbers,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 200.0),
                            child: MyLabel(labelContent: 'Date d\'achat')),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: _purchaseDate,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: chocolateColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: chocolateColor),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2026),
                              initialDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary:
                                          chocolateColor, // Header background color
                                      onPrimary:
                                          Colors.white, // Header text color
                                      onSurface:
                                          Colors.black, // Body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            chocolateColor, // Button text color
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _selectedDate = pickedDate;
                                _purchaseDate.text = _selectedDate!
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              MyButtons(
                  onPressed: () async {
                    String productCode = _productCode.text;
                    String productName = _productName.text;
                    String brand = _brand.text;
                    String quantityStr = _purchaseQty.text;
                    String purchasePriceStr = _purchasePrice.text;
                    String sellingPriceStr = _sellingPrice.text;
                    String purchasedDateStr = _purchaseDate.text;
                    String otherExpensesStr = _otherExpenses.text;

                    int quantity = int.tryParse(quantityStr) ?? 0;
                    DateTime? purchasedDate = purchasedDateStr.isNotEmpty
                        ? DateTime.tryParse(purchasedDateStr)
                        : null;
                    double purchasePrice =
                        double.tryParse(purchasePriceStr) ?? 0.0;
                    double sellingPrice =
                        double.tryParse(sellingPriceStr) ?? 0.0;
                    double otherExpenses =
                        double.tryParse(otherExpensesStr) ?? 0.0;
                    // int remainingQuantity =
                    //     (quantity - (productInfo!.purchasedQuantity ?? 0)) +
                    //         (productInfo!.remainingQuantity ?? 0);

                    Product newProduct = Product(
                      productCode: productCode,
                      productName: productName,
                      purchasePrice: purchasePrice,
                      purchasedDate: purchasedDate,
                      purchasedQuantity: quantity,
                      sellingPrice: sellingPrice,
                      brand: brand,
                      remainingQuantity: productInfo!.remainingQuantity,
                      otherExpenses: otherExpenses,
                    );

                    await ProductController()
                        .updateProduct(productInfo!.id!, newProduct, context);
                    _productCode.clear();
                    _productName.clear();
                    _purchaseDate.clear();
                    _purchaseQty.clear();
                    _sellingPrice.clear();
                    _purchasePrice.clear();
                    _brand.clear();
                  },
                  text: 'Modifier')
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      initialIndex: 1,
      pages: [
        const ProductsList(),
        desktopBody(),
      ],
    );
  }
}
