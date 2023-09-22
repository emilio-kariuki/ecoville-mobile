// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:ecoville_bloc/data/services/local_storage/shared_preferences_manager.dart';
import 'package:flutter/material.dart';

import '../../models/product_model.dart';

class ProductRepository {
  Future<bool> createProduct({
    required String name,
    required String description,
    required String location,
    required String image,
    required String type,
    required double lon,
    required double lat,
  }) async {
    try {
      final uid = await SharedPreferencesManager().getId();
      final id = const uuid.Uuid().v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      });
      await FirebaseFirestore.instance.collection('products').doc(id).set({
        "id": id,
        "name": name,
        "description": description,
        "location": location,
        "image": image,
        "type": type,
        "lon": lon,
        "lat": lat,
        "userId": uid,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final products = await firebaseFirestore
          .collection("products")
          .get()
          .then((value) =>
              value.docs.map((e) => Product.fromJson(e.data())).toList());
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<Product> getProduct({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final products = await firebaseFirestore
          .collection("products")
          .doc(id)
          .get()
          .then((value) => Product.fromJson(value.data()!));

    
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Product>> searchProducts({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final products = await firebaseFirestore
          .collection("products")
          .where("name", isGreaterThanOrEqualTo: query)
          .get()
          .then((value) =>
              value.docs.map((e) => Product.fromJson(e.data())).toList());
        debugPrint("the products are $products");
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Product>> getProductByCategory({required String category}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final products = await firebaseFirestore
          .collection("products")
          .where("type", isEqualTo: category)
          .get()
          .then((value) =>
              value.docs.map((e) => Product.fromJson(e.data())).toList());

      debugPrint("the products category are $products");
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Product>> getUserProducts() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final userId = await SharedPreferencesManager().getId();
      final products = await firebaseFirestore
          .collection("products")
          .where("userId", isEqualTo: userId)
          .get()
          .then((value) =>
              value.docs.map((e) => Product.fromJson(e.data())).toList());
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Product>> getUserProductsByCategory(
      {required String category}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final userId = await SharedPreferencesManager().getId();
      final products = await firebaseFirestore
          .collection("products")
          .where("userId", isEqualTo: userId)
          .where("type", isEqualTo: category)
          .get()
          .then((value) =>
              value.docs.map((e) => Product.fromJson(e.data())).toList());
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> deleteProduct({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection("products").doc(id).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateProduct({
    required String id,
    required String name,
    required String description,
    required String location,
    required String image,
    required String type,
    required double lon,
    required double lat,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("products").doc(id).update({
        "name": name,
        "description": description,
        "location": location,
        "image": image,
        "type": type,
        "lon": lon,
        "lat": lat,
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
