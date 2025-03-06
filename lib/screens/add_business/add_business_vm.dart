import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/repositories/repository/business_repository.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/loading_dialog.dart';
import '../../model/business_model.dart';
import '../../shared_dependency/shared_dependency.dart';


final addBusinessViewModelProvider =
ChangeNotifierProvider<AddBusinessViewModel>((ref) {
  return AddBusinessViewModel(ref);
});

class AddBusinessViewModel extends BaseChangeNotifier{
  final Ref ref;
  AddBusinessViewModel(this.ref);

  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final issuerController = TextEditingController();
  final roleController = TextEditingController();

  IBusinessRepository businessRepository = locator<IBusinessRepository>();

  ValueNotifier<XFile?> logo = ValueNotifier(null);
  ValueNotifier<XFile?> signature = ValueNotifier(null);


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
  Future<void> createBusiness(BuildContext context) async {

    FormData requestData = FormData.fromMap({
    "name": businessNameController.text,
    "address": businessAddressController.text,
    "phone_number": phoneNumberController.text,
    "issuer": issuerController.text,
    "issuer_role": roleController.text,
    "vat": 5,
    "logo_image": await MultipartFile.fromFile(logo.value!.path, filename: logo.value!.path.split('/').last),
    "issuer_signature_image": await MultipartFile.fromFile(logo.value!.path, filename: logo.value!.path.split('/').last),
    });
    if(!context.mounted) return;
    LoadingDialog.show(context);
    try {
      final Business response = await businessRepository.addBusiness(
          requestData);
      if(!context.mounted) return;
      Navigator.of(context).pop(); // pop loading dialog on success
      ToastService.success(context, "Business created successfully");
      Future.delayed(const Duration(seconds: 2), (){
        if(!context.mounted) return;
        context.router.back();
        context.router.back();

        //  context.router.pushAndPopUntil(const HomePageRoute(), predicate: (route)=>route.settings.name == '/');
        
      });
    }catch(e){
      Navigator.of(context).pop(); // pop loading dialog on error
      ToastService.error(context, 'An error has occurred!');
    }

  }

}