import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/screens/auth/sign_in_screen.dart';
import 'package:toptop_app/screens/error_screen.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authControllerProvider);

    return _authState == null ? const SignInScreen() : const HomeScreen();
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    return Scaffold(
      body: userState.when(
          data: (user) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('id    ' + user!.id),
                  Text('username    ' + user.username),
                  Text('avatar    ' + user.avatarUrl),
                  Text('bio     ' + user.bio),
                  Text('email     ' + user.email),
                  Text('phone     ' + user.phoneNumber),
                  Text('followers     ' + user.followers.length.toString()),
                  Text('following     ' + user.following.length.toString()),
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(authControllerProvider.notifier)
                          .signOut(context);
                    },
                    child: const Text('Sign out'),
                  )
                ],
              ),
          error: (e, stackTrace) => ErrorScreen(e, stackTrace),
          loading: () => const CenterLoadingWidget()),
    );
  }
}
