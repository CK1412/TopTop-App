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

String nonAccentVietnamese(String str) {
  str = str.replaceAll(RegExp("à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ"), "a");
  str = str.replaceAll(RegExp("è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ"), "e");
  str = str.replaceAll(RegExp("ì|í|ị|ỉ|ĩ"), "i");
  str = str.replaceAll(RegExp("ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ"), "o");
  str = str.replaceAll(RegExp("ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ"), "u");
  str = str.replaceAll(RegExp("ỳ|ý|ỵ|ỷ|ỹ"), "y");
  str = str.replaceAll(RegExp("đ"), "d");

  str = str.replaceAll(RegExp("À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ"), "A");
  str = str.replaceAll(RegExp("È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ"), "E");
  str = str.replaceAll(RegExp("Ì|Í|Ị|Ỉ|Ĩ"), "I");
  str = str.replaceAll(RegExp("Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ"), "O");
  str = str.replaceAll(RegExp("Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ"), "U");
  str = str.replaceAll(RegExp("Ỳ|Ý|Ỵ|Ỷ|Ỹ"), "Y");
  str = str.replaceAll(RegExp("Đ"), "D");
  return str;
}
