import 'package:ecoville_bloc/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _db;
  static const _databaseName = "local.db";
  static const _databaseVersion = 1;
  static const favouritesDesignsTable = "favourites";
  static const collectedWastesTable = "collectedWastes";

  Future<Database> init() async {
    try {
      final path = join(await getDatabasesPath(), _databaseName);

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
          CREATE TABLE IF NOT EXISTS $favouritesDesignsTable (
            id TEXT PRIMARY KEY UNIQUE,
            name TEXT, 
            location TEXT,
            type TEXT,
            lon NUMERIC,
            lat NUMERIC,
            description TEXT,
            image TEXT,
            userId TEXT 
            )
          ''',
    );

     await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS $collectedWastesTable (
            id TEXT PRIMARY KEY UNIQUE,
            name TEXT, 
            location TEXT,
            type TEXT,
            lon NUMERIC,
            lat NUMERIC,
            description TEXT,
            image TEXT,
            userId TEXT 
            )
          ''',
    );
  }

  Future<bool> clearAllTables() async {
    try {
      await _db!.delete(favouritesDesignsTable);
      await _db!.delete(collectedWastesTable);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future insertProductToFavourite(
      {required Database db, required Product favourite}) async {
    try {
      return db.transaction((txn) async {
        await txn.insert(
            favouritesDesignsTable,
            favourite.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

    Future insertProductToCollected(
      {required Database db, required Product collected}) async {
    try {
      return db.transaction((txn) async {
        await txn.insert(
            collectedWastesTable,
            collected.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  //* GET

  Future<List<Product>> findAllFavouriteProducts({required Database db}) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.query(
          favouritesDesignsTable,
        );

        return response.map((e) => Product.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

    Future<List<Product>> findAllCollectedProducts({required Database db}) async {
    try {
      return db.transaction((txn) async {
        final response = await txn.query(
          collectedWastesTable,
        );

        return response.map((e) => Product.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<bool> removeFromCollected(
      {required Database db, required String id}) async {
    try {
      return db.transaction((txn) async {
        await txn.delete(
          collectedWastesTable,
          where: 'id = ?',
          whereArgs: [id],
        );
        return true;
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

   Future<bool> removeFromFavourite(
      {required Database db, required String id}) async {
    try {
      return db.transaction((txn) async {
        await txn.delete(
          favouritesDesignsTable,
          where: 'id = ?',
          whereArgs: [id],
        );
        return true;
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
