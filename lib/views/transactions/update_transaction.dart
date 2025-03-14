import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/label.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
import 'package:le_coin_des_cuisiniers_app/controller/transactions_controller.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';
import 'package:le_coin_des_cuisiniers_app/views/acceuil.dart';
import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/add_transactions.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/bill_items.dart';
import 'package:le_coin_des_cuisiniers_app/views/user/users_list.dart';
import 'package:provider/provider.dart';

class UpdateTransaction extends StatefulWidget {
  final int transId;
  const UpdateTransaction({super.key, required this.transId});

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  final TextEditingController _productName = TextEditingController();

  final TextEditingController _productCode = TextEditingController();

  final TextEditingController _unitPrice = TextEditingController();

  final TextEditingController _totalPrice = TextEditingController();

  final TextEditingController _quantity = TextEditingController();

  Transactions? transactionInfo;

  @override
  void initState() {
    _getTransactionData();
    _fetchProducts();
    _quantity.addListener(_totalPriceCalculation);
    _unitPrice.addListener(_totalPriceCalculation);
    super.initState();
  }

  Product? selectedProduct;
  List<Product> productsList = [];
  Future<List<Product>> _fetchProducts() async {
    productsList = await ProductController().getProducts();
    setState(() {});
    return productsList;
  }

  void _getTransactionData() async {
    try {
      transactionInfo =
          await Provider.of<TransactionsController>(context, listen: false)
              .getTransactionByTransId(widget.transId, context);

      if (transactionInfo != null) {
        _productCode.text = transactionInfo!.productCode ?? '';
        _productName.text = transactionInfo!.productName ?? '';
        _unitPrice.text = transactionInfo!.unitPrice?.toString() ?? '';
        _totalPrice.text = transactionInfo!.totalPrice?.toString() ?? '';
        _quantity.text = transactionInfo!.quantity?.toString() ?? '';
        // _sellingDate.text = transactionn!.sellingDate != null
        //     ? transactionn!.sellingDate!.toIso8601String().split('T').first
        //     : '';
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _totalPriceCalculation() {
    try {
      int qty = int.tryParse(_quantity.text) ?? 0;
      double uniPr = double.tryParse(_unitPrice.text) ?? 0.0;
      double totlPr = qty * uniPr;
      setState(() {
        _totalPrice.text = totlPr.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _totalPrice.text = '0.00';
      });
    }
  }

  Widget desktop() {
    return Consumer<TransactionsController>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const Text(
                    'MODIFICATION DE LA TRANSACTION',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 73, 71, 71)),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // const Text(
                  //   'Ajouter les produits au panier d\'achat',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: Colors.grey),
                  // ),
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
                                child:
                                    MyLabel(labelContent: 'Nom de l\'article')),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              controller: _productName,
                              enabled: false,
                              hintText: '',
                              obscureText: false,
                              prefixIcon: Icons.circle,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 240.0),
                              child: MyLabel(labelContent: 'Quantité'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              controller: _quantity,
                              enabled: true,
                              hintText: '',
                              obscureText: false,
                              prefixIcon: Icons.numbers,
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
                                child: MyLabel(labelContent: 'Prix unitaire')),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              controller: _unitPrice,
                              enabled: false,
                              hintText: '',
                              obscureText: false,
                              prefixIcon: Icons.monetization_on,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Padding(
                                padding: EdgeInsets.only(right: 200.0),
                                child: MyLabel(labelContent: 'Prix total')),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              controller: _totalPrice,
                              enabled: false,
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
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MyButtons(
                      onPressed: () {
                        String productCode = _productCode.text;
                        // String productName = _productName.text;
                        String quantityStr = _quantity.text;
                        //String unitPriceStr = _unitPrice.text;
                        String totalPriceStr = _totalPrice.text;

                        int quantity = int.tryParse(quantityStr) ?? 0;

                        //double unitPrice = double.tryParse(unitPriceStr) ?? 0.0;
                        double totalPrice =
                            double.tryParse(totalPriceStr) ?? 0.0;
                        selectedProduct = productsList.firstWhere(
                            (product) => product.productCode == productCode);
                        Transactions transactionToUpdate = Transactions(
                            productCode: productCode,
                            product: selectedProduct,
                            quantity: quantity,
                            sellingDate: DateTime.now(),
                            totalPrice: totalPrice,
                            transactionId: widget.transId);

                        Provider.of<TransactionsController>(context,
                                listen: false)
                            .updateTransaction(transactionToUpdate, context);
                        // context.read<TransactionsController>().updateTransaction(transactionToUpdate, context);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => BillItems(
                        //             transaction: transactionToUpdate,
                        //           )),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BaseLayout(
                              initialIndex: 1, // Sales page index
                              pages: [
                                const Acceuil(), // First page
                                if (UsersController.userRole == 'ADMIN')
                                  const ProductsList(),
                                if (UsersController.userRole == 'ADMIN')
                                  const UsersList(),
                                const AddTransaction(), // Last page (sales/transactions)
                              ],
                              initialPage:
                                  BillItems(transaction: transactionToUpdate),
                            ),
                          ),
                        );

