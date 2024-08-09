import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

import 'model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  late Database _database;

  DatabaseHelper._internal() {
    log_data("_createTable   -------------------");
    open.overrideFor(OperatingSystem.windows, _openOnWindows);
    log_data("_createTable   -------------------");
    _database = sqlite3.open('products.db');
    _createTable();
  }

  void _createTable() {
    log_data("_createTable   -------------------");
    _database.execute('''
      CREATE TABLE IF NOT EXISTS products(
        id TEXT PRIMARY KEY,
        productId INTEGER,
        name TEXT,
        salePrice REAL,
        purchasePrice REAL,
        salesTax REAL,
        description TEXT
      )
    ''');
  }

  void insertProduct(Product product) {
    log_data("7896345454544");
    final stmt = _database.prepare(
      'INSERT INTO products (id, productId, name, salePrice, purchasePrice, salesTax, description) VALUES (?, ?, ?, ?, ?, ?, ?)',
    );
    stmt.execute([
      product.id,
      product.productId,
      product.name,
      product.salePrice,
      product.purchasePrice,
      product.salesTax,
      product.description,
    ]);
    stmt.dispose();
  }

  List<Product> getProducts() {
    final ResultSet result = _database.select('SELECT * FROM products');
    return result.map((row) {
      return Product(
        id: row['id'],
        productId: row['productId'],
        name: row['name'],
        salePrice: row['salePrice'],
        purchasePrice: row['purchasePrice'],
        salesTax: row['salesTax'],
        description: row['description'],
      );
    }).toList();
  }

  void updateProduct(Product product) {
    final stmt = _database.prepare(
      'UPDATE products SET productId = ?, name = ?, salePrice = ?, purchasePrice = ?, salesTax = ?, description = ? WHERE id = ?',
    );
    stmt.execute([
      product.productId,
      product.name,
      product.salePrice,
      product.purchasePrice,
      product.salesTax,
      product.description,
      product.id,
    ]);
    stmt.dispose();
  }

  void deleteProduct(String id) {
    final stmt = _database.prepare('DELETE FROM products WHERE id = ?');
    stmt.execute([id]);
    stmt.dispose();
  }
}

DynamicLibrary _openOnWindows() {
  final script = File(Platform.script.toFilePath());
  final libraryNextToScript = File('${script.path}/sqlite3.dll');
  return DynamicLibrary.open(libraryNextToScript.path);
}
