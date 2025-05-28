import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
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
    final responsiveData = ResponsiveInherited.of(context);

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
        ToastService.showSnackBar("Quantity updated successfully");
        ref.invalidate(getAllProductProvider);

        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
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

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: responsiveData.scaleHeight(16),
                    ),
                    Text(
                      'Update quantity',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    Text(
                      'You can change the quantity of products here.',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(32),
                    ),
                    Text(
                      'Available quantity ',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      enabled: false,
                      hintText: '${product.quantityAvailable} ',
                      controller: TextEditingController(),
                      // filled: true,
                      // fillColor: appGrey,
                      appBorderColor: borderColor,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Sold quantity ',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      enabled: false,
                      hintText: '${product.quantitySold} ',
                      controller: TextEditingController(),
                      // filled: true,
                      // fillColor: appGrey,
                      appBorderColor: borderColor,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Restocked quantity ',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Restocked quantity ',
                      controller: restockController,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'Enter a valid quantity';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(32),
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
      ),
    );
  }
}