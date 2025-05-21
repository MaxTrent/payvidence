import 'dart:developer' as developer;
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/utilities/app_functions.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../gen/assets.gen.dart';
import '../../model/business_model.dart';
import '../../providers/business_providers/get_all_business_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/toast_service.dart';
import '../onboarding/onboarding.dart';
import 'add_business_vm.dart';

@RoutePage(name: 'AddBusinessRoute')
class AddBusiness extends HookConsumerWidget {
  AddBusiness({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final roleController = TextEditingController();
  final ValueNotifier<XFile?> logo = ValueNotifier(null);
  final ValueNotifier<XFile?> signature = ValueNotifier(null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(addBusinessViewModelProvider);
    final sessionManager = locator<SessionManager>();
    final firstName = sessionManager.get<String>(SessionConstants.userFirstName);
    final lastName = sessionManager.get<String>(SessionConstants.userLastName);
    final email = sessionManager.get<String>(SessionConstants.userEmail);
    final fullName = [firstName, lastName].where((s) => s != null && s.isNotEmpty).join(' ').trim();
    final issuerName = fullName.isEmpty ? (email ?? '') : fullName;

    developer.log('AddBusiness: firstName=$firstName, lastName=$lastName, fullName=$fullName, issuerName=$issuerName');

    final issuerController = useTextEditingController(text: issuerName);

    Future<void> createBusiness(BuildContext context) async {
      final requestData = FormData.fromMap({
        "name": businessNameController.text,
        "address": businessAddressController.text,
        "phone_number": phoneNumberController.text,
        "issuer": issuerController.text,
        "issuer_role": roleController.text,
        "vat": 5,
        "logo_image": await MultipartFile.fromFile(
          logo.value!.path,
          filename: logo.value!.path.split('/').last,
        ),
        "issuer_signature_image": await MultipartFile.fromFile(
          signature.value!.path,
          filename: signature.value!.path.split('/').last,
        ),
      });
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final Business response = await vm.businessRepository.addBusiness(requestData);
        if (!context.mounted) return;
        Navigator.of(context).pop();
        ToastService.showSnackBar("Business created successfully");
        ref.invalidate(getAllBusinessProvider);
        Future.delayed(const Duration(seconds: 2), () {
          locator<PayvidenceAppRouter>().popUntil((route) => route is OnboardingScreen);
          locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.home);
          locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.allBusiness);
        });
      } on DioException catch (e) {
        Navigator.of(context).pop();
        ToastService.showErrorSnackBar(
          e.response?.data['message'] ?? 'An unknown error has occurred!!!',
        );
      } catch (e) {
        print(e);
        Navigator.of(context).pop();
        ToastService.showErrorSnackBar('An error has occurred!');
      }
    }

    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView(
              children: [
                Text(
                  'Set-up business',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Fill in all details to add your business.',
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(height: 12.h),
                _buildSectionTitle(context, 'Business name'),
                AppTextField(
                  hintText: 'Business name',
                  controller: businessNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (val) => Validator.validateName(val),
                ),
                _buildSectionTitle(context, 'Business address'),
                AppTextField(
                  hintText: 'Business address',
                  controller: businessAddressController,
                  textCapitalization: TextCapitalization.words,
                  validator: (val) => Validator.validateName(val),
                ),
                _buildSectionTitle(context, 'Business phone number'),
                AppTextField(
                  hintText: 'Business phone number',
                  controller: phoneNumberController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (val) => Validator.validatePhoneNumber(val),
                ),
                _buildSectionTitle(context, 'Business logo'),
                GestureDetector(
                  onTap: () async {
                    logo.value = await AppFunctions.pickImage();
                  },
                  child: ValueListenableBuilder(
                    valueListenable: logo,
                    builder: (context, val, _) {
                      if (val == null) {
                        return SvgPicture.asset(Assets.svg.uploadImage);
                      } else {
                        return Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Image.file(
                                File(val.path),
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey,
                                ),
                                child: const Text(
                                  "Tap to Change",
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                _buildSectionTitle(context, 'Who issues receipts and invoices?'),
                AppTextField(
                  hintText: issuerName.isEmpty ? 'Issuer name not available' : 'Issuer name',
                  controller: issuerController,
                  // fillColor: textFieldGrey,
                  // filled: true,
                  enabled: false,
                  validator: issuerName.isEmpty ? (_) => 'Issuer name is required' : (val) => Validator.validateName(val),
                ),
                _buildSectionTitle(context, 'What is the role of this issuer?'),
                AppTextField(
                  hintText: 'Role of issuer',
                  controller: roleController,
                  validator: (val) => Validator.validateName(val),
                ),
                _buildSectionTitle(context, 'Issuer signature'),
                GestureDetector(
                  onTap: () async {
                    signature.value = await AppFunctions.pickImage();
                  },
                  child: ValueListenableBuilder(
                    valueListenable: signature,
                    builder: (context, val, _) {
                      if (val == null) {
                        return SvgPicture.asset(Assets.svg.uploadImage);
                      } else {
                        return Stack(
                          children: [
                            Image.file(
                              File(val.path),
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey,
                                ),
                                child: const Text(
                                  "Tap to Change",
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 32.h),
                AppButton(
                  buttonText: 'Add business',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      if (logo.value == null) {
                        ToastService.showErrorSnackBar("Select a logo image");
                      } else if (signature.value == null) {
                        ToastService.showErrorSnackBar("Select a signature image");
                      } else if (issuerName.isEmpty) {
                        ToastService.showErrorSnackBar("Issuer name is not available. Please update your profile in Settings.");
                      } else {
                        createBusiness(context);
                      }
                    }
                  },
                ),
                8.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 8.w),
      child: Text(title, style: Theme.of(context).textTheme.displaySmall),
    );
  }
}