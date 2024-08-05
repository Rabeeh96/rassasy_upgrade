// import 'package:flutter/foundation.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:path/path.dart';
//
// Future<Database> initDatabase() async {
//   if (kIsWeb) {
//     throw UnsupportedError('Web platform is not supported');
//   }
//
//   if (defaultTargetPlatform == TargetPlatform.windows ||
//       defaultTargetPlatform == TargetPlatform.linux ||
//       defaultTargetPlatform == TargetPlatform.macOS) {
//     sqfliteFfiInit();
//     databaseFactory = databaseFactoryFfi;
//   }
//
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'rassasy.db');
//
//   // Open/create the database at a given path
//   Database database = await openDatabase(path, version: 1, onCreate: (db, version) async {
//     await db.execute(
//       'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)',
//     );
//   });
//
//   return database;
// }
