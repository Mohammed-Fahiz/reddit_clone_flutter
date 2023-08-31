import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar({required String errMsg, required BuildContext context}) {
  final snackBar = SnackBar(content: Text(errMsg));
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}
