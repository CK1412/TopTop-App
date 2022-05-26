import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../src/constants.dart';

Flushbar flushbarMessage({
  required BuildContext context,
  required String? title,
  required String message,
  String imageUrl = '',
  File? imageFile,
  int displaySeconds = 3,
}) {
  return Flushbar(
    title: title ?? AppLocalizations.of(context)!.message,
    duration: Duration(seconds: displaySeconds),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: CustomColors.white,
    titleColor: CustomColors.pink,
    messageText: Text(
      message,
      style: CustomTextStyle.bodyText2.copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      maxLines: 2,
    ),
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(14),
    borderRadius: BorderRadius.circular(10),
    icon: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: imageUrl.isEmpty
          ? CircleAvatar(backgroundImage: FileImage(imageFile!))
          : CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
    ),
    leftBarIndicatorColor: CustomColors.pink,
  );
}

Flushbar flushbarProgress({
  required String message,
  required LinearProgressIndicator linearProgressIndicator,
  String? title,
  Duration duration = const Duration(seconds: 3),
  AnimationController? progressIndicatorController,
  Color? progressIndicatorBackgroundColor,
  IconData iconData = Icons.cloud_download,
}) {
  return Flushbar(
    title: title,
    message: message,
    icon: Icon(
      iconData,
      color: CustomColors.blue,
    ),
    duration: duration,
    showProgressIndicator: true,
    progressIndicatorController: progressIndicatorController,
    progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
  );
}
