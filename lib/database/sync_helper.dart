// import 'package:le_coin_des_cuisiniers_app/database/database_helper.dart';
// import 'package:mysql_client/mysql_client.dart';

// class SyncHelper {
//   static final SyncHelper instance = SyncHelper._init();
//   final DatabaseHelper dbHelper;
//   late MySQLConnection mysqlConn;

//   SyncHelper._init() : dbHelper = DatabaseHelper.instance;

//   Future<void> initMySQLConnection() async {
//     mysqlConn = await MySQLConnection.createConnection(
//       host: 'mysql-pierrekasanani.alwaysdata.net',
//       port: 3306,
//       userName: '375592',
//       password: 'Kasa2002@',
//       databaseName: 'pierrekasanani_coin_des_cuisiniers',
//       secure: true,
//     );
//     await mysqlConn.connect();
//   }

//   Future<void> syncData() async {
//     final db = await dbHelper.database;
//     await initMySQLConnection();

//     try {
//       final unsyncedRecords = await db.query('sync_tracker',
//           where: 'sync_status = ?', whereArgs: [0], orderBy: 'timestamp ASC');

//       for (var record in unsyncedRecords) {
//         try {
//           switch (record['table_name']) {
//             case 'products':
//               await syncProductRecord(db, record);
//               break;
//             case 'transactions':
//               await syncTransactionRecord(db, record);
//               break;
//             case 'product_history':
//               await syncProductHistoryRecord(db, record);
//               break;
//             case 'users':
//               await syncUsersRecord(db, record);
//               break;
//           }

//           // Mark as synced
//           await db.update('sync_tracker', {'sync_status': 1},
//               where: 'record_id = ? AND table_name = ?',
//               whereArgs: [record['record_id'], record['table_name']]);
//         } catch (e) {
//           print('Error processing record ${record['record_id']}: $e');
//           rethrow;
//         }
//       }
//     } finally {
//       await mysqlConn.close();
//     }
//   }

//   Future<void> syncProductRecord(dynamic db, dynamic record) async {
//     final productData = await db
//         .query('products', where: 'id = ?', whereArgs: [record['record_id']]);

//     if (productData.isEmpty && record['operation'] != 'DELETE') {
//       print('No product found for id: ${record['record_id']}');
//       return;
//     }

//     final productRecExists = await mysqlConn.execute(
//         "SELECT id FROM products WHERE id = :id", {"id": record['record_id']});
//     final productRecordExists = productRecExists.rows.isNotEmpty;

//     switch (record['operation']) {
//       case 'INSERT':
//         if (!productRecordExists) {
//           await mysqlConn.execute(
//               "INSERT INTO products VALUES (:id, :code, :name, :price, :expenses, :selling, :quantity, :remaining, :date, :brand)",
//               {
//                 "id": productData[0]['id'],
//                 "code": productData[0]['product_code'],
//                 "name": productData[0]['product_name'],
//                 "price": productData[0]['purchase_price'],
//                 "expenses": productData[0]['other_expenses'],
//                 "selling": productData[0]['selling_price'],
//                 "quantity": productData[0]['purchased_quantity'],
//                 "remaining": productData[0]['remaining_quantity'],
//                 "date": productData[0]['purchased_date'],
//                 "brand": productData[0]['brand']
//               });
//         } else {
//           await mysqlConn.execute("""
//             UPDATE products 
//             SET product_code = :code,
//                 product_name = :name,
//                 purchase_price = :price,
//                 other_expenses = :expenses,
//                 selling_price = :selling,
//                 purchased_quantity = :quantity,
//                 remaining_quantity = :remaining,
//                 purchased_date = :date,
//                 brand = :brand
//             WHERE id = :id""", {
//             "id": productData[0]['id'],
//             "code": productData[0]['product_code'],
//             "name": productData[0]['product_name'],
//             "price": productData[0]['purchase_price'],
//             "expenses": productData[0]['other_expenses'],
//             "selling": productData[0]['selling_price'],
//             "quantity": productData[0]['purchased_quantity'],
//             "remaining": productData[0]['remaining_quantity'],
//             "date": productData[0]['purchased_date'],
//             "brand": productData[0]['brand']
//           });
//         }
//         break;

