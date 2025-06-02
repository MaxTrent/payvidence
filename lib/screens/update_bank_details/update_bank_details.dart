import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/providers/business_providers/get_all_business_provider.dart';
import 'package:payvidence/utilities/validators.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
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
    final responsiveData =
        ResponsiveInherited.of(context); // Define inside method with context

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(360),
          decoration: BoxDecoration(
            color: Colors.white, // Adjust for dark mode if needed
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                  responsiveData.smallRadius * 2), // Approx 40.r
              topLeft: Radius.circular(
                  responsiveData.smallRadius * 2), // Approx 40.r
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveData.scaleWidth(20),
                vertical: responsiveData.scaleHeight(10)),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: responsiveData.scaleWidth(140)),
                      child: Container(
                        height: responsiveData.scaleHeight(5),
                        width: responsiveData.scaleWidth(67),
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9), // Handle color
                          borderRadius: BorderRadius.circular(
                              responsiveData.smallRadius * 5), // Approx 100.r
                        ),
                      ),
                    ),
                    SizedBox(height: responsiveData.scaleHeight(38)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Confirm Bank Details',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  fontSize: Responsive.fontSize(context, 22),
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
                    SizedBox(height: responsiveData.scaleHeight(12)),
                    Center(
                      child: Text(
                        'Make sure your details are correct before continuing.',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                    ),
                    SizedBox(height: responsiveData.scaleHeight(47)),
                    AppButton(
                      buttonText: 'Confirm',
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        onConfirm(); // Call the updateBank function
                      },
                      backgroundColor: primaryColor2,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(8)),
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
    final responsiveData =
        ResponsiveInherited.of(context); // Define inside build

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

    return ResponsiveWrapper(
        child: Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsiveData.paddingHorizontal),
                child: SafeArea(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: responsiveData.scaleHeight(16)),
                        Text(
                          'Fill in bank details',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        Text(
                          'As this is your first invoice to generate, add business bank details to be put on invoice.',
                          style: Theme.of(context).textTheme.displaySmall!,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(32)),
                        Text(
                          'Bank name',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        AppTextField(
                          hintText: 'Bank Name',
                          controller: bankNameController,
                          validator: (val) => Validator.validateEmpty(val),
                        ),
                        SizedBox(height: responsiveData.scaleHeight(20)),
                        Text(
                          'Account number',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
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
                        SizedBox(height: responsiveData.scaleHeight(20)),
                        Text(
                          'Account name',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        AppTextField(
                          hintText: 'Account name',
                          filled: true,
                          fillColor: textFieldGrey,
                          controller: accountNameController,
                          validator: (val) => Validator.validateEmpty(val),
                        ),
                        SizedBox(height: responsiveData.scaleHeight(20)),
                        AppButton(
                          buttonText: 'Save bank details',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              _buildConfirmBankDetailsBottomSheet(
                                  context, updateBank);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
