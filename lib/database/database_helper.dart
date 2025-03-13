// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:le_coin_des_cuisiniers_app/components/snack_bar.dart';
// import 'package:le_coin_des_cuisiniers_app/models/product_restock_history.dart';
// import 'package:le_coin_des_cuisiniers_app/models/products.dart';
// import 'package:le_coin_des_cuisiniers_app/models/users.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('le_coin_des_cuisiniers.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     const idPKType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     const intType = 'INTEGER';
//     const textType = 'TEXT NOT NULL';

//     await db.execute('''
//     CREATE TABLE products (
//       id $idPKType,
//       product_code $textType,
//       product_name $textType,
//       purchase_price $intType,
//       other_expenses $intType,
//       selling_price $intType,
//       purchased_quantity $intType,
//       remaining_quantity $intType DEFAULT 0,
//       purchased_date $textType,
//       brand $textType

//     )
//     ''');

//     await db.execute('''
//     CREATE TABLE transactions(
//       transaction_Id $idPKType,
//       product_code $textType,
//       product_Id $intType,
//      quantity $intType,
//      bill_code $textType,
//      selling_date $textType,
//      total_price $intType,
//      FOREIGN KEY (product_Id ) REFERENCES products(id)
//     )
//     ''');
//     // await db.execute('ALTER table products ADD column other_expenses $intType');
//     // //await db.execute('ALTER table products DROP column other_expenses');
//     await db.execute('''
//     CREATE TABLE users (
//       id $idPKType,
//       full_name $textType,
//       phone_number $textType,
//       email $textType,
//       address $textType,
//       password $textType,
//       user_status $textType DEFAULT 'NON AUTORISE',
//       role $textType


//     );

//     ''');
//     // Create the trigger
//     await db.execute('''
//     CREATE TRIGGER IF NOT EXISTS decrease_product_quantity
//     BEFORE INSERT ON transactions
//     BEGIN
//         -- Check if stock is running low (<=3)
//         SELECT CASE
//             WHEN (SELECT remaining_quantity FROM products WHERE product_code = NEW.product_code) <= 3
//             THEN RAISE(ABORT, 'Le stock est presque epuisé')
//         END;

//         -- Check if requested quantity exceeds available stock
//         SELECT CASE
//             WHEN NEW.quantity > (SELECT remaining_quantity FROM products WHERE product_code = NEW.product_code)
//             THEN RAISE(ABORT, 'Le stock n''est pas suffisant')
//         END;

//         -- Update the remaining quantity
//         UPDATE products
//         SET remaining_quantity = remaining_quantity - NEW.quantity
//         WHERE product_code = NEW.product_code;
//     END;
//     ''');
//     await db.execute('''
// CREATE TABLE product_history (id INTEGER PRIMARY KEY AUTOINCREMENT, product_code TEXT, new_product_name TEXT,old_product_name TEXT, new_purchase_price TEXT, old_purchase_price TEXT, new_other_expenses TEXT, old_other_expenses TEXT,new_selling_price  INTEGER, old_selling_price  INTEGER,new_purchased_quantity INTEGER , old_purchased_quantity INTEGER , new_remaining_quantity INTEGER, old_remaining_quantity INTEGER,new_purchased_date TEXT, old_purchased_date TEXT, new_brand TEXT,old_brand TEXT);

// ''');
//     await db.execute('''
// CREATE TRIGGER IF NOT EXISTS  product_restock_history
// AFTER UPDATE ON products
// FOR EACH ROW
// WHEN NEW.purchased_date != OLD.purchased_date
// BEGIN
// INSERT INTO product_history (product_code ,new_product_name ,old_product_name ,new_purchase_price ,old_purchase_price ,new_other_expenses ,old_other_expenses ,new_selling_price  ,old_selling_price ,new_purchased_quantity , old_purchased_quantity , new_remaining_quantity ,old_remaining_quantity ,new_purchased_date ,old_purchased_date ,new_brand ,old_brand) VALUES (OLD.product_code,new.product_name ,old.product_name ,new.purchase_price ,old.purchase_price ,new.other_expenses ,old.other_expenses ,new.selling_price  ,old.selling_price ,new.purchased_quantity , old.purchased_quantity , new.remaining_quantity ,old.remaining_quantity ,new.purchased_date ,old.purchased_date ,new.brand ,old.brand );
// END;
// ''');
//     await db.execute('''
// CREATE TABLE sync_tracker_for_firebase (
//     table_name TEXT,
//     record_id INTEGER,
//     operation TEXT,  
//     sync_status INTEGER DEFAULT 0,
//     timestamp TEXT DEFAULT CURRENT_TIMESTAMP
// );
// ''');
//     await db.execute('''
// CREATE TABLE sync_tracker (
//     table_name TEXT,
//     record_id INTEGER,
//     operation TEXT,  
//     sync_status INTEGER DEFAULT 0,
//     timestamp TEXT DEFAULT CURRENT_TIMESTAMP
// );

