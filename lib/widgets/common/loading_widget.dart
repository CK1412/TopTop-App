import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../src/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(LottiePath.loader, height: 80),
    );
  }
}
