import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class DatabaseHelper {
  Database? _db;

  static const _productDatabase = "products.db";
  static const _databaseVersion = 1;
  static const productsTable = "products";

  Future<Database> init() async {
    try {
      final path = join(await getDatabasesPath(), _productDatabase);

      _db = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
      );
      return _db!;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS $productsTable (
          "id" text PRIMARY KEY NOT NULL,
          "name" text,
          "description" text,
          "price" double precision,
          "image" text[],
          "address" json,
          "userId" text NOT NULL,
          "createdAt" timestamp DEFAULT now() NOT NULL,
          "updatedAt" timestamp DEFAULT CURRENT_TIMESTAMP
        )
          ''',
    );
  }

  Future insertLocalProduct({
    required Database db,
    required ProductModel product,
  }) async {
    try {
      return db.transaction((txn) async {
        return txn.insert(
          productsTable,
          product.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<ProductModel>> getLocalProducts({
    required Database db,
  }) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.query(productsTable);
        return response.map((e) => ProductModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getUserLocalProducts({
    required Database db,
  }) async {
    try {
      final id = supabase.auth.currentUser!.id;
      return db.transaction((txn) async {
        final response = await txn.query(
          productsTable,
          where: 'userId = ?',
          whereArgs: [id],
        );

        final products = response.map((e) => ProductModel.fromJson(e)).toList();
        return products;
      });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> searchLocalServices({
    required Database db,
    required String query,
  }) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.query(
          productsTable,
          where: 'name LIKE ?',
          whereArgs: ['%$query%'],
        );

        return response.map((e) => ProductModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<bool> deleteLocalProduct({
    required Database db,
    required String id,
  }) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.delete(
          productsTable,
          where: 'id = ?',
          whereArgs: [id],
        );
        return response > 0;
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
