import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/label.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
import 'package:le_coin_des_cuisiniers_app/controller/transactions_controller.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
import 'package:le_coin_des_cuisiniers_app/views/acceuil.dart';
import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/bill_items.dart';
import 'package:le_coin_des_cuisiniers_app/views/user/users_list.dart';
import 'package:provider/provider.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TextEditingController _productName = TextEditingController();

  final TextEditingController _productCode = TextEditingController();

  final TextEditingController _unitPrice = TextEditingController();

  final TextEditingController _totalPrice = TextEditingController();

  final TextEditingController _quantity = TextEditingController();

  String? selectedProductCode;
  List<Product> productsList = [];
  List<Transactions> transactionsList = [];
  Product? selectedProduct;

  Transactions? transactionn;
  int tranId = 1;
  Future<List<Product>> _fetchProducts() async {
    productsList = await ProductController().getProducts();
    setState(() {});
    return productsList;
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchProducts();
    _quantity.addListener(_totalPriceCalculation);
    _unitPrice.addListener(_totalPriceCalculation);
    super.initState();
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

  Widget desktopBody() {
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
                    'Ajouter les produits au panier d\'achat',
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
                                child:
                                    MyLabel(labelContent: 'Nom de l\'article')),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                _fetchProducts();
                              },
                              child: DropdownButtonFormField<String>(
                                value: selectedProductCode,
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
                                      Icons.circle_outlined,
                                      color: chocolateColor,
                                    )),
                                items: productsList.isEmpty
                                    ? []
                                    : productsList.map((Product product) {
                                        return DropdownMenuItem<String>(
                                          value: product.productCode,
                                          child: Text(product.productName!),
                                        );
                                      }).toList(),
                                onChanged: (String? newProductCode) {
                                  setState(() {
                                    selectedProductCode = newProductCode;

                                    selectedProduct = productsList.firstWhere(
                                        (product) =>
                                            product.productCode ==
                                            newProductCode);

                                    if (selectedProduct != null) {
                                      _unitPrice.text = selectedProduct!
                                          .sellingPrice
                                          .toString();
                                      _productName.text = selectedProduct!
                                          .productName
                                          .toString();
                                      _productCode.text = selectedProduct!
                                          .productCode
                                          .toString();
                                    }
                                  });
                                },
                              ),
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
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MyButtons(
                    onPressed: () {
                      String productCode = _productCode.text;
                      String productName = _productName.text;
                      String quantityStr = _quantity.text;
                      String unitPriceStr = _unitPrice.text;
                      String totalPriceStr = _totalPrice.text;

                      int quantity = int.tryParse(quantityStr) ?? 0;

                      double unitPrice = double.tryParse(unitPriceStr) ?? 0.0;
                      double totalPrice = double.tryParse(totalPriceStr) ?? 0.0;

                      setState(() {
                        tranId++;
                        print(tranId);
                      });
                      Transactions newTransaction = Transactions(
                          productCode: productCode,
                          // product.productName: productName,
                          quantity: quantity,
                          sellingDate: DateTime.now(),
                          totalPrice: totalPrice,
                          transactionId: tranId);

                      Provider.of<TransactionsController>(context,
                              listen: false)
                          .addItemOnTheBill(newTransaction, context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BillItems(
                      //       transaction: newTransaction,
                      //     ),
                      //   ),
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
                            initialPage: BillItems(transaction: newTransaction),
                          ),
                        ),
                      );
                      _productCode.clear();
                      _productName.clear();
                      _quantity.clear();
                      _unitPrice.clear();

                      _totalPrice.clear();
                    },
                    text: 'Ajouter',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => BillItems(
            //             transaction: transactionn,
            //           )),
            // ),
            Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BaseLayout(
              initialIndex: 1, // Sales page index
              pages: [
                const Acceuil(), // First page
                if (UsersController.userRole == 'ADMIN') const ProductsList(),
                if (UsersController.userRole == 'ADMIN') const UsersList(),
                const AddTransaction(), // Last page (sales/transactions)
              ],
              initialPage: BillItems(transaction: transactionn),
            ),
          ),
        ),
        child: Icon(
          Icons.shopping_cart_sharp,
          color: Colors.white,
        ),
        backgroundColor: chocolateColor,
      ),
      body: Stack(
        children: [
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
          desktopBody(),
        ],
      ),
    );
  }
}