//       case 'UPDATE':
//         if (productRecordExists) {
//           await mysqlConn.execute("""
//             UPDATE products 
//             SET product_code = :code,
//                 product_name = :name,
//                 purchase_price = :price,
//                 other_expenses = :expenses,
//                 selling_price = :selling,
//                 purchased_quantity = :quantity,
//                 remaining_quantity = :remaining,
//                 purchased_date = :date,
//                 brand = :brand
//             WHERE id = :id""", {
//             "id": productData[0]['id'],
//             "code": productData[0]['product_code'],
//             "name": productData[0]['product_name'],
//             "price": productData[0]['purchase_price'],
//             "expenses": productData[0]['other_expenses'],
//             "selling": productData[0]['selling_price'],
//             "quantity": productData[0]['purchased_quantity'],
//             "remaining": productData[0]['remaining_quantity'],
//             "date": productData[0]['purchased_date'],
//             "brand": productData[0]['brand']
//           });
//         } else {
//           await mysqlConn.execute(
//               "INSERT INTO products VALUES (:id, :code, :name, :price, :expenses, :selling, :quantity, :remaining, :date, :brand)",
//               {
//                 "id": productData[0]['id'],
//                 "code": productData[0]['product_code'],
//                 "name": productData[0]['product_name'],
//                 "price": productData[0]['purchase_price'],
//                 "expenses": productData[0]['other_expenses'],
//                 "selling": productData[0]['selling_price'],
//                 "quantity": productData[0]['purchased_quantity'],
//                 "remaining": productData[0]['remaining_quantity'],
//                 "date": productData[0]['purchased_date'],
//                 "brand": productData[0]['brand']
//               });
//         }
//         break;

//       case 'DELETE':
//         if (productRecordExists) {
//           await mysqlConn.execute("DELETE FROM products WHERE id = :id",
//               {"id": record['record_id']});
//         }
//         break;
//     }
//   }

//   Future<void> syncTransactionRecord(dynamic db, dynamic record) async {
//     final transactionData = await db.query('transactions',
//         where: 'transaction_Id = ?', whereArgs: [record['record_id']]);

//     if (transactionData.isEmpty) {
//       print('No transaction found for id: ${record['record_id']}');
//       return;
//     }

//     final productId =
//         transactionData[0]['product_Id']; // Note the space after Id
//     final productData =
//         await db.query('products', where: 'id = ?', whereArgs: [productId]);

//     if (productData.isEmpty) {
//       print('No product found for transaction id: ${record['record_id']}');
//       return;
//     }

//     final transactionRecExists = await mysqlConn.execute(
//         "SELECT transaction_Id FROM transactions WHERE transaction_Id = :id",
//         {"id": record['record_id']});
//     final transactionRecordExists = transactionRecExists.rows.isNotEmpty;

//     switch (record['operation']) {
//       case 'INSERT':
//         if (!transactionRecordExists) {
//           await mysqlConn.execute(
//               "INSERT INTO transactions VALUES (:id, :pr_code, :pr_id, :quantity, :bill_code, :date, :total_price)",
//               {
//                 "id": transactionData[0]['transaction_Id'],
//                 "pr_code": transactionData[0]['product_code'],
//                 "pr_id": productId,
//                 "quantity": transactionData[0]['quantity'],
//                 "bill_code": transactionData[0]['bill_code'],
//                 "date": transactionData[0]['selling_date'],
//                 "total_price": transactionData[0]['total_price']
//               });
//         }
//         break;
//     }
//   }

//   Future<void> syncProductHistoryRecord(dynamic db, dynamic record) async {
//     final productHistoryData = await db.query('product_history',
//         where: 'id = ?', whereArgs: [record['record_id']]);

//     if (productHistoryData.isEmpty && record['operation'] != 'DELETE') {
//       print('No history found for id: ${record['record_id']}');
//       return;
//     }

//     final productHistoryRecExists = await mysqlConn.execute(
//         "SELECT id FROM product_history WHERE id = :id",
//         {"id": record['record_id']});
//     final productHistoryRecordExists = productHistoryRecExists.rows.isNotEmpty;
//     switch (record['operation']) {
//       case 'INSERT':
//         if (!productHistoryRecordExists) {
//           await mysqlConn.execute(
//               "INSERT INTO product_history VALUES (:id, :product_code, :new_product_name, :old_product_name, :new_purchase_price, :old_purchase_price, :new_other_expenses, :old_other_expenses, :new_selling_price, :old_selling_price, :new_purchased_quantity, :old_purchased_quantity, :new_remaining_quantity, :old_remaining_quantity, :new_purchased_date, :old_purchased_date, :new_brand, :old_brand)",
//               {
//                 "id": productHistoryData[0]['id'],
//                 "product_code": productHistoryData[0]['product_code'],
//                 "new_product_name": productHistoryData[0]['new_product_name'],
//                 "old_product_name": productHistoryData[0]['old_product_name'],
//                 "new_purchase_price": productHistoryData[0]
//                     ['new_purchase_price'],
//                 "old_purchase_price": productHistoryData[0]
//                     ['old_purchase_price'],
//                 "new_other_expenses": productHistoryData[0]
//                     ['new_other_expenses'],
//                 "old_other_expenses": productHistoryData[0]
//                     ['old_other_expenses'],
//                 "new_selling_price": productHistoryData[0]['new_selling_price'],
//                 "old_selling_price": productHistoryData[0]['old_selling_price'],
//                 "new_purchased_quantity": productHistoryData[0]
//                     ['new_purchased_quantity'],
//                 "old_purchased_quantity": productHistoryData[0]
//                     ['old_purchased_quantity'],
//                 "new_remaining_quantity": productHistoryData[0]
//                     ['new_remaining_quantity'],
//                 "old_remaining_quantity": productHistoryData[0]
//                     ['old_remaining_quantity'],
//                 "new_purchased_date": productHistoryData[0]
//                     ['new_purchased_date'],
//                 "old_purchased_date": productHistoryData[0]
//                     ['old_purchased_date'],
//                 "new_brand": productHistoryData[0]['new_brand'],
//                 "old_brand": productHistoryData[0]['old_brand'],
//               });
//         }
//         break;
//     }
//   }

