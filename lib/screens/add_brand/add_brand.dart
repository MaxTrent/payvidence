import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/model/brand_model.dart';
import 'package:payvidence/providers/brand_providers/get_all_brand_provider.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'AddBrandRoute')
class AddBrand extends ConsumerWidget {
  AddBrand({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> createBrand() async {
      Map<String, dynamic> requestData = {
        "name": nameController.text,
        "description": descController.text,
      };
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final BrandModel response =
            await ref.read(getAllBrandProvider.notifier).addBrand(requestData);
        if (!context.mounted) return;
        Navigator.of(context).pop(); //pop loading dialog on success
        ToastService.showSnackBar("Brand created successfully");
        ref.invalidate(getAllBrandProvider);
        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
          //  context.router.pushAndPopUntil(const HomePageRoute(), predicate: (route)=>route.settings.name == '/');
        });
      } on DioException catch (e) {
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.showErrorSnackBar(
            e.response?.data['message'] ?? 'An unknown error has occurred!!!');
      } catch (e) {
        Navigator.of(context).pop(); //pop loading dialog on error
        ToastService.showErrorSnackBar('An error has occurred!');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.h,
              ),
              Text(
                'Add new brand',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'Fill in the details below to add a new brand.',
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
              Text(
                'Brand name',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                hintText: 'Brand name',
                controller: nameController,
                validator: (val) => Validator.validateName(val),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Brand description',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                height: 128,
                hintText: 'Brand description',
                controller: descController,
                validator: (val) => Validator.validateName(val),
              ),
              SizedBox(
                height: 32.h,
              ),
              AppButton(
                  buttonText: 'Save brand',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      createBrand();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
