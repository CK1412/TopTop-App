import 'dart:io';
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
