import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (var imageFile in imageFiles) {
      images.add(File(imageFile.path));
    }
  }
  return images;
}

Future<File?> pickImage() async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.gallery);
  if (image == null) return null;
  return File(image.path);
}
