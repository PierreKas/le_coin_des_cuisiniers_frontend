// import 'package:flutter/material.dart';
// import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
// import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
// import 'package:le_coin_des_cuisiniers_app/components/label.dart';
// import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
// import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
// import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
// import 'package:le_coin_des_cuisiniers_app/dashboard/views/users_list.dart';
// import 'package:le_coin_des_cuisiniers_app/models/products.dart';
// import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';
// import 'package:le_coin_des_cuisiniers_app/views/acceuil.dart';
// import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
// import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';
// import 'package:le_coin_des_cuisiniers_app/views/product/recording_list.dart';
// import 'package:le_coin_des_cuisiniers_app/views/transactions/add_transactions.dart';
// import 'package:provider/provider.dart';

// class AddProduct extends StatefulWidget {
//   const AddProduct({super.key});

//   @override
//   State<AddProduct> createState() => _AddProductState();
// }

// class _AddProductState extends State<AddProduct> {
//   final TextEditingController _productName = TextEditingController();

//   final TextEditingController _productCode = TextEditingController();

//   final TextEditingController _purchasePrice = TextEditingController();

//   final TextEditingController _sellingPrice = TextEditingController();

//   final TextEditingController _purchaseQty = TextEditingController();

//   final TextEditingController _purchaseDate = TextEditingController();

//   final TextEditingController _brand = TextEditingController();

