// import 'package:flutter/material.dart';
// import 'package:rassasy_new/test/local_db/data.dart';
// import 'package:sqflite/sqflite.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Database database = await initDatabase();
//
//   runApp(MyApp(database: database));
// }
//
// class MyApp extends StatelessWidget {
//   final Database database;
//
//   MyApp({required this.database});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(database: database),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   final Database database;
//
//   MyHomePage({required this.database});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sqflite Example'),
//       ),
//       body: Center(
//         child: FutureBuilder(
//           future: database.query('Test'),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
//               return ListView.builder(
//                 itemCount: data.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(data[index]['name']),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
