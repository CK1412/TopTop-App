import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:toptop_app/models/user.dart' as models;

class UserService {
  static final UserService instance = UserService._internal();
  UserService._internal();

  final _collection = FirebaseFirestore.instance.collection('users');

  Future<bool> isNewUser(String uid) async {
    final query = await _collection
        .where(
          models.UserField.uid,
          isEqualTo: uid,
        )
        .get();
    final users = query.docs;
    return users.isEmpty ? true : false;
  }

  Future<void> addUser(models.User user) async {
    final _isNewUser = await isNewUser(user.uid);

    if (!_isNewUser) return;

    await _collection.doc(user.uid).set(user.toMap()).catchError(
      (e) {
        debugPrint("Failed to add user: $e");
      },
    );
    debugPrint('User added!');
  }
}
