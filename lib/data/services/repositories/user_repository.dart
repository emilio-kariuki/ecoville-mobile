import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utilities/app_images.dart';
import '../../models/user_model.dart';
import '../local_storage/shared_preferences_manager.dart';

class UserRepository {
  Future<bool> createUserData(
      {required UserModel user, required String id}) async {
    try {
      await FirebaseFirestore.instance.collection(kReleaseMode ?'users' : "users_test").doc(id).set({
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "location": user.location,
        "lat": user.lat,
        "lon": user.lon,
        "userID": user.userID,
        "imageUrl": user.imageUrl ?? AppImages.defaultImage,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<UserModel> getUser() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final userId = await SharedPreferencesManager().getId();
      final user = await firebaseFirestore
          .collection(kReleaseMode ?"users" : "users_test")
          .doc(userId)
          .get()
          .then((value) => UserModel.fromJson(value.data()!));
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> updateUser({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String lat,
    required String lon,
    required String userId,
    required String image,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection(kReleaseMode ?"users" : "users_test").doc(userId).update({
        "username": name,
        "email": email,
        "phone": phone,
        "location": location,
        "lat": lat,
        "lon": lon,
        "userID": userId,
        "imageUrl": image,
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
