// import 'package:firedart/firedart.dart';
// import 'package:le_coin_des_cuisiniers_app/database/database_helper.dart';

// class FirestoreSyncHelper {
//   static final FirestoreSyncHelper instance = FirestoreSyncHelper._init();
//   final DatabaseHelper dbHelper;
//   late final Firestore firestore;

//   FirestoreSyncHelper._init() : dbHelper = DatabaseHelper.instance {
//     Firestore.initialize('le-coin-des-cuisiniers');
//   }

//   Future<void> syncData() async {
//     final db = await dbHelper.database;

//     try {
//       final unsyncedRecords = await db.query('sync_tracker_for_firebase',
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
//           await db.update('sync_tracker_for_firebase', {'sync_status': 1},
//               where: 'record_id = ? AND table_name = ?',
//               whereArgs: [record['record_id'], record['table_name']]);
//         } catch (e) {
//           print('Error processing record ${record['record_id']}: $e');
//           rethrow;
//         }
//       }
//     } catch (e) {
//       print('Error during sync: $e');
//       rethrow;
//     }
//   }

//   Future<void> syncProductRecord(dynamic db, dynamic record) async {
//     final productData = await db
//         .query('products', where: 'id = ?', whereArgs: [record['record_id']]);

//     if (productData.isEmpty && record['operation'] != 'DELETE') {
//       print('No product found for id: ${record['record_id']}');
//       return;
//     }

//     final collection = Firestore.instance.collection('products');

//     switch (record['operation']) {
//       case 'INSERT':
//       case 'UPDATE':
//         if (productData.isNotEmpty) {
//           await collection.document(record['record_id'].toString()).set({
//             'id': productData[0]['id'],
//             'product_code': productData[0]['product_code'],
//             'product_name': productData[0]['product_name'],
//             'purchase_price': productData[0]['purchase_price'],
//             'other_expenses': productData[0]['other_expenses'],
//             'selling_price': productData[0]['selling_price'],
//             'purchased_quantity': productData[0]['purchased_quantity'],
//             'remaining_quantity': productData[0]['remaining_quantity'],
//             'purchased_date': productData[0]['purchased_date'],
//             'brand': productData[0]['brand'],
//             'last_updated': DateTime.now().toIso8601String(),
//           });
//         }
//         break;

//       case 'DELETE':
//         await collection.document(record['record_id'].toString()).delete();
//         break;
//     }
//   }

//   Future<void> syncTransactionRecord(dynamic db, dynamic record) async {
//     final transactionData = await db.query('transactions',
//         where: 'transaction_Id = ?', whereArgs: [record['record_id']]);

//     if (transactionData.isEmpty && record['operation'] != 'DELETE') {
//       print('No transaction found for id: ${record['record_id']}');
//       return;
//     }

//     final collection = Firestore.instance.collection('transactions');

//     switch (record['operation']) {
//       case 'INSERT':
//       case 'UPDATE':
//         if (transactionData.isNotEmpty) {
//           await collection.document(record['record_id'].toString()).set({
//             'transaction_Id': transactionData[0]['transaction_Id'],
//             'product_code': transactionData[0]['product_code'],
//             'product_Id': transactionData[0]['product_Id'],
//             'quantity': transactionData[0]['quantity'],
//             'bill_code': transactionData[0]['bill_code'],
//             'selling_date': transactionData[0]['selling_date'],
//             'total_price': transactionData[0]['total_price'],
//             'timestamp': DateTime.now().toIso8601String(),
//           });
//         }
//         break;

//       case 'DELETE':
//         await collection.document(record['record_id'].toString()).delete();
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

//     final collection = Firestore.instance.collection('product_history');

//     switch (record['operation']) {
//       case 'INSERT':
//       case 'UPDATE':
//         if (productHistoryData.isNotEmpty) {
//           await collection.document(record['record_id'].toString()).set({
//             'id': productHistoryData[0]['id'],
//             'product_code': productHistoryData[0]['product_code'],
//             'new_product_name': productHistoryData[0]['new_product_name'],
//             'old_product_name': productHistoryData[0]['old_product_name'],
//             'new_purchase_price': productHistoryData[0]['new_purchase_price'],
//             'old_purchase_price': productHistoryData[0]['old_purchase_price'],
//             'new_other_expenses': productHistoryData[0]['new_other_expenses'],
//             'old_other_expenses': productHistoryData[0]['old_other_expenses'],
//             'new_selling_price': productHistoryData[0]['new_selling_price'],
//             'old_selling_price': productHistoryData[0]['old_selling_price'],
//             'new_purchased_quantity': productHistoryData[0]
//                 ['new_purchased_quantity'],
//             'old_purchased_quantity': productHistoryData[0]
//                 ['old_purchased_quantity'],
//             'new_remaining_quantity': productHistoryData[0]
//                 ['new_remaining_quantity'],
//             'old_remaining_quantity': productHistoryData[0]
//                 ['old_remaining_quantity'],
//             'new_purchased_date': productHistoryData[0]['new_purchased_date'],
//             'old_purchased_date': productHistoryData[0]['old_purchased_date'],
//             'new_brand': productHistoryData[0]['new_brand'],
//             'old_brand': productHistoryData[0]['old_brand'],
//             'timestamp': DateTime.now().toIso8601String(),
//           });
//         }
//         break;

//       case 'DELETE':
//         await collection.document(record['record_id'].toString()).delete();
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

//     final collection = Firestore.instance.collection('users');

//     switch (record['operation']) {
//       case 'INSERT':
//       case 'UPDATE':
//         if (userData.isNotEmpty) {
//           await collection.document(record['record_id'].toString()).set({
//             'id': userData[0]['id'],
//             'full_name': userData[0]['full_name'],
//             'phone_number': userData[0]['phone_number'],
//             'email': userData[0]['email'],
//             'address': userData[0]['address'],
//             'password': userData[0]['password'],
//             'user_status': userData[0]['user_status'],
//             'role': userData[0]['role'],
//             'last_updated': DateTime.now().toIso8601String(),
//           });
//         }
//         break;

//       case 'DELETE':
//         await collection.document(record['record_id'].toString()).delete();
//         break;
//     }
//   }
// }
