import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/state_providers.dart';
import '../common/custom_circle_avatar.dart';

class CircleAnimationWidget extends StatefulWidget {
  const CircleAnimationWidget({
    Key? key,
    required this.avatarUrl,
  }) : super(key: key);

  final String avatarUrl;
  @override
  State<CircleAnimationWidget> createState() => _CircleAnimationWidgetState();
}

class _CircleAnimationWidgetState extends State<CircleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // create a animation with type of double
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )
      ..forward()
      ..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.grey,
          ],
          tileMode: TileMode.mirror,
        ),
        shape: BoxShape.circle,
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final videoPlaying = ref.watch(videoStateProvider);

          if (videoPlaying) {
            _controller.forward();
          } else {
            _controller.stop();
          }

          return RotationTransition(
            // turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            turns: _animation,
            filterQuality: FilterQuality.low,
            child: CustomCircleAvatar(
              avatarUrl: widget.avatarUrl,
              radius: 16,
            ),
          );
        },
      ),
    );
  }
}
