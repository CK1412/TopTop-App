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
          isEqualTo: id,
        )
        .get();
    return query.docs.isEmpty;
  }

  //* Get infor user by id
  Future<user_model.User?> getUserByID(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (doc.exists) {
      return user_model.User.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  Future<List<user_model.User>> getAllUser() async {
    final query = await _collection.get();

    return query.docs
        .map(
          (doc) => user_model.User.fromMap(doc.data()),
        )
        .toList();
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
    required String id,
    required user_model.User userUpdated,
  }) async {
    return _collection
        .doc(id)
        .update(userUpdated.toMap())
        .then((value) => debugPrint("User Updated"))
        .catchError(
          (error) => debugPrint("Failed to update user: $error"),
        );
  }
}
