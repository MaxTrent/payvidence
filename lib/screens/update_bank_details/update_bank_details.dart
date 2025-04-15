import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          //  context.router.pushAndPopUntil(const HomePageRoute(), predicate: (route)=>route.settings.name == '/');
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
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Fill in bank details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'As this is your first invoice to generate, add business bank details to be put on invoice.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'Bank name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Bank Name',
                    controller: bankNameController,
                    validator: (val) => Validator.validateEmpty(val),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Account number',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Account number',
                    controller: accountNumberController,
                    validator: (val) {
                      if (val?.length != 10) {
                        return 'Account number must be of length 10';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Account name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Account name',
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    controller: accountNameController,
                    validator: (val) => Validator.validateEmpty(val),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AppButton(
                    buttonText: 'Save bank details',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        // Usage:
                        final shouldProceed = await showConfirmationDialog(
                          context: context,
                          title: 'Update Bank Details',
                          content: 'Proceed to update bank details?',
                        );
                        if (shouldProceed) {
                          updateBank();
                        }
                        //createReceipt();
                      } // context.push(AppRoutes.receipt);
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

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      ) ??
      false; // Returns false if dialog is dismissed
}