// ------------------PRODUCT--------------------------
// -- Trigger for INSERT operations
// CREATE TRIGGER track_product_insert 
// AFTER INSERT ON products
// BEGIN
//     INSERT INTO sync_tracker (table_name, record_id, operation)
//     VALUES ('products', NEW.id, 'INSERT');
//     INSERT INTO sync_tracker_for_firebase (table_name, record_id, operation)
//     VALUES ('products', NEW.id, 'INSERT');
// END;


// -- Trigger for UPDATE operations
// CREATE TRIGGER track_product_update 
// AFTER UPDATE ON products
// BEGIN 
//     INSERT INTO sync_tracker (table_name, record_id, operation)
//     VALUES ('products', NEW.id, 'UPDATE');
//     INSERT INTO sync_tracker_for_firebase (table_name, record_id, operation)
//     VALUES ('products', NEW.id, 'UPDATE');
// END;

// -- Trigger for DELETE operations
// CREATE TRIGGER track_product_delete 
// AFTER DELETE ON products
// BEGIN 
//     INSERT INTO sync_tracker (table_name, record_id, operation)
//     VALUES ('products', OLD.id, 'DELETE');
//     INSERT INTO sync_tracker_for_firebase (table_name, record_id, operation)
//     VALUES ('products', OLD.id, 'DELETE');
// END;
// ----------PRODUCT HISTORY--------------
// CREATE TRIGGER track_product_history_insert 
// AFTER INSERT ON product_history
// BEGIN 
//     INSERT INTO sync_tracker (table_name, record_id, operation)
//     VALUES ('product_history', NEW.id, 'INSERT');
//     INSERT INTO sync_tracker_for_firebase (table_name, record_id, operation)
//     VALUES ('product_history', NEW.id, 'INSERT');
// END;

// ------------------USERS------------------
// -- Trigger for INSERT operations
// CREATE TRIGGER track_user_insert 
// AFTER INSERT ON users
// BEGIN 
//     INSERT INTO sync_tracker (table_name, record_id, operation)
//     VALUES ('users', NEW.id, 'INSERT');
//     INSERT INTO sync_tracker_for_firebase (table_name, record_id, operation)
//     VALUES ('users', NEW.id, 'INSERT');
// END;

// -- Trigger for UPDATE operations
// CREATE TRIGGER track_user_update 
// AFTER UPDATE ON users
// BEGIN 
//     INSERT INTO sync_tracker (table_name, record_id, operation)
//     VALUES ('users', NEW.id, 'UPDATE');
//     INSERT INTO sync_tracker_for_firebase (table_name, record_id, operation)
//     VALUES ('users', NEW.id, 'UPDATE');
// END;

// -- Trigger for DELETE operations
// CREATE TRIGGER track_user_delete 
// AFTER DELETE ON users
// BEGIN 
//     INSERT INTO sync_tracker (table_name, record_id, operation)
//     VALUES ('users', OLD.id, 'DELETE');
//     INSERT INTO sync_tracker_for_firebase (table_name, record_id, operation)
//     VALUES ('users', OLD.id, 'DELETE');
// END;
// ----------------------TRANSACTIONS-------------------------

// CREATE TRIGGER track_transactions_insert 
// AFTER INSERT ON transactions
// BEGIN 
//     INSERT INTO sync_tracker (table_name, record_id, operation)
//     VALUES ('transactions', NEW.transaction_Id, 'INSERT');
//     INSERT INTO sync_tracker_for_firebase (table_name, record_id, operation)
//     VALUES ('transactions', NEW.transaction_Id, 'INSERT');
// END;
// ----------ADMIN DEFAULT CREDENTIALS AND SECURITY---------------
//  INSERT INTO users values(1,'admin','0972931280','lecoindescuisinier@gmail.com','Goma','12345','AUTORISE','ADMIN');

// CREATE TRIGGER secure_admin_update
// BEFORE UPDATE ON users
// BEGIN
//     SELECT CASE 
//         WHEN NEW.user_status != 'AUTORISE' AND NEW.role = 'ADMIN' 
//         THEN RAISE(FAIL, 'L'' admin doit toujours etre autorisé')
//     END;
// END;

// CREATE TRIGGER secure_admin_delete
// BEFORE DELETE ON users
// BEGIN
//     SELECT CASE 
//         WHEN OLD.role = 'ADMIN'
//         THEN RAISE(FAIL, 'L'' admin ne peut pas etre supprimé')
//     END;
// END;
// ''');
//     await db.execute('PRAGMA foreign_keys = ON');
//   }

