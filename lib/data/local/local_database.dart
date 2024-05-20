import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class DatabaseHelper {
  Database? _db;

  static const _productDatabase = LOCAL_DATABASE;
  static const _databaseVersion = LOCAL_DATABASE_VERSION;
  static const productsTable = LOCAL_TABLE_PRODUCTS;
  static const watchedTable = LOCAL_TABLE_WATCHED;

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
          "user" json,
          "category" json,
          "categoryId" text,
          "createdAt" timestamp DEFAULT now() NOT NULL,
          "updatedAt" timestamp DEFAULT CURRENT_TIMESTAMP
        )
          ''',
    );

    await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS $watchedTable (
          "id" text PRIMARY KEY NOT NULL,
          "name" text,
          "description" text,
          "price" double precision,
          "image" text[],
          "address" json,
          "userId" text NOT NULL,
          "user" json,
          "category" json,
          "categoryId" text,
          "createdAt" timestamp DEFAULT now() NOT NULL,
          "updatedAt" timestamp DEFAULT CURRENT_TIMESTAMP
        )
          ''',
    );
  }

  Future insertLocalProduct({
    required Database db,
    required ProductModel product,
    required String table,
  }) async {
    try {
      return db.transaction((txn) async {
        return txn.insert(
          table,
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
    required String table,
  }) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.query(table);
        return response.map((e) => ProductModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getUserLocalProducts({
    required Database db,
    required String table,
  }) async {
    try {
      final id = supabase.auth.currentUser!.id;
      return db.transaction((txn) async {
        final response = await txn.query(
          table,
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
    required String table,
  }) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.query(
          table,
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
    required String table,
  }) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.delete(
          table,
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
