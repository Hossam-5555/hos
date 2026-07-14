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

fileUploadGallery() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions:  ["png", "PNG", "jpg", "jpeg", "gif","webp"],
  );

  if (result != null) {
    return File(result.files.single.path!);
  } else {
    return null;
  }
}

void showImagePickerBottomSheet(VoidCallback camera, VoidCallback galry) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("التقاط صورة بالكاميرا"),
            onTap: () {
              camera();
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text("اختيار من المعرض"),
            onTap: () {
              galry();
              Get.back();
            },
          ),
        ],
      ),
    ),
  );
}
