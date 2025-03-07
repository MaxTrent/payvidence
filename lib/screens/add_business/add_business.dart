import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/toast_service.dart';
import 'add_business_vm.dart';

@RoutePage(name: 'AddBusinessRoute')
class AddBusiness extends HookConsumerWidget {
  AddBusiness({super.key});

  // final _controller = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    AddBusinessViewModel vm = ref.watch(addBusinessViewModelProvider);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final logoImage = useState<File?>(null);
    final signatureImage = useState<File?>(null);

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
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'Fill in all details to add your business.',
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(
                  height: 12.h,
                ),
                _buildSectionTitle(context, 'Business name'),
                AppTextField(
                  hintText: 'Business name',
                  controller: vm.businessNameController,
                  validator: (val) {
                    return Validator.validateName(val);
                  },
                ),
                _buildSectionTitle(context, 'Business address'),
                AppTextField(
                  hintText: 'Business address',
                  controller: vm.businessAddressController,
                  validator: (val) {
                    return Validator.validateName(val);
                  },
                ),
                _buildSectionTitle(context, 'Business phone number'),
                AppTextField(
                  hintText: 'Business phone number',
                  controller: vm.phoneNumberController,
                  validator: (val) {
                    return Validator.validatePhoneNumber(val);
                  },
                ),
                _buildSectionTitle(context, 'Business logo'),
                GestureDetector(
                    onTap: () async {
                      vm.logo.value = await AppFunctions.pickImage();
                    },
                    child: ValueListenableBuilder(
                      valueListenable: vm.logo,
                      builder: (context, val, _) {
                        if (val == null) {
                          return SvgPicture.asset(Assets.svg.uploadImage);
                        } else {
                          return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(val.name),
                                  const Text(
                                    "Change",
                                    style: TextStyle(
                                        color: Colors.purple, fontSize: 10),
                                  ),
                                ],
                              ));
                        }
                      },
                    )),
                _buildSectionTitle(
                    context, 'Who issues receipts and invoices?'),
                AppTextField(
                  hintText: '',
                  controller: vm.issuerController,
                  fillColor: borderColor,
                  filled: true,
                  validator: (val) {
                    return Validator.validateName(val);
                  },
                ),
                _buildSectionTitle(
                    context, 'What is the role of this issuer? '),
                AppTextField(
                  hintText: 'Role of issuer',
                  controller: vm.roleController,
                  validator: (val) {
                    return Validator.validateName(val);
                  },
                ),
                _buildSectionTitle(context, 'Issuer signature'),
                GestureDetector(
                    onTap: () async {
                      vm.signature.value = await AppFunctions.pickImage();
                    },
                    child: ValueListenableBuilder(
                        valueListenable: vm.signature,
                        builder: (context, val, _) {
                          if (val == null) {
                            return SvgPicture.asset(Assets.svg.uploadImage);
                          } else {
                            return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(val.name),
                                    const Text(
                                      "Change",
                                      style: TextStyle(
                                          color: Colors.purple, fontSize: 10),
                                    ),
                                  ],
                                ));
                          }
                        })),
                SizedBox(
                  height: 32.h,
                ),
                AppButton(
                    buttonText: 'Add business',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (vm.logo.value == null) {
                          ToastService.error(context, "Select a logo image");
                        } else if (vm.signature.value == null) {
                          ToastService.error(
                              context, "Select a signature image");
                        } else {
                          vm.createBusiness(context);
                        }
                      }
                      // locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.addBusiness);
                    }),
                8.verticalSpace
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
