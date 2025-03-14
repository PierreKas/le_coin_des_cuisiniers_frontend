import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/label.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';
import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';

class Restock extends StatefulWidget {
  final String prCode;
  const Restock({super.key, required this.prCode});

  @override
  State<Restock> createState() => _RestockState();
}

class _RestockState extends State<Restock> {
  @override
  void initState() {
    super.initState();
    getProductInfo(widget.prCode);
  }

  Product? productInfo;
  Future<Product?> getProductInfo(String prodCode) async {
    productInfo = await ProductController().getProductByCode(prodCode);

    if (productInfo != null) {
      _productCode.text = productInfo!.productCode ?? '';
      _productName.text = productInfo!.productName ?? '';
      _brand.text = productInfo!.brand ?? '';
      _purchasePrice.text = productInfo!.purchasePrice?.toString() ?? '';
      _otherExpenses.text = productInfo!.otherExpenses?.toString() ?? '';
      _sellingPrice.text = productInfo!.sellingPrice?.toString() ?? '';
      _purchaseQty.text = productInfo!.purchasedQuantity?.toString() ?? '';
      // _purchaseDate.text = productInfo!.purchasedDate != null
      //     ? productInfo!.purchasedDate!.toIso8601String().split('T').first
      //     : '';
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
              Text(
                'Ravitaillement du produit ${productInfo?.productName ?? ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
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
                          hintText: '', //'${productInfo?.productCode}',
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
                          enabled: true,
                          hintText: '', //'${productInfo?.productName}',
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
                          hintText: '', // '${productInfo?.brand}',
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
                          enabled: true,
                          hintText: '', // '${productInfo?.purchasePrice}',
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
                          hintText: '', // '${productInfo?.sellingPrice}',
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
                          enabled: true,
                          hintText: '', // '${productInfo?.purchasePrice}',
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
                          controller: _purchaseDate,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: chocolateColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.calendar_today,
                              color: chocolateColor,
                            ),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
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
                  onPressed: () {
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
                    int remainingQuantity =
                        quantity + (productInfo!.remainingQuantity ?? 0);
                    // (quantity - (productInfo!.purchasedQuantity ?? 0)) +
                    //     (productInfo!.remainingQuantity ?? 0);

                    Product newProduct = Product(
                      productCode: productCode,
                      productName: productName,
                      purchasePrice: purchasePrice,
                      purchasedDate: purchasedDate,
                      purchasedQuantity: quantity,
                      sellingPrice: sellingPrice,
                      brand: brand,
                      remainingQuantity: remainingQuantity,
                      otherExpenses: otherExpenses,
                    );

                    ProductController()
                        .updateProduct(productInfo!.id!, newProduct, context);
                    _productCode.clear();
                    _productName.clear();
                    _purchaseDate.clear();
                    _purchaseQty.clear();
                    _sellingPrice.clear();
                    _purchasePrice.clear();
                    _brand.clear();
                  },
                  text: 'Enregistrer')
            ],
          ),
        ),
      ),
    );
  }

  Widget mobile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Ravitaillement du produit ${productInfo?.productName ?? ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            /// Code du produit
            const MyLabel(labelContent: 'Code du produit'),
            const SizedBox(height: 10),
            MyTextField(
              controller: _productCode,
              enabled: false,
              hintText: '',
              obscureText: false,
              prefixIcon: Icons.qr_code_2,
            ),
            const SizedBox(height: 16),

            /// Nom du produit
            const MyLabel(labelContent: 'Nom du produit'),
            const SizedBox(height: 10),
            MyTextField(
              controller: _productName,
              enabled: true,
              hintText: '',
              obscureText: false,
              prefixIcon: Icons.circle,
            ),
            const SizedBox(height: 16),

            /// Marque
            const MyLabel(labelContent: 'Marque'),
            const SizedBox(height: 10),
            MyTextField(
              controller: _brand,
              enabled: true,
              hintText: '',
              obscureText: false,
              prefixIcon: Icons.circle,
            ),
            const SizedBox(height: 16),

            /// Prix d'achat
            const MyLabel(labelContent: 'Prix d\'achat'),
            const SizedBox(height: 10),
            MyTextField(
              controller: _purchasePrice,
              enabled: true,
              hintText: '',
              obscureText: false,
              prefixIcon: Icons.monetization_on,
            ),
            const SizedBox(height: 16),

            /// Prix de vente
            const MyLabel(labelContent: 'Prix de vente'),
            const SizedBox(height: 10),
            MyTextField(
              controller: _sellingPrice,
              enabled: true,
              hintText: '',
              obscureText: false,
              prefixIcon: Icons.monetization_on,
            ),
            const SizedBox(height: 16),

            /// Autres dépenses
            const MyLabel(labelContent: 'Autres dépenses'),
            const SizedBox(height: 10),
            MyTextField(
              controller: _otherExpenses,
              enabled: true,
              hintText: '',
              obscureText: false,
              prefixIcon: Icons.monetization_on,
            ),
            const SizedBox(height: 16),

            /// Quantité achetée
            const MyLabel(labelContent: 'Quantité acheté'),
            const SizedBox(height: 10),
            MyTextField(
              controller: _purchaseQty,
              enabled: true,
              hintText: '',
              obscureText: false,
              prefixIcon: Icons.numbers,
            ),
            const SizedBox(height: 16),

            /// Date d'achat
            const MyLabel(labelContent: 'Date d\'achat'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _purchaseDate,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: chocolateColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIcon:
                    const Icon(Icons.calendar_today, color: chocolateColor),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026),
                  initialDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: chocolateColor, // Header background color
                          onPrimary: Colors.white, // Header text color
                          onSurface: Colors.black, // Body text color
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
                    _purchaseDate.text =
                        _selectedDate!.toIso8601String().split('T').first;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            /// Button
            Center(
              child: MyButtons(
                onPressed: () {
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
                  double sellingPrice = double.tryParse(sellingPriceStr) ?? 0.0;
                  double otherExpenses =
                      double.tryParse(otherExpensesStr) ?? 0.0;
                  int remainingQuantity =
                      quantity + (productInfo!.remainingQuantity ?? 0);

                  Product newProduct = Product(
                    productCode: productCode,
                    productName: productName,
                    purchasePrice: purchasePrice,
                    purchasedDate: purchasedDate,
                    purchasedQuantity: quantity,
                    sellingPrice: sellingPrice,
                    brand: brand,
                    remainingQuantity: remainingQuantity,
                    otherExpenses: otherExpenses,
                  );

                  ProductController()
                      .updateProduct(productInfo!.id!, newProduct, context);
                  _productCode.clear();
                  _productName.clear();
                  _purchaseDate.clear();
                  _purchaseQty.clear();
                  _sellingPrice.clear();
                  _purchasePrice.clear();
                  _brand.clear();
                },
                text: 'Enregistrer',
              ),
            ),
          ],
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
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > tabletWidth) {
              return desktopBody();
            } else {
              return mobile();
            }
          },
        )
      ],
    );
  }
}
