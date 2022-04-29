import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/models/user.dart' as models;
import 'package:toptop_app/services/auth_service.dart';
import 'package:toptop_app/services/user_service.dart';

class UserNotifier extends StateNotifier<models.User> {
  UserNotifier()
      : super(
          models.User(id: '', username: '', email: '', phoneNumber: ''),
        );

  final _auth = AuthService.instance;
  final _user = UserService.instance;

  @override
  // TODO: implement state
  models.User get state => _auth.currentUser!;

  void updateUser(models.User user) {
    state = user;
    _user.update(id: state.id, userUpdated: user);
  }
}
