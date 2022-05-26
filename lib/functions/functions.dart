import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getFileType(String fileName) {
  return fileName.split('.').last;
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

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  String content = '',
  required String actionName,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: content.isNotEmpty ? Text(content) : null,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(actionName),
        ),
      ],
    ),
  );
}

void showSnackbarMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<void> openUrl(String urlString) async {
  if (await canLaunchUrlString(urlString)) {
    await launchUrlString(urlString);
  } else {
    throw 'Could not launch $urlString';
  }
}
