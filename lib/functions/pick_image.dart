import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(ImageSource imageSource) async {
  final _imagePicker = ImagePicker();
  final XFile? imageFile = await _imagePicker.pickImage(
    source: imageSource,
    maxHeight: 2340,
    maxWidth: 1080,
  );

  if (imageFile == null) return null;

  // convert XFile to File
  File tmpImageFile = File(imageFile.path);

  return tmpImageFile;
}