//   //final TextEditingController _otherExpenses = TextEditingController();
//   bool isLoading = false;
//   DateTime? _selectedDate;
//   Product? productt;
//   Widget desktopBody() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 30),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Column(
//             children: [
//               const Text(
//                 'Complétez ici les informations du nouveau produit',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Flexible(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Padding(
//                             padding: EdgeInsets.only(right: 240.0),
//                             child: MyLabel(labelContent: 'Code du produit')),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         MyTextField(
//                           controller: _productCode,
//                           enabled: true,
//                           hintText: '',
//                           obscureText: false,
//                           prefixIcon: Icons.qr_code_2,
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         const Padding(
//                             padding: EdgeInsets.only(right: 240.0),
//                             child: MyLabel(labelContent: 'Nom du produit')),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         MyTextField(
//                           controller: _productName,
//                           enabled: true,
//                           hintText: '',
//                           obscureText: false,
//                           prefixIcon: Icons.circle,
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         const Padding(
//                             padding: EdgeInsets.only(right: 240.0),
//                             child: MyLabel(labelContent: 'Marque')),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         MyTextField(
//                           controller: _brand,
//                           enabled: true,
//                           hintText: '',
//                           obscureText: false,
//                           prefixIcon: Icons.circle,
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Flexible(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Padding(
//                             padding: EdgeInsets.only(right: 240.0),
//                             child: MyLabel(labelContent: 'Prix d\'achat')),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         MyTextField(
//                           controller: _purchasePrice,
//                           enabled: true,
//                           hintText: '',
//                           obscureText: false,
//                           prefixIcon: Icons.monetization_on,
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         const Padding(
//                             padding: EdgeInsets.only(right: 200.0),
//                             child: MyLabel(labelContent: 'Prix de vente')),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         MyTextField(
//                           controller: _sellingPrice,
//                           enabled: true,
//                           hintText: '',
//                           obscureText: false,
//                           prefixIcon: Icons.monetization_on,
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Flexible(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Padding(
//                             padding: EdgeInsets.only(right: 260.0),
//                             child: MyLabel(labelContent: 'Quantité acheté')),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         MyTextField(
//                           controller: _purchaseQty,
//                           enabled: true,
//                           hintText: '',
//                           obscureText: false,
//                           prefixIcon: Icons.numbers,
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         const Padding(
//                             padding: EdgeInsets.only(right: 200.0),
//                             child: MyLabel(labelContent: 'Date d\'achat')),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         TextFormField(
//                           controller: _purchaseDate,
//                           cursorColor: Colors.grey,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: const BorderSide(
//                                 color: chocolateColor,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             prefixIcon: const Icon(
//                               Icons.calendar_today,
//                               color: chocolateColor,
//                             ),
//                           ),
//                           onTap: () async {
//                             DateTime? pickedDate = await showDatePicker(
//                               context: context,
//                               firstDate: DateTime(2024),
//                               lastDate: DateTime(2026),
//                               initialDate: DateTime.now(),
//                               builder: (context, child) {
//                                 return Theme(
//                                   data: Theme.of(context).copyWith(
//                                     colorScheme: const ColorScheme.light(
//                                       primary:
//                                           chocolateColor, // Header background color
//                                       onPrimary:
//                                           Colors.white, // Header text color
//                                       onSurface:
//                                           Colors.black, // Body text color
//                                     ),
//                                     textButtonTheme: TextButtonThemeData(
//                                       style: TextButton.styleFrom(
//                                           foregroundColor:
//                                               chocolateColor // Button text color
//                                           ),
//                                     ),
//                                   ),
//                                   child: child!,
//                                 );
//                               },
//                             );

//                             if (pickedDate != null) {
//                               setState(() {
//                                 _selectedDate = pickedDate;
//                                 _purchaseDate.text = _selectedDate!
//                                     .toIso8601String()
//                                     .split('T')
//                                     .first;
//                               });
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               MyButtons(
//                 onPressed: () async {
//                   String productCode = _productCode.text;
//                   String productName = _productName.text;
//                   String brand = _brand.text;
//                   String quantityStr = _purchaseQty.text;
//                   String purchasePriceStr = _purchasePrice.text;
//                   String sellingPriceStr = _sellingPrice.text;
//                   // String otherExpensesStr = _otherExpenses.text;
//                   String purchasedDateStr = _purchaseDate.text;

//                   int quantity = int.tryParse(quantityStr) ?? 0;
//                   DateTime? purchasedDate = purchasedDateStr.isNotEmpty
//                       ? DateTime.tryParse(purchasedDateStr)
//                       : null;
//                   double purchasePrice =
//                       double.tryParse(purchasePriceStr) ?? 0.0;
//                   double sellingPrice = double.tryParse(sellingPriceStr) ?? 0.0;
//                   // double otherExpenses =
//                   //     double.tryParse(otherExpensesStr) ?? 0.0;

//                   Product newProduct = Product(
//                     productCode: productCode,
//                     productName: productName,
//                     purchasePrice: purchasePrice,
//                     purchasedDate: purchasedDate,
//                     purchasedQuantity: quantity,
//                     sellingPrice: sellingPrice,
//                     brand: brand,
//                     remainingQuantity: quantity,
//                     otherExpenses: 0,
//                   );

//                   // ProductController().addProduct(newProduct, context);
//                   Provider.of<ProductController>(context, listen: false)
//                       .addProductOnList(newProduct, context);
//                   _productCode.clear();
//                   _productName.clear();
//                   _purchaseDate.clear();
//                   _purchaseQty.clear();
//                   _sellingPrice.clear();
//                   _purchasePrice.clear();
//                   _brand.clear();
//                   //  _otherExpenses.clear();
//                 },
//                 text: 'Ajouter',
//               ),
//               FloatingActionButton(
//                 onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BaseLayout(
//                       initialIndex: 1,
//                       pages: [
//                         const Acceuil(),
//                         if (UsersController.userRole == 'ADMIN')
//                           const ProductsList(),
//                         if (UsersController.userRole == 'ADMIN')
//                           const UsersList(),
//                         const AddTransaction(),
//                       ],
//                       initialPage: RecordingList(product: productt),
//                     ),
//                   ),
//                 ),
//                 backgroundColor: chocolateColor,
//                 child: const Row(
//                   children: [
//                     Text(
//                       'Liste ',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     const Icon(
//                       Icons.checklist,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget mobileBody() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Complétez ici les informations du nouveau produit',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 20),

//             const MyLabel(labelContent: 'Code du produit'),
//             const SizedBox(height: 10),
//             MyTextField(
//               controller: _productCode,
//               enabled: true,
//               hintText: '',
//               obscureText: false,
//               prefixIcon: Icons.qr_code_2,
//             ),
//             const SizedBox(height: 16),

//             /// **Nom du produit**
//             // const Padding(
//             //   padding: EdgeInsets.only(right: 240.0),
//             //   child:
//             // ),
//             const MyLabel(labelContent: 'Nom du produit'),
//             const SizedBox(height: 10),
//             MyTextField(
//               controller: _productName,
//               enabled: true,
//               hintText: '',
//               obscureText: false,
//               prefixIcon: Icons.circle,
//             ),
//             const SizedBox(height: 16),

//             /// **Marque**
//             // const Padding(
//             //   padding: EdgeInsets.only(right: 240.0),
//             //   child:
//             // ),
//             const MyLabel(labelContent: 'Marque'),
//             const SizedBox(height: 10),
//             MyTextField(
//               controller: _brand,
//               enabled: true,
//               hintText: '',
//               obscureText: false,
//               prefixIcon: Icons.circle,
//             ),
//             const SizedBox(height: 16),

//             /// **Prix d'achat**
//             // const Padding(
//             //   padding: EdgeInsets.only(right: 240.0),
//             //   child:
//             // ),
//             const MyLabel(labelContent: 'Prix d\'achat'),
//             const SizedBox(height: 10),
//             MyTextField(
//               controller: _purchasePrice,
//               enabled: true,
//               hintText: '',
//               obscureText: false,
//               prefixIcon: Icons.monetization_on,
//             ),
//             const SizedBox(height: 16),

//             /// **Prix de vente**
//             // const Padding(
//             //   padding: EdgeInsets.only(right: 240.0),
//             //   child:
//             // ),
//             const MyLabel(labelContent: 'Prix de vente'),
//             const SizedBox(height: 10),
//             MyTextField(
//               controller: _sellingPrice,
//               enabled: true,
//               hintText: '',
//               obscureText: false,
//               prefixIcon: Icons.monetization_on,
//             ),
//             const SizedBox(height: 16),

//             /// **Autres dépenses**
//             // const Padding(
//             //   padding: EdgeInsets.only(right: 240.0),
//             //   child:
//             // ),
//             // const MyLabel(labelContent: 'Autres dépenses'),
//             // const SizedBox(height: 10),
//             // MyTextField(
//             //   controller: _otherExpenses,
//             //   enabled: true,
//             //   hintText: '',
//             //   obscureText: false,
//             //   prefixIcon: Icons.monetization_on,
//             // ),
//             // const SizedBox(height: 16),

//             const MyLabel(labelContent: 'Quantité achetée'),
//             const SizedBox(height: 10),
//             MyTextField(
//               controller: _purchaseQty,
//               enabled: true,
//               hintText: '',
//               obscureText: false,
//               prefixIcon: Icons.numbers,
//             ),
//             const SizedBox(height: 16),

//             /// **Date d'achat (TextField for Date Picker)**
//             // const Padding(
//             //   padding: EdgeInsets.only(right: 240.0),
//             //   child:
//             // ),
//             const MyLabel(labelContent: 'Date d\'achat'),
//             const SizedBox(height: 10),
//             TextFormField(
//               controller: _purchaseDate,
//               cursorColor: Colors.grey,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: const BorderSide(color: chocolateColor),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 prefixIcon:
//                     const Icon(Icons.calendar_today, color: chocolateColor),
//               ),
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   firstDate: DateTime(2024),
//                   lastDate: DateTime(2026),
//                   initialDate: DateTime.now(),
//                   builder: (context, child) {
//                     return Theme(
//                       data: Theme.of(context).copyWith(
//                         colorScheme: const ColorScheme.light(
//                           primary: chocolateColor, // Header background color
//                           onPrimary: Colors.white, // Header text color
//                           onSurface: Colors.black, // Body text color
//                         ),
//                         textButtonTheme: TextButtonThemeData(
//                           style: TextButton.styleFrom(
//                             foregroundColor:
//                                 chocolateColor, // Button text color
//                           ),
//                         ),
//                       ),
//                       child: child!,
//                     );
//                   },
//                 );

//                 if (pickedDate != null) {
//                   _purchaseDate.text =
//                       pickedDate.toIso8601String().split('T').first;
//                 }
//               },
//             ),
//             const SizedBox(height: 16),

//             /// **Submit Button**
//             MyButtons(
//               onPressed: () {
//                 String productCode = _productCode.text;
//                 String productName = _productName.text;
//                 String brand = _brand.text;
//                 String quantityStr = _purchaseQty.text;
//                 String purchasePriceStr = _purchasePrice.text;
//                 String sellingPriceStr = _sellingPrice.text;
//                 //   String otherExpensesStr = _otherExpenses.text;
//                 String purchasedDateStr = _purchaseDate.text;

//                 int quantity = int.tryParse(quantityStr) ?? 0;
//                 DateTime? purchasedDate = purchasedDateStr.isNotEmpty
//                     ? DateTime.tryParse(purchasedDateStr)
//                     : null;
//                 double purchasePrice = double.tryParse(purchasePriceStr) ?? 0.0;
//                 double sellingPrice = double.tryParse(sellingPriceStr) ?? 0.0;
//                 //double otherExpenses = double.tryParse(otherExpensesStr) ?? 0.0;

//                 Product newProduct = Product(
//                   productCode: productCode,
//                   productName: productName,
//                   purchasePrice: purchasePrice,
//                   purchasedDate: purchasedDate,
//                   purchasedQuantity: quantity,
//                   sellingPrice: sellingPrice,
//                   brand: brand,
//                   remainingQuantity: quantity,
//                   otherExpenses: 0.0,
//                 );

//                 ProductController().addProduct(newProduct, context);
//                 _productCode.clear();
//                 _productName.clear();
//                 _purchaseDate.clear();
//                 _purchaseQty.clear();
//                 _sellingPrice.clear();
//                 _purchasePrice.clear();
//                 _brand.clear();
//                 // _otherExpenses.clear();
//               },
//               text: 'Ajouter',
//             ),
//             FloatingActionButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => BaseLayout(
//                     initialIndex: 1,
//                     pages: [
//                       const Acceuil(),
//                       if (UsersController.userRole == 'ADMIN')
//                         const ProductsList(),
//                       if (UsersController.userRole == 'ADMIN')
//                         const UsersList(),
//                       const AddTransaction(),
//                     ],
//                     initialPage: RecordingList(product: productt),
//                   ),
//                 ),
//               ),
//               backgroundColor: chocolateColor,
//               child: const Row(
//                 children: [
//                   Text(
//                     'Liste ',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   const Icon(
//                     Icons.checklist,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseLayout(
//       initialIndex: 2,
//       pages: [
//         const Acceuil(),
//         const ProductsList(),
//         Stack(
//           children: [
//             Center(
//               child: Opacity(
//                 opacity: 0.5,
//                 child: Image.asset(
//                   'assets/logo.PNG',
//                   fit: BoxFit.contain,
//                   width: 250,
//                   height: 250,
//                 ),
//               ),
//             ),
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 if (constraints.maxWidth > tabletWidth) {
//                   return desktopBody();
//                 } else {
//                   return mobileBody();
//                 }
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/appbar_text.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/label.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/product_controller.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/dashboard/views/users_list.dart';
import 'package:le_coin_des_cuisiniers_app/models/products.dart';
import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';
import 'package:le_coin_des_cuisiniers_app/views/acceuil.dart';
import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/recording_list.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/add_transactions.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productCode = TextEditingController();
  final TextEditingController _purchasePrice = TextEditingController();
  final TextEditingController _sellingPrice = TextEditingController();
  final TextEditingController _purchaseQty = TextEditingController();
  final TextEditingController _purchaseDate = TextEditingController();
  final TextEditingController _brand = TextEditingController();

  bool isLoading = false;
  DateTime? _selectedDate;
  Product? productt;

  Widget desktopBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Text(
                'Complétez ici les informations du nouveau produit',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
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
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: _productCode,
                          enabled: true,
                          hintText: '',
                          obscureText: false,
                          prefixIcon: Icons.qr_code_2,
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                            padding: EdgeInsets.only(right: 240.0),
                            child: MyLabel(labelContent: 'Nom du produit')),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: _productName,
                          enabled: true,
                          hintText: '',
                          obscureText: false,
                          prefixIcon: Icons.circle,
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                            padding: EdgeInsets.only(right: 240.0),
                            child: MyLabel(labelContent: 'Marque')),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: _brand,
                          enabled: true,
                          hintText: '',
                          obscureText: false,
                          prefixIcon: Icons.circle,
                        ),
                        const SizedBox(height: 16),
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
                            child: MyLabel(labelContent: 'Prix d\'achat')),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: _purchasePrice,
                          enabled: true,
                          hintText: '',
                          obscureText: false,
                          prefixIcon: Icons.monetization_on,
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                            padding: EdgeInsets.only(right: 200.0),
                            child: MyLabel(labelContent: 'Prix de vente')),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: _sellingPrice,
                          enabled: true,
                          hintText: '',
                          obscureText: false,
                          prefixIcon: Icons.monetization_on,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 260.0),
                            child: MyLabel(labelContent: 'Quantité acheté')),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: _purchaseQty,
                          enabled: true,
                          hintText: '',
                          obscureText: false,
                          prefixIcon: Icons.numbers,
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                            padding: EdgeInsets.only(right: 200.0),
                            child: MyLabel(labelContent: 'Date d\'achat')),
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
                              borderSide:
                                  const BorderSide(color: chocolateColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            prefixIcon: const Icon(
                              Icons.calendar_today,
                              color: chocolateColor,
                            ),
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
                                      primary: chocolateColor,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                          foregroundColor: chocolateColor),
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: MyButtons(
                      onPressed: () {
                        String productCode = _productCode.text;
                        String productName = _productName.text;
                        String brand = _brand.text;
                        String quantityStr = _purchaseQty.text;
                        String purchasePriceStr = _purchasePrice.text;
                        String sellingPriceStr = _sellingPrice.text;
                        String purchasedDateStr = _purchaseDate.text;

                        int quantity = int.tryParse(quantityStr) ?? 0;
                        DateTime? purchasedDate = purchasedDateStr.isNotEmpty
                            ? DateTime.tryParse(purchasedDateStr)
                            : null;
                        double purchasePrice =
                            double.tryParse(purchasePriceStr) ?? 0.0;
                        double sellingPrice =
                            double.tryParse(sellingPriceStr) ?? 0.0;

                        Product newProduct = Product(
                          productCode: productCode,
                          productName: productName,
                          purchasePrice: purchasePrice,
                          purchasedDate: purchasedDate,
                          purchasedQuantity: quantity,
                          sellingPrice: sellingPrice,
                          brand: brand,
                          remainingQuantity: quantity,
                          otherExpenses: 0,
                        );

                        Provider.of<ProductController>(context, listen: false)
                            .addProductOnList(newProduct, context);
                        _productCode.clear();
                        _productName.clear();
                        _purchaseDate.clear();
                        _purchaseQty.clear();
                        _sellingPrice.clear();
                        _purchasePrice.clear();
                        _brand.clear();
                      },
                      text: 'Ajouter',
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BaseLayout(
                          initialIndex: 1,
                          pages: const [
                            Acceuil(),
                            //  if (UsersController.userRole == 'ADMIN')
                            ProductsList(),
                            //  if (UsersController.userRole == 'ADMIN')
                            UsersList(),
                            AddTransaction(),
                          ],
                          initialPage: RecordingList(product: productt),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: chocolateColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.checklist),
                    label: const Text('Voir la liste'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mobileBody() {
    return const Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text(
            //   'Complétez ici les informations du nouveau produit',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: Colors.grey),
            // ),
            const Text(
              'POUR ENREGISTRER UN NOUVEAU PRODUIT AGRANDISSEZ VOTRE NAVIGATEUR SVP!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            const Text(
              'CE PROBLEME SERA REGLE BIENTOT, MAIS VEUILLEZ COMPRENDRE POUR LE MOMENT',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            // const SizedBox(height: 20),
            // const MyLabel(labelContent: 'Code du produit'),
            // const SizedBox(height: 10),
            // MyTextField(
            //   controller: _productCode,
            //   enabled: true,
            //   hintText: '',
            //   obscureText: false,
            //   prefixIcon: Icons.qr_code_2,
            // ),
            // const SizedBox(height: 16),
            // const MyLabel(labelContent: 'Nom du produit'),
            // const SizedBox(height: 10),
            // MyTextField(
            //   controller: _productName,
            //   enabled: true,
            //   hintText: '',
            //   obscureText: false,
            //   prefixIcon: Icons.circle,
            // ),
            // const SizedBox(height: 16),
            // const MyLabel(labelContent: 'Marque'),
            // const SizedBox(height: 10),
            // MyTextField(
            //   controller: _brand,
            //   enabled: true,
            //   hintText: '',
            //   obscureText: false,
            //   prefixIcon: Icons.circle,
            // ),
            // const SizedBox(height: 16),
            // const MyLabel(labelContent: 'Prix d\'achat'),
            // const SizedBox(height: 10),
            // MyTextField(
            //   controller: _purchasePrice,
            //   enabled: true,
            //   hintText: '',
            //   obscureText: false,
            //   prefixIcon: Icons.monetization_on,
            // ),
            // const SizedBox(height: 16),
            // const MyLabel(labelContent: 'Prix de vente'),
            // const SizedBox(height: 10),
            // MyTextField(
            //   controller: _sellingPrice,
            //   enabled: true,
            //   hintText: '',
            //   obscureText: false,
            //   prefixIcon: Icons.monetization_on,
            // ),
            // const SizedBox(height: 16),
            // const MyLabel(labelContent: 'Quantité achetée'),
            // const SizedBox(height: 10),
            // MyTextField(
            //   controller: _purchaseQty,
            //   enabled: true,
            //   hintText: '',
            //   obscureText: false,
            //   prefixIcon: Icons.numbers,
            // ),
            // const SizedBox(height: 16),
            // const MyLabel(labelContent: 'Date d\'achat'),
            // const SizedBox(height: 10),
            // TextFormField(
            //   controller: _purchaseDate,
            //   cursorColor: Colors.grey,
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //       borderSide: const BorderSide(color: chocolateColor),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //       borderSide: const BorderSide(color: Colors.grey),
            //     ),
            //     prefixIcon:
            //         const Icon(Icons.calendar_today, color: chocolateColor),
            //   ),
            //   onTap: () async {
            //     DateTime? pickedDate = await showDatePicker(
            //       context: context,
            //       firstDate: DateTime(2024),
            //       lastDate: DateTime(2026),
            //       initialDate: DateTime.now(),
            //       builder: (context, child) {
            //         return Theme(
            //           data: Theme.of(context).copyWith(
            //             colorScheme: const ColorScheme.light(
            //               primary: chocolateColor,
            //               onPrimary: Colors.white,
            //               onSurface: Colors.black,
            //             ),
            //             textButtonTheme: TextButtonThemeData(
            //               style: TextButton.styleFrom(
            //                 foregroundColor: chocolateColor,
            //               ),
            //             ),
            //           ),
            //           child: child!,
            //         );
            //       },
            //     );

            //     if (pickedDate != null) {
            //       _purchaseDate.text =
            //           pickedDate.toIso8601String().split('T').first;
            //     }
            //   },
            // ),
            // const SizedBox(height: 30),
            // MyButtons(
            //   onPressed: () {
            //     String productCode = _productCode.text;
            //     String productName = _productName.text;
            //     String brand = _brand.text;
            //     String quantityStr = _purchaseQty.text;
            //     String purchasePriceStr = _purchasePrice.text;
            //     String sellingPriceStr = _sellingPrice.text;
            //     String purchasedDateStr = _purchaseDate.text;

            //     int quantity = int.tryParse(quantityStr) ?? 0;
            //     DateTime? purchasedDate = purchasedDateStr.isNotEmpty
            //         ? DateTime.tryParse(purchasedDateStr)
            //         : null;
            //     double purchasePrice = double.tryParse(purchasePriceStr) ?? 0.0;
            //     double sellingPrice = double.tryParse(sellingPriceStr) ?? 0.0;

            //     Product newProduct = Product(
            //       productCode: productCode,
            //       productName: productName,
            //       purchasePrice: purchasePrice,
            //       purchasedDate: purchasedDate,
            //       purchasedQuantity: quantity,
            //       sellingPrice: sellingPrice,
            //       brand: brand,
            //       remainingQuantity: quantity,
            //       otherExpenses: 0.0,
            //     );

            //     ProductController().addProductOnList(newProduct, context);
            //     _productCode.clear();
            //     _productName.clear();
            //     _purchaseDate.clear();
            //     _purchaseQty.clear();
            //     _sellingPrice.clear();
            //     _purchasePrice.clear();
            //     _brand.clear();
            //   },
            //   text: 'Ajouter',
            // ),
            // const SizedBox(height: 16),
            // SizedBox(
            //   width: double.infinity,
            //   child: OutlinedButton.icon(
            //     onPressed: () => Navigator.push(
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
            //           initialPage: RecordingList(product: productt),
            //         ),
            //       ),
            //     ),
            //     style: OutlinedButton.styleFrom(
            //       foregroundColor: chocolateColor,
            //       side: const BorderSide(color: chocolateColor, width: 2),
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     icon: const Icon(Icons.checklist),
            //     label: const Text('Voir la liste'),
            //   ),
            // ),
            // const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: chocolateColor,
        // automaticallyImplyLeading: false,
        title: const MyAppBarText(content: 'Le coin des cuisiniers'),
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/logo.PNG',
                fit: BoxFit.contain,
                width: 250,
                height: 250,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > tabletWidth) {
                return desktopBody();
              } else {
                return mobileBody();
              }
            },
          ),
        ],
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return BaseLayout(
//       initialIndex: 2,
//       pages: [
//         const Acceuil(),
//         const ProductsList(),
//         Stack(
//           children: [
//             Center(
//               child: Opacity(
//                 opacity: 0.5,
//                 child: Image.asset(
//                   'assets/logo.PNG',
//                   fit: BoxFit.contain,
//                   width: 250,
//                   height: 250,
//                 ),
//               ),
//             ),
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 if (constraints.maxWidth > tabletWidth) {
//                   return desktopBody();
//                 } else {
//                   return mobileBody();
//                 }
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
