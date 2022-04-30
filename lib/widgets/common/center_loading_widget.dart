import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../src/constants.dart';

class CenterLoadingWidget extends StatelessWidget {
  const CenterLoadingWidget({
    Key? key,
    this.size = 100,
    this.backgroundTransparent = true,
  }) : super(key: key);

  final double size;
  final bool backgroundTransparent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundTransparent
              ? Colors.transparent
              : CustomColors.black.withOpacity(.2),
        ),
        child: Lottie.asset(
          LottiePath.loader,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
