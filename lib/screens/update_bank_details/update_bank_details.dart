import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/providers/business_providers/get_all_business_provider.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'UpdateBankDetailsRoute')
class UpdateBankDetails extends ConsumerWidget {
  UpdateBankDetails({super.key});

  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<dynamic> _buildConfirmBankDetailsBottomSheet(
      BuildContext context, void Function() onConfirm) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: 360.h,
          decoration: BoxDecoration(
            color: Colors.white, // Adjust for dark mode if needed
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.r),
              topLeft: Radius.circular(40.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 140.w),
                      child: Container(
                        height: 5.h,
                        width: 67.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9), // Handle color
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 38.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Confirm Bank Details',
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        'Make sure your details are correct before continuing.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 47.h),
                    AppButton(
                      buttonText: 'Confirm',
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        onConfirm(); // Call the updateBank function
                      },
                      backgroundColor: primaryColor2,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    AppButton(
                      buttonText: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: Colors.transparent,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> updateBank() async {
      Map<String, dynamic> data = {
        "bank_name": bankNameController.text,
        "account_number": accountNumberController.text,
        "account_name": accountNameController.text,
      };
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final response = await ref
            .read(getAllBusinessProvider.notifier)
            .updateBusiness(ref.read(getCurrentBusinessProvider)!.id!, data);

        print(response.toJson());
        if (!context.mounted) return;
        Navigator.of(context).pop(); // pop loading dialog on success
        ToastService.showSnackBar("Bank details updated successfully");
        ref.invalidate(getAllBusinessProvider);
        ref
            .read(getCurrentBusinessProvider.notifier)
            .resetCurrentBusiness(response);
        await Future.delayed(const Duration(seconds: 1), () {});
        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
        });
      } on DioException catch (e) {
        print("here");
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.showErrorSnackBar(
            e.response?.data['message'] ?? 'An unknown error has occurred!!!');
      } catch (e) {
        print("let go");
        print(e);
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.showErrorSnackBar('An unknown error has occurred!');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    'Fill in bank details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'As this is your first invoice to generate, add business bank details to be put on invoice.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Bank name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 8.h),
                  AppTextField(
                    hintText: 'Bank Name',
                    controller: bankNameController,
                    validator: (val) => Validator.validateEmpty(val),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Account number',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 8.h),
                  AppTextField(
                    hintText: 'Account number',
                    controller: accountNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (val) {
                      if (val?.length != 10) {
                        return 'Account number must be of length 10';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Account name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 8.h),
                  AppTextField(
                    hintText: 'Account name',
                    filled: true,
                    fillColor: textFieldGrey,
                    controller: accountNameController,
                    validator: (val) => Validator.validateEmpty(val),
                  ),
                  SizedBox(height: 20.h),
                  AppButton(
                    buttonText: 'Save bank details',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        _buildConfirmBankDetailsBottomSheet(context, updateBank);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}