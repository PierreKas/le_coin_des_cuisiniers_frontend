// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
// import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
// import 'package:le_coin_des_cuisiniers_app/components/label.dart';
// import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
// import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
// import 'package:le_coin_des_cuisiniers_app/controller/transactions_controller.dart';
// import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
// import 'package:le_coin_des_cuisiniers_app/models/products.dart';
// import 'package:le_coin_des_cuisiniers_app/models/transactions.dart';
// import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';
// import 'package:le_coin_des_cuisiniers_app/views/acceuil.dart';
// import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
// import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';
// import 'package:le_coin_des_cuisiniers_app/views/transactions/bill_items.dart';
// import 'package:le_coin_des_cuisiniers_app/views/user/users_list.dart';
// import 'package:provider/provider.dart';

// class AddTransaction extends StatefulWidget {
//   const AddTransaction({super.key});

//   @override
//   State<AddTransaction> createState() => _AddTransactionState();
// }

// class _AddTransactionState extends State<AddTransaction> {
//   final TextEditingController _productName = TextEditingController();

//   final TextEditingController _productCode = TextEditingController();

//   final TextEditingController _unitPrice = TextEditingController();

//   final TextEditingController _totalPrice = TextEditingController();

//   final TextEditingController _quantity = TextEditingController();

//   String? selectedProductCode;
//   List<Product> productsList = [];
//   List<Transactions> transactionsList = [];
//   Product? selectedProduct;

//   Transactions? transactionn;
//   int tranId = 1;
//   Future<List<Product>> _fetchProducts() async {
//     productsList = await ProductController().getProducts();
//     setState(() {});
//     return productsList;
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     _fetchProducts();
//     _quantity.addListener(_totalPriceCalculation);
//     _unitPrice.addListener(_totalPriceCalculation);
//     super.initState();
//   }

//   void _totalPriceCalculation() {
//     try {
//       int qty = int.tryParse(_quantity.text) ?? 0;
//       double uniPr = double.tryParse(_unitPrice.text) ?? 0.0;
//       double totlPr = qty * uniPr;
//       setState(() {
//         _totalPrice.text = totlPr.toStringAsFixed(2);
//       });
//     } catch (e) {
//       setState(() {
//         _totalPrice.text = '0.00';
//       });
//     }
//   }

//   Widget desktop() {
//     return Consumer<TransactionsController>(
//       builder: (context, value, child) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 30),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: Column(
//                 children: [
//                   const Text(
//                     'Ajouter les produits au panier d\'achat',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Padding(
//                                 padding: EdgeInsets.only(right: 240.0),
//                                 child:
//                                     MyLabel(labelContent: 'Nom de l\'article')),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             // GestureDetector(
//                             //   onTap: () {
//                             //     _fetchProducts();
//                             //   },
//                             //   child: DropdownButtonFormField<String>(
//                             //     value: selectedProductCode,
//                             //     decoration: InputDecoration(
//                             //         border: OutlineInputBorder(
//                             //           borderRadius: BorderRadius.circular(10),
//                             //         ),
//                             //         focusedBorder: OutlineInputBorder(
//                             //           borderRadius: BorderRadius.circular(10.0),
//                             //           borderSide: const BorderSide(
//                             //             color: chocolateColor,
//                             //           ),
//                             //         ),
//                             //         enabledBorder: OutlineInputBorder(
//                             //           borderRadius: BorderRadius.circular(10.0),
//                             //           borderSide: const BorderSide(
//                             //             color: Colors.grey,
//                             //           ),
//                             //         ),
//                             //         prefixIcon: const Icon(
//                             //           Icons.circle_outlined,
//                             //           color: chocolateColor,
//                             //         )),
//                             //     items: productsList.isEmpty
//                             //         ? []
//                             //         : productsList.map((Product product) {
//                             //             return DropdownMenuItem<String>(
//                             //               value: product.productCode,
//                             //               child: Text(product.productName!),
//                             //             );
//                             //           }).toList(),
//                             //     onChanged: (String? newProductCode) {
//                             //       setState(() {
//                             //         selectedProductCode = newProductCode;

//                             //         selectedProduct = productsList.firstWhere(
//                             //             (product) =>
//                             //                 product.productCode ==
//                             //                 newProductCode);