//   Future<void> close() async {
//     final db = await instance.database;
//     db.close();
//   }

//   ///////////////////////////////////////////// Product-related operations//////////////////////////////////////////////////
// // Insert a new product into the database
//   Future<int> addProductToDB(Product product, BuildContext context) async {
//     try {
//       final db = await instance.database;
//       print('Product created');
//       MySnackBar.showSuccessMessage('Produit ajouté', context);
//       return await db.insert('products', product.toJson());
//     } on Exception catch (e) {
//       print(e);
//       MySnackBar.showSuccessMessage('L\'ajout a refusé', context);
//       return 0;
//       // TODO
//     }
//   }

//   // Read all products from the database
//   Future<List<Product>> readAllProducts(BuildContext context) async {
//     final db = await instance.database;
//     try {
//       final result = await db.query(
//         'products',
//         orderBy: 'product_name ASC',
//       );

//       return result.map((json) => Product.fromJson(json)).toList();
//     } on Exception catch (e) {
//       print(e);

//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite en voulant afficher la liste des produits',
//           context);
//       return [];
//     }
//   }

//   // Read a single product by Code
//   Future<Product?> readProductInformation(
//       String prodCode, BuildContext context) async {
//     try {
//       final db = await instance.database;
//       final result = await db.query(
//         'products',
//         columns: [
//           'product_code',
//           'product_name',
//           'purchase_price',
//           'other_expenses',
//           'selling_price',
//           'purchased_quantity',
//           'remaining_quantity',
//           'purchased_date',
//           'brand'
//         ],
//         where: 'product_code = ?',
//         whereArgs: [prodCode],
//       );

//       if (result.isNotEmpty) {
//         return Product.fromJson(result.first);
//       } else {
//         return null;
//       }
//     } on Exception catch (e) {
//       print(e);
//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite en voulant afficher les informations du produit',
//           context);
//     }
//     return null;
//   }

//   Future<void> updateProductData(Product product, BuildContext context) async {
//     try {
//       final Database db = await database;

//       String formattedDate =
//           DateFormat('yyyy-MM-dd').format(product.purchasedDate!);

//       await db.update(
//         'products',
//         {
//           'product_code': product.productCode,
//           'product_name': product.productName,
//           'purchase_price': product.purchasePrice,
//           'purchased_quantity': product.purchasedQuantity,
//           'purchased_date': formattedDate,
//           'selling_price': product.sellingPrice,
//           'brand': product.brand,
//           'remaining_quantity': product.remainingQuantity,
//           'other_expenses': product.otherExpenses,
//         },
//         where: 'product_code = ?',
//         whereArgs: [product.productCode],
//       );
//       MySnackBar.checked(const Icon(Icons.check), context);
//       // MySnackBar.showSuccessMessage('Modification effectuée', context);
//     } catch (e) {
//       print('Erreur lors de la mise à jour: ${e.toString()}');
//       MySnackBar.showErrorMessage('Erreur lors de la mise à jour', context);
//       rethrow;
//     }
//   }

  // Future<void> restocProduct(Product product, BuildContext context) async {
  //   try {
  //     final Database db = await database;

  //     String formattedDate =
  //         DateFormat('yyyy-MM-dd').format(product.purchasedDate!);

  //     await db.update(
  //       'products',
  //       {
  //         'product_code': product.productCode,
  //         'product_name': product.productName,
  //         'purchase_price': product.purchasePrice,
  //         'purchased_quantity': product.purchasedQuantity,
  //         'purchased_date': formattedDate,
  //         'selling_price': product.sellingPrice,
  //         'brand': product.brand,
  //         'remaining_quantity': product.remainingQuantity,
  //         'other_expenses': product.otherExpenses,
  //       },
  //       where: 'product_code = ?',
  //       whereArgs: [product.productCode],
  //     );
  //     MySnackBar.checked(const Icon(Icons.check), context);
  //     // MySnackBar.showSuccessMessage('Modification effectuée', context);
  //   } catch (e) {
  //     MySnackBar.showErrorMessage(
  //         'Erreur lors de la mise à jour: ${e.toString()}', context);
  //     rethrow;
  //   }
  // }

//   Future<int> deleteProductFromDB(String prodCode, BuildContext context) async {
//     try {
//       final db = await instance.database;
//       MySnackBar.showErrorMessage('Suppression réussie', context);
//       return await db.delete(
//         'products',
//         where: 'product_code = ?',
//         whereArgs: [prodCode],
//       );
//     } on Exception catch (e) {
//       print(e);
//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite en voulant supprimer le produit',
//           context);
//       return 0;
//     }
//   }