//   Future<void> syncUsersRecord(dynamic db, dynamic record) async {
//     final userData = await db
//         .query('users', where: 'id = ?', whereArgs: [record['record_id']]);

//     if (userData.isEmpty && record['operation'] != 'DELETE') {
//       print('No user found for id: ${record['record_id']}');
//       return;
//     }

//     final userRecExists = await mysqlConn.execute(
//         "SELECT id FROM users WHERE id = :id", {"id": record['record_id']});
//     final userRecordExists = userRecExists.rows.isNotEmpty;

//     switch (record['operation']) {
//       case 'INSERT':
//         if (!userRecordExists) {
//           await mysqlConn.execute(
//               "INSERT INTO users (id, full_name, phone_number, email, address, password, user_status, role) VALUES (:id, :full_name, :phone_number, :email, :address, :password, :user_status, :role)",
//               {
//                 "id": userData[0]['id'],
//                 "full_name": userData[0]['full_name'],
//                 "phone_number": userData[0]['phone_number'],
//                 "email": userData[0]['email'],
//                 "address": userData[0]['address'],
//                 "password": userData[0]['password'],
//                 "user_status": userData[0]['user_status'],
//                 "role": userData[0]['role']
//               });
//         } else {
//           await mysqlConn.execute("""
//           UPDATE users 
//           SET full_name = :full_name, 
//               phone_number = :phone_number, 
//               email = :email, 
//               address = :address, 
//               password = :password, 
//               user_status = :user_status, 
//               role = :role 
//           WHERE id = :id""", {
//             "id": userData[0]['id'],
//             "full_name": userData[0]['full_name'],
//             "phone_number": userData[0]['phone_number'],
//             "email": userData[0]['email'],
//             "address": userData[0]['address'],
//             "password": userData[0]['password'],
//             "user_status": userData[0]['user_status'],
//             "role": userData[0]['role']
//           });
//         }
//         break;

//       case 'UPDATE':
//         if (userRecordExists) {
//           await mysqlConn.execute("""
//           UPDATE users 
//           SET full_name = :full_name, 
//               phone_number = :phone_number, 
//               email = :email, 
//               address = :address, 
//               password = :password, 
//               user_status = :user_status, 
//               role = :role 
//           WHERE id = :id""", {
//             "id": userData[0]['id'],
//             "full_name": userData[0]['full_name'],
//             "phone_number": userData[0]['phone_number'],
//             "email": userData[0]['email'],
//             "address": userData[0]['address'],
//             "password": userData[0]['password'],
//             "user_status": userData[0]['user_status'],
//             "role": userData[0]['role']
//           });
//         } else {
//           await mysqlConn.execute(
//               "INSERT INTO users (id, full_name, phone_number, email, address, password, user_status, role) VALUES (:id, :full_name, :phone_number, :email, :address, :password, :user_status, :role)",
//               {
//                 "id": userData[0]['id'],
//                 "full_name": userData[0]['full_name'],
//                 "phone_number": userData[0]['phone_number'],
//                 "email": userData[0]['email'],
//                 "address": userData[0]['address'],
//                 "password": userData[0]['password'],
//                 "user_status": userData[0]['user_status'],
//                 "role": userData[0]['role']
//               });
//         }
//         break;

//       case 'DELETE':
//         if (userRecordExists) {
//           await mysqlConn.execute(
//               "DELETE FROM users WHERE id = :id", {"id": record['record_id']});
//         }
//         break;
//     }
//   }
// }