//                             //         if (selectedProduct != null) {
//                             //           _unitPrice.text = selectedProduct!
//                             //               .sellingPrice
//                             //               .toString();
//                             //           _productName.text = selectedProduct!
//                             //               .productName
//                             //               .toString();
//                             //           _productCode.text = selectedProduct!
//                             //               .productCode
//                             //               .toString();
//                             //         }
//                             //       });
//                             //     },
//                             //   ),
//                             // ),
//                             GestureDetector(
//                               onTap: () {
//                                 _fetchProducts();
//                               },
//                               child: DropdownSearch<Product>(
//                                 popupProps: PopupProps.menu(
//                                   showSearchBox: true,
//                                   searchFieldProps: TextFieldProps(
//                                     decoration: InputDecoration(
//                                       hintText: "Search product",
//                                       prefixIcon: const Icon(Icons.search),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
//                                   menuProps: MenuProps(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       borderSide: const BorderSide(
//                                         color: chocolateColor,
//                                       ),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     prefixIcon: const Icon(
//                                       Icons.circle_outlined,
//                                       color: chocolateColor,
//                                     ),
//                                   ),
//                                 ),
//                                 items: productsList,
//                                 itemAsString: (Product product) =>
//                                     product.productName ?? "",
//                                 selectedItem: selectedProduct,
//                                 onChanged: (Product? newProduct) {
//                                   if (newProduct != null) {
//                                     setState(() {
//                                       selectedProductCode =
//                                           newProduct.productCode;
//                                       selectedProduct = newProduct;
//                                       _unitPrice.text = selectedProduct!
//                                           .sellingPrice
//                                           .toString();
//                                       _productName.text = selectedProduct!
//                                           .productName
//                                           .toString();
//                                       _productCode.text = selectedProduct!
//                                           .productCode
//                                           .toString();
//                                     });
//                                   }
//                                 },
//                               ),
//                             ),

