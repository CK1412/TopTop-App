import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:toptop_app/src/constants.dart';
import 'package:video_compress/video_compress.dart';

String getTypeFile(String fileName) {
  return "." + fileName.split('.').last;
}

Future<MediaInfo?> compressVideo(File videoFile) async {
  try {
    await VideoCompress.setLogLevel(0);

    return VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.Res1920x1080Quality,
      includeAudio: true,
    );
  } catch (e) {
    VideoCompress.cancelCompression();
  }
  return null;
}

void showFlushbar({
  required BuildContext context,
  String title = 'Message',
  required String message,
  String imageUrl = '',
  File? imageFile,
  int displaySeconds = 3,
}) {
  Flushbar(
    title: title,
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
    icon: imageUrl.isEmpty
        ? CircleAvatar(backgroundImage: FileImage(imageFile!))
        : CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
    leftBarIndicatorColor: CustomColors.pink,
  ).show(context);
}
