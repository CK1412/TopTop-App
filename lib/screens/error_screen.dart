import 'package:flutter/material.dart';

import '../src/constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.e, this.stackTrace, {Key? key}) : super(key: key);

  final Object e;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                e.toString(),
                style: CustomTextStyle.errorText,
              ),
              const SizedBox(height: 10),
              Text(
                stackTrace.toString(),
                style: CustomTextStyle.errorText,
              )
            ],
          ),
        ),
      ),
    );
  }
}
