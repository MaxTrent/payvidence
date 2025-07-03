import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/model/brand_model.dart';
import 'package:payvidence/providers/brand_providers/get_all_brand_provider.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../data/network/api_response.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'AddBrandRoute')
class AddBrand extends ConsumerWidget {
  AddBrand({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);

    Future<void> createBrand() async {
      Map<String, dynamic> requestData = {
        "name": nameController.text,
        "description": descController.text.trim().isNotEmpty ? descController.text : null,
      };

      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final BrandModel response =
        await ref.read(getAllBrandProvider.notifier).addBrand(requestData);
        if (!context.mounted) return;
        Navigator.of(context).pop();
        ToastService.showSnackBar("Brand created successfully");
        ref.invalidate(getAllBrandProvider);
        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
        });
      } on ApiErrorResponseV2 catch (e) {
        Navigator.of(context).pop();
        String errorMessage = e.message ?? 'An unknown error has occurred!';
        ToastService.showErrorSnackBar(errorMessage);
      } on DioException catch (e) {
        Navigator.of(context).pop();
        ToastService.showErrorSnackBar(
            e.response?.data['message'] ?? 'An unknown error has occurred!!!');
      } catch (e) {
        Navigator.of(context).pop();
        ToastService.showErrorSnackBar('An error has occurred!');
      }
    }

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: responsiveData.scaleHeight(16),
                ),
                Text(
                  'Add new brand',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(8),
                ),
                Text(
                  'Fill in the details below to add a new brand.',
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(32),
                ),
                Text(
                  'Brand name',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(8),
                ),
                AppTextField(
                  hintText: 'Brand name',
                  controller: nameController,
                  validator: (val) => Validator.validateName(val),
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(20),
                ),
                Text(
                  'Brand description',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(8),
                ),
                AppTextField(
                  height: 128,
                  hintText: 'Brand description',
                  controller: descController,
                  validator: (val) =>
                  val?.trim().isEmpty == true ? null : Validator.validateName(val),
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(32),
                ),
                AppButton(
                  buttonText: 'Save brand',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      createBrand();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}