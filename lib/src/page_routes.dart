import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({
    required this.child,
    this.direction = AxisDirection.left,
  }) : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  Offset get getBeginOffset {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0.0, 1.0);
      case AxisDirection.down:
        return const Offset(0.0, -1.0);
      case AxisDirection.right:
        return const Offset(-1.0, 0.0);
      case AxisDirection.left:
        return const Offset(1.0, 0.0);
    }
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final tween = Tween<Offset>(
      begin: getBeginOffset,
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
    // return FadeTransition(
    //   opacity: animation,
    //   child: child,
    // );
  }
}