                        _productCode.clear();
                        _productName.clear();
                        _quantity.clear();
                        _unitPrice.clear();
                        _totalPrice.clear();
                      },
                      text: 'Modifier')
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget mobile() {
    return Consumer<TransactionsController>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'MODIFICATION DE LA TRANSACTION',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 73, 71, 71),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // **Nom de l'article**
                const MyLabel(labelContent: 'Nom de l\'article'),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _productName,
                  enabled: false,
                  hintText: '',
                  obscureText: false,
                  prefixIcon: Icons.circle,
                ),
                const SizedBox(height: 16),

                // **Quantité**
                const MyLabel(labelContent: 'Quantité'),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _quantity,
                  enabled: true,
                  hintText: '',
                  obscureText: false,
                  prefixIcon: Icons.numbers,
                ),
                const SizedBox(height: 16),

                // **Prix unitaire**
                const MyLabel(labelContent: 'Prix unitaire'),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _unitPrice,
                  enabled: false,
                  hintText: '',
                  obscureText: false,
                  prefixIcon: Icons.monetization_on,
                ),
                const SizedBox(height: 16),

                // **Prix total**
                const MyLabel(labelContent: 'Prix total'),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _totalPrice,
                  enabled: false,
                  hintText: '',
                  obscureText: false,
                  prefixIcon: Icons.monetization_on,
                ),
                const SizedBox(height: 30),

                // **Modifier Button**
                Center(
                  child: MyButtons(
                    onPressed: () {
                      String productCode = _productCode.text;
                      String quantityStr = _quantity.text;
                      String totalPriceStr = _totalPrice.text;

                      int quantity = int.tryParse(quantityStr) ?? 0;
                      double totalPrice = double.tryParse(totalPriceStr) ?? 0.0;

                      selectedProduct = productsList.firstWhere(
                          (product) => product.productCode == productCode);

                      Transactions transactionToUpdate = Transactions(
                          productCode: productCode,
                          product: selectedProduct,
                          quantity: quantity,
                          sellingDate: DateTime.now(),
                          totalPrice: totalPrice,
                          transactionId: widget.transId);

                      Provider.of<TransactionsController>(context,
                              listen: false)
                          .updateTransaction(transactionToUpdate, context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BaseLayout(
                            initialIndex: 1, // Sales page index
                            pages: [
                              const Acceuil(),
                              if (UsersController.userRole == 'ADMIN')
                                const ProductsList(),
                              if (UsersController.userRole == 'ADMIN')
                                const UsersList(),
                              const AddTransaction(),
                            ],
                            initialPage:
                                BillItems(transaction: transactionToUpdate),
                          ),
                        ),
                      );

                      _productCode.clear();
                      _productName.clear();
                      _quantity.clear();
                      _unitPrice.clear();
                      _totalPrice.clear();
                    },
                    text: 'Modifier',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      initialIndex: 3,
      pages: [
        const Acceuil(),
        const ProductsList(),
        const UsersList(),
        Stack(children: [
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/logo.PNG',
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > tabletWidth) {
                return desktop();
              } else {
                return mobile();
              }
            },
          ),
        ]),
      ],
    );
  }
}