//   /////////////////////////////////////////////////Product Restock History/////////////////////////////////////////
//   Future<List<ProductRestockHistoryModel>> loadHistoryData(
//       String productCode, BuildContext context) async {
//     final db = await instance.database;
//     try {
//       final records = await db.rawQuery('''
//         SELECT * FROM product_history 
//         WHERE product_code = ? 
//         ORDER BY new_purchased_date DESC
//       ''', [productCode]);

//       return records
//           .map((json) => ProductRestockHistoryModel.fromJson(json))
//           .toList();
//     } on Exception catch (e) {
//       print('Error loading history: $e');

//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite en voulant afficher l\'historique du ravitallement du produit',
//           context);
//       return [];
//     }
//   }

//   //////////////////////////////////======USER RELATED OPERATIONS ========\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   Future<int> addUserToDB(User user, BuildContext context) async {
//     try {
//       final db = await instance.database;
//       MySnackBar.showSuccessMessage('Utilisateur ajouté', context);
//       return await db.insert('users', user.toJson());
//     } on Exception catch (e) {
//       print(e);
//       MySnackBar.showErrorMessage(
//           'L\'ajout de l\'utilisateur a échoué', context);
//       return 0;
//     }
//   }

//   // Read all users
//   Future<List<User>> readAllUsers(BuildContext context) async {
//     final db = await instance.database;
//     try {
//       final result = await db.query('users');
//       return result.map((json) => User.fromJson(json)).toList();
//     } on Exception catch (e) {
//       print(e);
//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite en voulant afficher la liste des utilisateurs',
//           context);
//       return [];
//     }
//   }

//   // Read a single user by ID
//   Future<User?> readUserInformation(int userId, BuildContext context) async {
//     try {
//       final db = await instance.database;
//       final result = await db.query(
//         'users',
//         where: 'id = ?',
//         whereArgs: [userId],
//       );

//       if (result.isNotEmpty) {
//         return User.fromJson(result.first);
//       } else {
//         return null;
//       }
//     } on Exception catch (e) {
//       print(e);
//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite en voulant afficher les informations de l\'utilisateur',
//           context);
//     }
//     return null;
//   }

//   // Update user data
//   Future<void> updateUserData(User user, BuildContext context) async {
//     try {
//       final Database db = await database;

//       await db.update(
//         'users',
//         {
//           'full_name': user.fullName,
//           'phone_number': user.phoneNumber,
//           'email': user.email,
//           'address': user.address,
//           'password': user.password,
//           'user_status': user.userStatus,
//         },
//         where: 'id = ?',
//         whereArgs: [user.id],
//       );
//       MySnackBar.checked(const Icon(Icons.check), context);
//     } catch (e) {
//       if (e.toString().contains('L\' admin doit toujours etre autorisé')) {
//         MySnackBar.showErrorMessage(
//             'L\' admin doit toujours etre autorisé', context);
//       } else if (e.toString().contains('admin ne peut pas etre supprimé')) {
//         MySnackBar.showErrorMessage(
//             'L\' admin ne peut pas etre supprimé', context);
//       } else {
//         print('Erreur lors de la mise à jour: ${e.toString()}');
//         MySnackBar.showErrorMessage(
//             'Erreur lors de la mise à jour de l\'utilisateur', context);
//         rethrow;
//       }
//     }
//   }

//   // Delete a user
//   Future<int> deleteUserFromDB(int userId, BuildContext context) async {
//     try {
//       final db = await instance.database;
//       MySnackBar.showSuccessMessage(
//           'Suppression de l\'utilisateur réussie', context);
//       return await db.delete(
//         'users',
//         where: 'id = ?',
//         whereArgs: [userId],
//       );
//     } on Exception catch (e) {
//       print(e);
//       MySnackBar.showErrorMessage(
//           'Une erreur s\'est produite en voulant supprimer l\'utilisateur',
//           context);
//       return 0;
//     }
//   }

//   //////////////=====  LOGIN =============\\\\\\\\\\\\\
//   Future<User?> authenticateUser(
//       String phoneNumber, String password, BuildContext context) async {
//     final db = await instance.database;
//     try {
//       final result = await db.query(
//         'users',
//         where: 'phone_number = ? AND password = ?',
//         whereArgs: [phoneNumber, password],
//       );

//       if (result.isNotEmpty) {
//         User user = User.fromJson(result.first);

//         // return user.userStatus == 'AUTORISE' ? user : null;
//         if (user.userStatus == 'AUTORISE') {
//           return user;
//         } else if (user.userStatus == 'NON AUTORISE') {
//           MySnackBar.showErrorMessage(
//               'Tu n\'es pas autorié d\'acceder au logiciel pour le moment',
//               context);
//           return null;
//         } else {
//           return null;
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Authentication error: $e');
//       return null;
//     }
//   }
// }
