import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:toptop_app/models/user.dart' as models;

class FirestoreService {
  static final FirestoreService instance = FirestoreService._internal();
  FirestoreService._internal();

  final _fireStore = FirebaseFirestore.instance;

  Future<bool> isNewUser(String uid) async {
    final query = await _fireStore
        .collection('users')
        .where(models.UserField.uid, isEqualTo: uid)
        .get();
    final users = query.docs;
    return users.isEmpty ? true : false;
  }

  Future<void> addUser(BuildContext context, models.User user) async {
    final _isNewUser = await isNewUser(user.uid);

    if (!_isNewUser) return;

    await _fireStore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap())
        .catchError(
      (e) {
        debugPrint("Failed to add user: $e");
      },
    );
    debugPrint('User added!');
  }
}
