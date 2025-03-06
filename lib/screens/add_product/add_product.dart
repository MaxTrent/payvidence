import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/brand_providers/current_brand_provider.dart';
import 'package:payvidence/providers/category_providers/current_category_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/repositories/repository/product_repository.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../gen/assets.gen.dart';
import '../../providers/business_providers/current_business_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/app_functions.dart';
import '../../utilities/toast_service.dart';
import '../../utilities/validators.dart';

@RoutePage(name: 'AddProductRoute')
class AddProduct extends ConsumerWidget {
  AddProduct({super.key});

  final _controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productDescController = TextEditingController();
  final productQtyController = TextEditingController();
  final productPriceController = TextEditingController();
  final vatRateController = TextEditingController();
  ValueNotifier<XFile?> productImage = ValueNotifier(null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCategory = ref.watch(getCurrentCategoryProvider);
    final currentBrand = ref.watch(getCurrentBrandProvider);

    Future<void> createProduct() async {
      FormData requestData = FormData.fromMap({
        "name": productNameController.text,
        "description": productDescController.text,
        "price": productPriceController.text,
        "quantity": productQtyController.text,
        "business_id": ref.read(getCurrentBusinessProvider)?.id,
        "brand_id": currentBrand?.id,
        "category_id": currentCategory?.id,
        "logo_image": await MultipartFile.fromFile(productImage.value!.path,
            filename: productImage.value!.path.split('/').last),
        "vat": vatRateController.text,
      });
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final Product response =
            await locator<IProductRepository>().addProduct(requestData);
        if (!context.mounted) return;
        Navigator.of(context).pop(); // pop loading dialog on success
        ToastService.success(context, "Product created successfully");
        ref.invalidate(getAllProductProvider);
        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
          //  context.router.pushAndPopUntil(const HomePageRoute(), predicate: (route)=>route.settings.name == '/');
        });
      } catch (e) {
        print(e);
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.error(context, 'An error has occurred!');
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
                  'Enter product details',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'Fill in all details carefully and correctly.',
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  'Product category',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>()
                          .navigateNamed(PayvidenceRoutes.emptyCategory);
                    },
                    child: AppTextField(
                      hintText: currentCategory == null
                          ? 'Select category'
                          : currentCategory.name!,
                      controller: _controller,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                      enabled: false,
                    )),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Product name',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                AppTextField(
                  hintText: 'Product name',
                  controller: productNameController,
                  validator: (val) {
                    return Validator.validateName(val);
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Product brand',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>()
                          .navigateNamed(PayvidenceRoutes.brands);
                    },
                    child: AppTextField(
                      hintText: currentBrand == null
                          ? 'Select brand'
                          : currentBrand.name!,
                      controller: _controller,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                      enabled: false,
                    )),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Product description',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                AppTextField(
                  //height: 128,
                  hintText: '',
                  validator: (val) {
                    return Validator.validateName(val);
                  },
                  controller: productDescController,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Product quantity',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                AppTextField(
                  hintText: 'Product quantity',
                  controller: productQtyController,
                  validator: (val) {
                    return Validator.validateEmpty(val);
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Product price',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                AppTextField(
                  hintText: 'Product price',
                  controller: productPriceController,
                  validator: (val) {
                    return Validator.validateName(val);
                  },
                  prefixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 6.w, 16.h),
                    child: Text('₦',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 14.sp)),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Product image',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                GestureDetector(
                    onTap: () async {
                      productImage.value = await AppFunctions.pickImage();
                    },
                    child: ValueListenableBuilder(
                        valueListenable: productImage,
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
                  height: 20.h,
                ),
                // Text(
                //   'Is VAT applicable to this product?',
                //   style: Theme.of(context).textTheme.displaySmall,
                // ),
                // SizedBox(
                //   height: 8.h,
                // ),
                // AppTextField(
                //   hintText: 'Select option',
                //   controller: _controller,
                //  // suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                // ),
                // SizedBox(
                //   height: 20.h,
                // ),
                Text(
                  'VAT rate',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 8.h,
                ),
                AppTextField(
                  hintText: 'VAT rate',
                  controller: vatRateController,
                  validator: (val) {
                    return Validator.validateEmpty(val);
                  },
                  //suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                ),
                SizedBox(
                  height: 32.h,
                ),
                AppButton(
                    buttonText: 'Add product',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (currentBrand == null) {
                          ToastService.error(context, "Select a brand!");
                        } else if (currentCategory == null) {
                          ToastService.error(context, "Select a category!");
                        }
                        if (productImage.value == null) {
                          ToastService.error(context, "Select a product image");
                        } else {
                          createProduct();
                        }
                      }
                      // context.go('/addBusinessSuccess');
                    }),
                SizedBox(
                  height: 12.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