//                             const SizedBox(
//                               height: 16,
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.only(right: 240.0),
//                               child: MyLabel(labelContent: 'Quantité'),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             MyTextField(
//                               controller: _quantity,
//                               enabled: true,
//                               hintText: '',
//                               obscureText: false,
//                               prefixIcon: Icons.numbers,
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Flexible(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Padding(
//                                 padding: EdgeInsets.only(right: 240.0),
//                                 child: MyLabel(labelContent: 'Prix unitaire')),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             MyTextField(
//                               controller: _unitPrice,
//                               enabled: false,
//                               hintText: '',
//                               obscureText: false,
//                               prefixIcon: Icons.monetization_on,
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             const Padding(
//                                 padding: EdgeInsets.only(right: 200.0),
//                                 child: MyLabel(labelContent: 'Prix total')),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             MyTextField(
//                               controller: _totalPrice,
//                               enabled: false,
//                               hintText: '',
//                               obscureText: false,
//                               prefixIcon: Icons.monetization_on,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   MyButtons(
//                     onPressed: () {
//                       String productCode = _productCode.text;
//                       //String productName = _productName.text;
//                       String quantityStr = _quantity.text;
//                       //  String unitPriceStr = _unitPrice.text;
//                       String totalPriceStr = _totalPrice.text;

//                       int quantity = int.tryParse(quantityStr) ?? 0;

//                       //   double unitPrice = double.tryParse(unitPriceStr) ?? 0.0;
//                       double totalPrice = double.tryParse(totalPriceStr) ?? 0.0;

//                       selectedProduct = productsList.firstWhere(
//                           (product) => product.productCode == productCode);

//                       setState(() {
//                         tranId++;
//                       });
//                       Transactions newTransaction = Transactions(
//                           productCode: productCode,
//                           product: selectedProduct,
//                           quantity: quantity,
//                           sellingDate: DateTime.now(),
//                           totalPrice: totalPrice,
//                           transactionId: tranId);
//                       Provider.of<TransactionsController>(context,
//                               listen: false)
//                           .addItemOnTheBill(newTransaction, context);
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => BillItems(
//                       //       transaction: newTransaction,
//                       //     ),
//                       //   ),
//                       // );
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BaseLayout(
//                             initialIndex: 1, // Sales page index
//                             pages: [
//                               const Acceuil(), // First page
//                               if (UsersController.userRole == 'ADMIN')
//                                 const ProductsList(),
//                               if (UsersController.userRole == 'ADMIN')
//                                 const UsersList(),
//                               const AddTransaction(), // Last page (sales/transactions)
//                             ],
//                             initialPage: BillItems(transaction: newTransaction),
//                           ),
//                         ),
//                       );
//                       _productCode.clear();
//                       _productName.clear();
//                       _quantity.clear();
//                       _unitPrice.clear();

//                       _totalPrice.clear();
//                     },
//                     text: 'Ajouter',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget mobile() {
//     return Consumer<TransactionsController>(
//       builder: (context, value, child) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Center(
//                   child: Text(
//                     'Ajouter les produits au panier d\'achat',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 /// **Nom de l\'article**
//                 const MyLabel(labelContent: 'Nom de l\'article'),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () {
//                     _fetchProducts();
//                   },
//                   child: DropdownButtonFormField<String>(
//                     value: selectedProductCode,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: const BorderSide(color: chocolateColor),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       prefixIcon: const Icon(
//                         Icons.circle_outlined,
//                         color: chocolateColor,
//                       ),
//                     ),
//                     items: productsList.isEmpty
//                         ? []
//                         : productsList.map((Product product) {
//                             return DropdownMenuItem<String>(
//                               value: product.productCode,
//                               child: Text(product.productName!),
//                             );
//                           }).toList(),
//                     onChanged: (String? newProductCode) {
//                       setState(() {
//                         selectedProductCode = newProductCode;

//                         selectedProduct = productsList.firstWhere(
//                             (product) => product.productCode == newProductCode);

//                         if (selectedProduct != null) {
//                           _unitPrice.text =
//                               selectedProduct!.sellingPrice.toString();
//                           _productName.text =
//                               selectedProduct!.productName.toString();
//                           _productCode.text =
//                               selectedProduct!.productCode.toString();
//                         }
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 /// **Quantité**
//                 const MyLabel(labelContent: 'Quantité'),
//                 const SizedBox(height: 10),
//                 MyTextField(
//                   controller: _quantity,
//                   enabled: true,
//                   hintText: '',
//                   obscureText: false,
//                   prefixIcon: Icons.numbers,
//                 ),
//                 const SizedBox(height: 16),

//                 /// **Prix unitaire**
//                 const MyLabel(labelContent: 'Prix unitaire'),
//                 const SizedBox(height: 10),
//                 MyTextField(
//                   controller: _unitPrice,
//                   enabled: false,
//                   hintText: '',
//                   obscureText: false,
//                   prefixIcon: Icons.monetization_on,
//                 ),
//                 const SizedBox(height: 16),

//                 /// **Prix total**
//                 const MyLabel(labelContent: 'Prix total'),
//                 const SizedBox(height: 10),
//                 MyTextField(
//                   controller: _totalPrice,
//                   enabled: false,
//                   hintText: '',
//                   obscureText: false,
//                   prefixIcon: Icons.monetization_on,
//                 ),
//                 const SizedBox(height: 30),

//                 /// **Ajouter Button**
//                 Center(
//                   child: MyButtons(
//                     onPressed: () {
//                       String productCode = _productCode.text;
//                       String quantityStr = _quantity.text;
//                       String totalPriceStr = _totalPrice.text;

//                       int quantity = int.tryParse(quantityStr) ?? 0;
//                       double totalPrice = double.tryParse(totalPriceStr) ?? 0.0;

//                       selectedProduct = productsList.firstWhere(
//                           (product) => product.productCode == productCode);

//                       setState(() {
//                         tranId++;
//                       });
//                       Transactions newTransaction = Transactions(
//                           productCode: productCode,
//                           product: selectedProduct,
//                           quantity: quantity,
//                           sellingDate: DateTime.now(),
//                           totalPrice: totalPrice,
//                           transactionId: tranId);

//                       Provider.of<TransactionsController>(context,
//                               listen: false)
//                           .addItemOnTheBill(newTransaction, context);

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BaseLayout(
//                             initialIndex: 1, // Sales page index
//                             pages: [
//                               const Acceuil(),
//                               if (UsersController.userRole == 'ADMIN')
//                                 const ProductsList(),
//                               if (UsersController.userRole == 'ADMIN')
//                                 const UsersList(),
//                               const AddTransaction(),
//                             ],
//                             initialPage: BillItems(transaction: newTransaction),
//                           ),
//                         ),
//                       );

//                       _productCode.clear();
//                       _productName.clear();
//                       _quantity.clear();
//                       _unitPrice.clear();
//                       _totalPrice.clear();
//                     },
//                     text: 'Ajouter',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () =>
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //       builder: (context) => BillItems(
//             //             transaction: transactionn,
//             //           )),
//             // ),
//             Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BaseLayout(
//               initialIndex: 1, // Sales page index
//               pages: [
//                 const Acceuil(), // First page
//                 if (UsersController.userRole == 'ADMIN') const ProductsList(),
//                 if (UsersController.userRole == 'ADMIN') const UsersList(),
//                 const AddTransaction(), // Last page (sales/transactions)
//               ],
//               initialPage: BillItems(transaction: transactionn),
//             ),
//           ),
//         ),
//         backgroundColor: chocolateColor,
//         child: const Icon(
//           Icons.shopping_cart_sharp,
//           color: Colors.white,
//         ),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: Opacity(
//               opacity: 0.5,
//               child: Image.asset(
//                 'assets/logo.PNG',
//                 fit: BoxFit.cover,
//                 width: 200,
//                 height: 200,
//               ),
//             ),
//           ),
//           LayoutBuilder(
//             builder: (context, constraints) {
//               if (constraints.maxWidth > tabletWidth) {
//                 return desktop();
//               } else {
//                 return mobile();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/label.dart';
import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
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
import 'package:le_coin_des_cuisiniers_app/views/transactions/bill_items.dart';
import 'package:le_coin_des_cuisiniers_app/views/user/users_list.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

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
  final TextEditingController _sellingDateController = TextEditingController();

  String? selectedProductCode;
  List<Product> productsList = [];
  List<Transactions> transactionsList = [];
  Product? selectedProduct;
  DateTime selectedDate = DateTime.now(); // Default to current date

  Transactions? transactionn;
  int tranId = 1;

  Future<List<Product>> _fetchProducts() async {
    productsList = await ProductController().getProducts();
    setState(() {});
    return productsList;
  }

  @override
  void initState() {
    _fetchProducts();
    _quantity.addListener(_totalPriceCalculation);
    _unitPrice.addListener(_totalPriceCalculation);

    // Set initial date in the text field
    _sellingDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: chocolateColor, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.white, // Calendar background color
              onSurface: Colors.black, // Calendar text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _sellingDateController.text =
            DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyLabel(labelContent: 'Date de vente'),
        const SizedBox(height: 10),
        TextFormField(
          controller: _sellingDateController,
          readOnly: true,
          onTap: () => _selectDate(context),
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
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: chocolateColor,
            ),
            hintText: 'Sélectionner la date',
          ),
        ),
      ],
    );
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
                    'Ajouter les produits au panier d\'achat',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
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
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                _fetchProducts();
                              },
                              child: DropdownSearch<Product>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "Search product",
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: chocolateColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.circle_outlined,
                                      color: chocolateColor,
                                    ),
                                  ),
                                ),
                                items: productsList,
                                itemAsString: (Product product) =>
                                    product.productName ?? "",
                                selectedItem: selectedProduct,
                                onChanged: (Product? newProduct) {
                                  if (newProduct != null) {
                                    setState(() {
                                      selectedProductCode =
                                          newProduct.productCode;
                                      selectedProduct = newProduct;
                                      _unitPrice.text = selectedProduct!
                                          .sellingPrice
                                          .toString();
                                      _productName.text = selectedProduct!
                                          .productName
                                          .toString();
                                      _productCode.text = selectedProduct!
                                          .productCode
                                          .toString();
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.only(right: 240.0),
                              child: MyLabel(labelContent: 'Quantité'),
                            ),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: _quantity,
                              enabled: true,
                              hintText: '',
                              obscureText: false,
                              prefixIcon: Icons.numbers,
                            ),
                            const SizedBox(height: 16),
                            // Add date field for desktop
                            Padding(
                              padding: const EdgeInsets.only(right: 180.0),
                              child: _buildDateField(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(right: 240.0),
                                child: MyLabel(labelContent: 'Prix unitaire')),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: _unitPrice,
                              enabled: false,
                              hintText: '',
                              obscureText: false,
                              prefixIcon: Icons.monetization_on,
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                                padding: EdgeInsets.only(right: 200.0),
                                child: MyLabel(labelContent: 'Prix total')),
                            const SizedBox(height: 10),
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
                  const SizedBox(height: 16),
                  // MyButtons(
                  //   onPressed: () {
                  //     String productCode = _productCode.text;
                  //     String quantityStr = _quantity.text;
                  //     String totalPriceStr = _totalPrice.text;

                  //     int quantity = int.tryParse(quantityStr) ?? 0;
                  //     double totalPrice = double.tryParse(totalPriceStr) ?? 0.0;

                  //     selectedProduct = productsList.firstWhere(
                  //         (product) => product.productCode == productCode);

                  //     setState(() {
                  //       tranId++;
                  //     });

                  //     Transactions newTransaction = Transactions(
                  //         productCode: productCode,
                  //         product: selectedProduct,
                  //         quantity: quantity,
                  //         sellingDate:
                  //             selectedDate, // Use selected date instead of DateTime.now()
                  //         totalPrice: totalPrice,
                  //         transactionId: tranId);

                  //     Provider.of<TransactionsController>(context,
                  //             listen: false)
                  //         .addItemOnTheBill(newTransaction, context);

                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => BaseLayout(
                  //           initialIndex: 1,
                  //           pages: [
                  //             const Acceuil(),
                  //             if (UsersController.userRole == 'ADMIN')
                  //               const ProductsList(),
                  //             if (UsersController.userRole == 'ADMIN')
                  //               const UsersList(),
                  //             const AddTransaction(),
                  //           ],
                  //           initialPage: BillItems(transaction: newTransaction),
                  //         ),
                  //       ),
                  //     );

                  //     _productCode.clear();
                  //     _productName.clear();
                  //     _quantity.clear();
                  //     _unitPrice.clear();
                  //     _totalPrice.clear();
                  //     // Reset date to current date after adding transaction
                  //     setState(() {
                  //       selectedDate = DateTime.now();
                  //       _sellingDateController.text =
                  //           DateFormat('dd/MM/yyyy').format(selectedDate);
                  //     });
                  //   },
                  //   text: 'Ajouter',
                  // ),
                  // Replace the transaction creation section in your MyButtons onPressed callback
                  MyButtons(
                    onPressed: () {
                      String productCode = _productCode.text;
                      String quantityStr = _quantity.text;
                      String totalPriceStr = _totalPrice.text;
                      String unitPriceStr = _unitPrice.text;

                      // Validate inputs
                      if (productCode.isEmpty) {
                        MySnackBar.showErrorMessage(
                            'Veuillez sélectionner un produit', context);
                        return;
                      }

                      if (quantityStr.isEmpty) {
                        MySnackBar.showErrorMessage(
                            'Veuillez entrer une quantité', context);
                        return;
                      }

                      int quantity = int.tryParse(quantityStr) ?? 0;
                      if (quantity <= 0) {
                        MySnackBar.showErrorMessage(
                            'La quantité doit être supérieure à 0', context);
                        return;
                      }

                      double totalPrice = double.tryParse(totalPriceStr) ?? 0.0;
                      double unitPrice = double.tryParse(unitPriceStr) ?? 0.0;

                      if (totalPrice <= 0) {
                        MySnackBar.showErrorMessage(
                            'Prix total invalide', context);
                        return;
                      }

                      // Find the selected product
                      Product? selectedProduct;
                      try {
                        selectedProduct = productsList.firstWhere(
                            (product) => product.productCode == productCode);
                      } catch (e) {
                        MySnackBar.showErrorMessage(
                            'Produit non trouvé', context);
                        return;
                      }

                      setState(() {
                        tranId++;
                      });

                      // Create transaction with all required fields
                      Transactions newTransaction = Transactions(
                        productCode: productCode,
                        product: selectedProduct,
                        // productName: selectedProduct.productName, // Ensure productName is set
                        quantity: quantity,
                        sellingDate: selectedDate, // Use selected date
                        totalPrice: totalPrice,
                        // unitPrice: unitPrice, // Ensure unitPrice is set
                        transactionId: tranId,
                      );

                      // Debug print before adding
                      print('Creating new transaction:');
                      print('  productCode: ${newTransaction.productCode}');
                      print('  productName: ${newTransaction.productName}');
                      print('  quantity: ${newTransaction.quantity}');
                      print('  sellingDate: ${newTransaction.sellingDate}');
                      print('  totalPrice: ${newTransaction.totalPrice}');
                      print('  unitPrice: ${newTransaction.unitPrice}');

                      Provider.of<TransactionsController>(context,
                              listen: false)
                          .addItemOnTheBill(newTransaction, context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BaseLayout(
                            initialIndex: 1,
                            pages: [
                              const Acceuil(),
                              if (UsersController.userRole == 'ADMIN')
                                const ProductsList(),
                              if (UsersController.userRole == 'ADMIN')
                                const UsersList(),
                              const AddTransaction(),
                            ],
                            initialPage: BillItems(transaction: newTransaction),
                          ),
                        ),
                      );

                      // Clear form fields
                      _productCode.clear();
                      _productName.clear();
                      _quantity.clear();
                      _unitPrice.clear();
                      _totalPrice.clear();

                      // Reset date and selected product
                      setState(() {
                        selectedDate = DateTime.now();
                        _sellingDateController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                        selectedProduct = null;
                        selectedProductCode = null;
                      });
                    },
                    text: 'Ajouter',
                  )
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
                    'Ajouter les produits au panier d\'achat',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),

                /// **Nom de l\'article**
                const MyLabel(labelContent: 'Nom de l\'article'),
                const SizedBox(height: 10),
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
                        borderSide: const BorderSide(color: chocolateColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: const Icon(
                        Icons.circle_outlined,
                        color: chocolateColor,
                      ),
                    ),
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
                            (product) => product.productCode == newProductCode);

                        if (selectedProduct != null) {
                          _unitPrice.text =
                              selectedProduct!.sellingPrice.toString();
                          _productName.text =
                              selectedProduct!.productName.toString();
                          _productCode.text =
                              selectedProduct!.productCode.toString();
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                /// **Quantité**
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

                /// **Date de vente**
                _buildDateField(),
                const SizedBox(height: 16),

                /// **Prix unitaire**
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

                /// **Prix total**
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

                /// **Ajouter Button**
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

                      setState(() {
                        tranId++;
                      });

                      Transactions newTransaction = Transactions(
                          productCode: productCode,
                          product: selectedProduct,
                          quantity: quantity,
                          sellingDate:
                              selectedDate, // Use selected date instead of DateTime.now()
                          totalPrice: totalPrice,
                          transactionId: tranId);

                      Provider.of<TransactionsController>(context,
                              listen: false)
                          .addItemOnTheBill(newTransaction, context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BaseLayout(
                            initialIndex: 1,
                            pages: [
                              const Acceuil(),
                              if (UsersController.userRole == 'ADMIN')
                                const ProductsList(),
                              if (UsersController.userRole == 'ADMIN')
                                const UsersList(),
                              const AddTransaction(),
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
                      // Reset date to current date after adding transaction
                      setState(() {
                        selectedDate = DateTime.now();
                        _sellingDateController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    },
                    text: 'Ajouter',
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
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BaseLayout(
              initialIndex: 1,
              pages: [
                const Acceuil(),
                if (UsersController.userRole == 'ADMIN') const ProductsList(),
                if (UsersController.userRole == 'ADMIN') const UsersList(),
                const AddTransaction(),
              ],
              initialPage: BillItems(transaction: transactionn),
            ),
          ),
        ),
        backgroundColor: chocolateColor,
        child: const Icon(
          Icons.shopping_cart_sharp,
          color: Colors.white,
        ),
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
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > tabletWidth) {
                return desktop();
              } else {
                return mobile();
              }
            },
          ),
        ],
      ),
    );
  }
}
