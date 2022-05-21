import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/providers.dart';

class StorageService {
  final Reader _reader;

  StorageService(this._reader);

  //* upload file to firestorage
  Future<void> uploadFile(
    BuildContext context, {
    required String folderName,
    required String filePath,
    required String fileName,
  }) async {
    var file = File(filePath);

    try {
      await _reader(firebaseStorageProvider)
          .ref('$folderName/$fileName')
          .putFile(file);
    } on FirebaseException catch (e) {
      FlushbarHelper.createError(message: e.message!).show(context);
    }
  }

  Future<String> getDownloadUrl({
    required String folder,
    required String fileName,
  }) async {
    return await _reader(firebaseStorageProvider)
        .ref('$folder/$fileName')
        .getDownloadURL();
  }

  Future<void> deleteFile(
    BuildContext context, {
    required String folderName,
    required String fileName,
  }) async {
    try {
      await _reader(firebaseStorageProvider)
          .ref('$folderName/$fileName')
          .delete();
    } on FirebaseException catch (e) {
      FlushbarHelper.createError(message: e.message!).show(context);
    }
  }
}
