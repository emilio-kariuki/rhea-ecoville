import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class DatabaseHelper {
  Database? _db;

  static const _productDatabase = LOCAL_DATABASE;
  static const _databaseVersion = LOCAL_DATABASE_VERSION;
  static const savedTable = LOCAL_TABLE_PRODUCT_SAVED;
  static const watchedTable = LOCAL_TABLE_WATCHED;
  static const wishlistTable = LOCAL_TABLE_WISHLIST;
  static const favouriteTable = LOCAL_TABLE_FAVOURITE;
  static const cartTable = LOCAL_TABLE_CART;
  static const laterCartTable = LOCAL_TABLE_LATER_CART;
  static const productTable = LOCAL_TABLE_PRODUCT;
  static const addressTable = LOCAL_TABLE_ADDRESS;
  static const categoryTable = LOCAL_TABLE_CATEGORY;
  static const searchTable = LOCAL_TABLE_SEARCH;

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
          CREATE TABLE IF NOT EXISTS $watchedTable (
          "id" text PRIMARY KEY NOT NULL,
          "image" text,
          "name" text,
          "available" text,
          "price" double precision,
          "userId" text NOT NULL
        )
          ''',
    );
    await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS $wishlistTable (
          "id" text PRIMARY KEY NOT NULL,
          "image" text,
          "name" text,
          "available" text,
          "price" double precision,
          "userId" text NOT NULL
        )
          ''',
    );

    await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS $cartTable (
          "id" text PRIMARY KEY NOT NULL,
          "image" text,
          "name" text,
          "available" text,
          "price" double precision,
          "userId" text NOT NULL
        )
          ''',
    );
    await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS $laterCartTable (
          "id" text PRIMARY KEY NOT NULL,
          "image" text,
          "name" text,
          "price" double precision,
          "userId" text NOT NULL
        )
          ''',
    );

    await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS $categoryTable (
          "id" text PRIMARY KEY NOT NULL,
          "name" text,
          "image" text
          )
      '''
);
    await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS $searchTable (
          "id" text PRIMARY KEY NOT NULL,
          "name" text
        )
          ''',
    );
  }

  Future insertLocalProduct({
    required Database db,
    required LocalProductModel product,
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

  Future<List<LocalProductModel>> getLocalProducts({
    required Database db,
    required String table,
  }) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.query(table);
        return response.map((e) => LocalProductModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<LocalProductModel>> getUserLocalProducts({
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

        final products =
            response.map((e) => LocalProductModel.fromJson(e)).toList();
        return products;
      });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<LocalProductModel>> searchLocalProducts({
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

        return response.map((e) => LocalProductModel.fromJson(e)).toList();
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
