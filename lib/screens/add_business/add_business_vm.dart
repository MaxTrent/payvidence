
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/utilities/base_notifier.dart';

class AddBusinessViewModel extends BaseChangeNotifier{
  final Ref ref;
  AddBusinessViewModel(this.ref);

  Future<void> pickImage(ValueNotifier<File?> imageState) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageState.value = File(pickedFile.path);
    }
  }

  Future<String?> uploadImage(File? image, String folder) async {
    if (image == null) return null;

    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      });

      // final response = await Dio().post(
      //   "",
      //   data: formData,
      //   options: Options(headers: {"Authorization": ""}),
      // );
      //
      // return response.data["url"];
    } catch (e) {
      return null;
    }

}}