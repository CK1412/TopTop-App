import 'package:flutter/material.dart';
import 'package:toptop_app/src/constants.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [
        //     CustomColors.pink,
        //     CustomColors.blue,
        //   ],
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        // ),
        color: CustomColors.white,
      ),
    );
  }
}
