import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

imageUploadCamera() async {
  final XFile? file = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 90,
  );
  if (file != null) {
    return File(file.path);
  } else {
    return null;
  }
}

fileUploadGallery({isSvg = false}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: isSvg
        ? ["svg", "SVG"]
        : ["png", "PNG", "jpg", "jpeg", "gif"],
  );

  if (result != null) {
    return File(result.files.single.path!);
  } else {
    return null;
  }
}

void showImagePickerBottomSheet(File? file) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("التقاط صورة بالكاميرا"),
            onTap: () {
              imageUploadCamera();
              
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("اختيار من المعرض"),
            onTap: () {
              fileUploadGallery(isSvg: false);
              
              Get.back();
            },
          ),
        ],
      ),
    ),
  );
}
