//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'app_database.dart';
// class TodoList extends StatelessWidget {
//   final AppDatabase database = AppDatabase();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Todos'),
//       ),
//       body: StreamBuilder<List<Todo>>(
//         stream: database.watchAllTodos(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           final todos = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: todos.length,
//             itemBuilder: (context, index) {
//               final todo = todos[index];
//
//               return ListTile(
//                 title: Text(todo.title),
//                 trailing: Checkbox(
//                   value: todo.completed,
//                   onChanged: (value) {
//                     database.updateTodo(
//                       todo.copyWith(completed: value),
//                     );
//                   },
//                 ),
//                 onLongPress: () => database.deleteTodo(todo),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final title = await _showAddTodoDialog(context);
//           if (title != null) {
//             database.insertTodo(
//               TodosCompanion(
//                 title: Value(title),
//               ),
//             );
//           }
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   Future<String?> _showAddTodoDialog(BuildContext context) {
//     final controller = TextEditingController();
//
//     return showDialog<String>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Todo'),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(hintText: 'Enter todo title'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(controller.text),
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }