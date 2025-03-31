import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/providers/product_providers/current_product_provider.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../constants/app_colors.dart';
import '../../model/product_model.dart';
import '../../providers/product_providers/get_all_product_provider.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'UpdateQuantityRoute')
class UpdateQuantity extends ConsumerWidget {
  final Product product;

  UpdateQuantity({super.key, required this.product});

  final restockController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> restockProduct() async {
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final Product newProduct = await ref
            .read(getAllProductProvider.notifier)
            .restockProduct(
                product.id ?? '', int.tryParse(restockController.text) ?? 0);
        await Future.delayed(const Duration(milliseconds: 100));
        ref
            .read(getCurrentProductProvider.notifier)
            .setCurrentProduct(newProduct);
        if (!context.mounted) return;
        Navigator.of(context).pop(); //pop loading dialog on success
        ToastService.success("Quantity updated successfully");
        ref.invalidate(getAllProductProvider);

        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
        });
      } on DioException catch (e) {
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.error(
            e.response?.data['message'] ?? 'An unknown error has occurred!!!');
      } catch (e) {
        print(e);
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.error('An unknown error has occurred!');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Update quantity',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'You can change the quantity of products here.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'Available quantity ',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    enabled: false,
                    hintText: '${product.quantityAvailable} ',
                    controller: TextEditingController(),
                    filled: true,
                    fillColor: appGrey,
                    appBorderColor: borderColor,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Sold quantity ',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    enabled: false,
                    hintText: '${product.quantitySold} ',
                    controller: TextEditingController(),
                    filled: true,
                    fillColor: appGrey,
                    appBorderColor: borderColor,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Restocked quantity ',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Restocked quantity ',
                    controller: restockController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter a valid quantity';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  AppButton(
                    buttonText: 'Update record',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        restockProduct();
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
