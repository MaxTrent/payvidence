import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/model/category_model.dart';
import 'package:payvidence/providers/category_providers/get_all_category_provider.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'AddCategoryRoute')
class AddCategory extends ConsumerWidget {
  AddCategory({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> createCategory() async {
      Map<String, dynamic> requestData = {
        "name": nameController.text,
        "description": descController.text,
      };
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final CategoryModel response = await ref
            .read(getAllCategoryProvider.notifier)
            .addCategory(requestData);
        if (!context.mounted) return;
        Navigator.of(context).pop(); //pop loading dialog on success
        ToastService.showSnackBar("Category created successfully");
        ref.invalidate(getAllCategoryProvider);
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
        print(e);
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.showErrorSnackBar('An unknown error has occurred!');
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
                'Add new category',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'Fill in the details below to add a new category.',
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
              Text(
                'Category name',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                hintText: 'Category name',
                controller: nameController,
                validator: (val) => Validator.validateName(val),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Category description',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                height: 128,
                hintText: 'Category description',
                controller: descController,
                validator: (val) => Validator.validateName(val),
              ),
              SizedBox(
                height: 32.h,
              ),
              AppButton(
                  buttonText: 'Save category',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      createCategory();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
