import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/state.dart';

import '../../widgets/common/loading_widget.dart';
import '../error_screen.dart';
import '../tab_screen.dart';
import 'sign_in_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);

    return _authState.when(
      data: (data) {
        if (data == null) {
          debugPrint('SIGN IN FAIL ' + data.toString());
          return const SignInScreen();
        }
        debugPrint('SIGN IN OK ' + data.toString());
        return const TabScreen();
      },
      error: (e, stackTrace) => ErrorScreen(e, stackTrace),
      loading: () => const LoadingWidget(),
    );
  }
}
