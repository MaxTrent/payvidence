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
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
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
class AddProduct extends ConsumerStatefulWidget {
  final Product? product;

  const AddProduct({super.key, this.product});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final _controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final productNameController = TextEditingController();

  final productDescController = TextEditingController();

  final productQtyController = TextEditingController();

  final productPriceController = TextEditingController();

  final vatRateController = TextEditingController();

  ValueNotifier<XFile?> productImage = ValueNotifier(null);

  @override
  void initState() {
    // TODO: implement initState
    if (widget.product != null) {
      productNameController.text = widget.product?.name ?? '';
      productDescController.text = widget.product?.description ?? '';
      productQtyController.text =
          widget.product?.quantityAvailable.toString() ?? '';
      productPriceController.text = widget.product?.price ?? '';
      vatRateController.text = widget.product?.vat ?? '';
      Future.delayed(const Duration(milliseconds: 200), () {
        ref
            .read(getCurrentCategoryProvider.notifier)
            .setCurrentCategory(widget.product!.category!);
        ref
            .read(getCurrentBrandProvider.notifier)
            .setCurrentBrand(widget.product!.brand!);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = ref.watch(getCurrentCategoryProvider);
    final currentBrand = ref.watch(getCurrentBrandProvider);

    Future<void> createProduct() async {
      Map<String, dynamic> data = {
        "name": productNameController.text,
        "description": productDescController.text,
        "price": productPriceController.text,
        "quantity": productQtyController.text,
        "brand_id": currentBrand?.id,
        "category_id": currentCategory?.id,
      };
      if (widget.product == null) {
        //if it is for create product and not update
        data.addAll({
          "logo_image": await MultipartFile.fromFile(productImage.value!.path,
              filename: productImage.value!.path.split('/').last),
          "business_id": ref.read(getCurrentBusinessProvider)?.id,
          "vat": vatRateController.text,
        });
      } else {
        data.addAll({"_method": "PATCH"});
        // data.addAll({ "logo_image": await MultipartFile.fromFile(productImage.value!.path,
        //     filename: productImage.value!
        //         .path
        //         .split('/')
        //         .last),});
      }
      FormData requestData = FormData.fromMap(data);

      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final Product response;
        if (widget.product == null) {
          //if it is for create product and not update
          response =
              await locator<IProductRepository>().addProduct(requestData);
        } else {
          response = await ref
              .read(getAllProductProvider.notifier)
              .updateProduct(requestData, widget.product?.id ?? '');
        }

        if (!context.mounted) return;
        Navigator.of(context).pop(); // pop loading dialog on success
        ToastService.showSnackBar(widget.product == null
            ? "Product created successfully"
            : "Product updated successfully");
        ref.invalidate(getAllProductProvider);
        if (widget.product != null) {
          ref
              .read(getCurrentProductProvider.notifier)
              .setCurrentProduct(response);
        }
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
        ToastService.showErrorSnackBar('An error has occurred!');
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
                            return Visibility(
                                visible: widget.product == null,
                                replacement: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.5),
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                widget.product?.logoUrl ??
                                                    ''))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(12),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            "Change",
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    )),
                                child:
                                    SvgPicture.asset(Assets.svg.uploadImage));
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
                                    Container(
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        "Change",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
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
                    buttonText: widget.product == null
                        ? 'Add product'
                        : 'Update details',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (currentBrand == null) {
                          ToastService.showErrorSnackBar("Select a brand!");
                        } else if (currentCategory == null) {
                          ToastService.showErrorSnackBar("Select a category!");
                        }
                        if (productImage.value == null &&
                            widget.product == null) {
                          ToastService.showErrorSnackBar("Select a product image");
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
