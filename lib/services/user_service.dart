import 'package:flutter/cupertino.dart';
import 'package:toptop_app/models/user.dart' as models;
import 'package:toptop_app/services/instance.dart';

class UserService {
  static final UserService instance = UserService._internal();
  UserService._internal();

  final _collection = fireDatabase.collection('users');

  Future<bool> isNewUser(String id) async {
    final query = await _collection
        .where(
          models.UserField.id,
          isEqualTo: models.UserField.id,
        )
        .get();
    final users = query.docs;
    return users.isEmpty ? true : false;
  }

  //* Get infor user by id
  Future<models.User?> getUser(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (doc.exists) {
      return models.User.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  //* Add new user
  Future<void> add(models.User user) async {
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
  Future<void> update({
    required String id,
    required models.User userUpdated,
  }) async {
    currentUser = userUpdated;
    return _collection
        .doc(id)
        .update(userUpdated.toMap())
        .then((value) => debugPrint("User Updated"))
        .catchError(
          (error) => debugPrint("Failed to update user: $error"),
        );
  }
}
