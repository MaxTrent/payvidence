import 'dart:developer' as developer;

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/providers/business_providers/get_all_business_provider.dart';
import 'package:payvidence/repositories/repository/business_repository.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/loading_dialog.dart';
import '../../model/business_model.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../onboarding/onboarding.dart';

final addBusinessViewModelProvider =
    ChangeNotifierProvider<AddBusinessViewModel>((ref) {
  return AddBusinessViewModel(ref);
});

class AddBusinessViewModel extends BaseChangeNotifier {
  final Ref ref;
  AddBusinessViewModel(this.ref);
  IBusinessRepository businessRepository = locator<IBusinessRepository>();

//   Future<String?> uploadImage(File? image, String folder) async {
//     if (image == null) return null;
//
//     try {
//       final formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
//       });
//
//       // final response = await Dio().post(
//       //   "",
//       //   data: formData,
//       //   options: Options(headers: {"Authorization": ""}),
//       // );
//       //
//       // return response.data["url"];
//     } catch (e) {
//       return null;
//     }
//
// }
}
