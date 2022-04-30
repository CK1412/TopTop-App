import 'package:image_picker/image_picker.dart';

// use image picker
Future<String?> pickImage(ImageSource imageSource) async {
  final _imagePicker = ImagePicker();

  // Reduce image size because you don't need too high quality images
  final XFile? imageFile = await _imagePicker.pickImage(
    source: imageSource,
    imageQuality: 25,
  );

  if (imageFile == null) return null;

  return imageFile.path;
}

//* use File picker
// Future<String?> pickImage() async {
//   final results = await FilePicker.platform.pickFiles(
//     allowMultiple: true,
//     type: FileType.custom,
//     allowedExtensions: ['png', 'jpg', 'jpeg'],
//   );

//   if (results == null) return null;
//   return results.files.first.path;
// }
