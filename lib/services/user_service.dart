import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toptop_app/models/user.dart' as user_model;

class UserService {
  final CollectionReference<Map<String, dynamic>> _collection;

  UserService(this._collection);

  Future<bool> isNewUser(String id) async {
    final query = await _collection
        .where(
          user_model.UserField.id,
          isEqualTo: user_model.UserField.id,
        )
        .get();
    final users = query.docs;
    return users.isEmpty ? true : false;
  }

  //* Get infor user by id
  Future<user_model.User?> getUser(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (doc.exists) {
      return user_model.User.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  //* Add new user
  Future<void> addUser(user_model.User user) async {
    final _isNewUser = await isNewUser(user.id);

    if (!_isNewUser) return;

    await _collection.doc(user.id).set(user.toMap()).catchError(
      (e) {
        debugPrint("Failed to add user: $e");
      },
    );
    debugPrint('User added!');
  }

  // * Update user
  Future<void> updateUser({
    required String userId,
    required user_model.User userUpdated,
  }) async {
    return _collection
        .doc(userId)
        .update(userUpdated.toMap())
        .then((value) => debugPrint("User Updated"))
        .catchError(
          (error) => debugPrint("Failed to update user: $error"),
        );
  }
}
