// import 'package:drift/drift.dart';
// import 'package:drift_flutter/drift_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
//
// part 'app_database.g.dart';  // Required for code generation
//
// // Define a table
// class Todos extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text().withLength(min: 1, max: 50)();
//   BoolColumn get completed => boolean().withDefault(Constant(false))();
// }
//
// // Create the Database class
// @DriftDatabase(tables: [Todos])
// class AppDatabase extends _$AppDatabase {
//   // Specify the location of the database file
//   AppDatabase() : super(_openConnection());
//
//   @override
//   int get schemaVersion => 1;
//
//   // CRUD operations
//   Future<List<Todo>> getAllTodos() => select(todos).get();
//   Stream<List<Todo>> watchAllTodos() => select(todos).watch();
//   Future<int> insertTodo(Insertable<Todo> todo) => into(todos).insert(todo);
//   Future<bool> updateTodo(Insertable<Todo> todo) => update(todos).replace(todo);
//   Future<int> deleteTodo(Insertable<Todo> todo) => delete(todos).delete(todo);
// }
//
// // Function to open a connection to the database
// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'db.sqlite'));
//     return NativeDatabase(file);
//   });
// }
