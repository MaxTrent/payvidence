import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/components/app_naira.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/brand_providers/current_brand_provider.dart';
import 'package:payvidence/providers/category_providers/current_category_provider.dart';
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/repositories/repository/product_repository.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../data/network/api_response.dart';
import '../../gen/assets.gen.dart';
import '../../providers/business_providers/current_business_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/app_functions.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/toast_service.dart';
import '../../utilities/validators.dart';
import '../../utilities/number_formatter.dart';
import '../../utilities/real_time_number_formatter.dart';

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
    super.initState();
    if (widget.product != null) {
      productNameController.text = widget.product?.name ?? '';
      productDescController.text = widget.product?.description ?? '';
      productQtyController.text = widget.product?.quantityAvailable.toString() ?? '';
      // Format price with commas manually
      final price = widget.product?.price ?? '0';
      final numPrice = double.tryParse(price) ?? 0;
      final formattedPrice = numPrice.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
      productPriceController.text = formattedPrice;
      vatRateController.text = widget.product?.vat ?? '';
      Future.delayed(const Duration(milliseconds: 200), () {
        ref.read(getCurrentCategoryProvider.notifier).setCurrentCategory(widget.product!.category!);
        ref.read(getCurrentBrandProvider.notifier).setCurrentBrand(widget.product?.brand);
      });
    } else {
      // Clear providers for new product
      Future.delayed(const Duration(milliseconds: 200), () {
        ref.read(getCurrentCategoryProvider.notifier).clearCategory();
        ref.read(getCurrentBrandProvider.notifier).clearBrand();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = ref.watch(getCurrentCategoryProvider);
    final currentBrand = ref.watch(getCurrentBrandProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsiveData = ResponsiveInherited.of(context);

    Future<void> createProduct() async {
      Map<String, dynamic> data = {};
      
      if (widget.product == null) {
        // Creating new product - send all fields
        String categoryId = currentCategory?.id ?? "0";
        data = {
          "name": productNameController.text,
          "description": productDescController.text.isEmpty ? "No description" : productDescController.text,
          "price": productPriceController.text.replaceAll(',', ''),
          "quantity": productQtyController.text,
          "category_id": categoryId,
          "logo_image": await MultipartFile.fromFile(productImage.value!.path,
              filename: productImage.value!.path.split('/').last),
          "business_id": ref.read(getCurrentBusinessProvider)?.id,
        };
        if (currentBrand != null) {
          data.addAll({"brand_id": currentBrand.id});
        } else {
          data.addAll({"brand_id": "0"});
        }
        if (vatRateController.text.isNotEmpty) {
          data["vat"] = vatRateController.text;
        }
      } else {
        // Updating existing product - only send changed fields
        data.addAll({"_method": "PATCH"});
        
        // Only add fields that have changed
        if (productNameController.text != (widget.product?.name ?? '')) {
          data["name"] = productNameController.text;
        }
        if ((productDescController.text.isEmpty ? "No description" : productDescController.text) != (widget.product?.description ?? '')) {
          data["description"] = productDescController.text.isEmpty ? "No description" : productDescController.text;
        }
        final cleanPrice = productPriceController.text.replaceAll(',', '');
        if (cleanPrice != (widget.product?.price ?? '')) {
          data["price"] = cleanPrice;
        }
        if (productQtyController.text != (widget.product?.quantityAvailable.toString() ?? '')) {
          data["quantity"] = productQtyController.text;
        }
        if (vatRateController.text != (widget.product?.vat ?? '')) {
          data["vat"] = vatRateController.text;
        }
        if (currentCategory?.id != widget.product?.category?.id) {
          data["category_id"] = currentCategory?.id ?? "0";
        }
        if (currentBrand?.id != widget.product?.brand?.id) {
          data["brand_id"] = currentBrand?.id ?? "0";
        }
        if (productImage.value != null) {
          data["logo_image"] = await MultipartFile.fromFile(productImage.value!.path,
              filename: productImage.value!.path.split('/').last);
        }
      }
      FormData requestData = FormData.fromMap(data);

      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final Product response;
        if (widget.product == null) {
          response = await locator<IProductRepository>().addProduct(requestData);
        } else {
          response = await ref
              .read(getAllProductProvider.notifier)
              .updateProduct(requestData, widget.product?.id ?? '');
        }

        if (!context.mounted) return;
        Navigator.of(context).pop();
        ToastService.showSnackBar(widget.product == null
            ? "Product created successfully"
            : "Product updated successfully");
        ref.invalidate(getAllProductProvider);
        if (widget.product != null) {
          ref.read(getCurrentProductProvider.notifier).setCurrentProduct(response);
        }
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
        print(e);
        Navigator.of(context).pop();
        ToastService.showErrorSnackBar('An error has occurred!');
      }
    }

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: KeyboardDismissibleScaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: ListView(
                children: [
                  Text(
                    'Enter product details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  Text(
                    'Fill in all details carefully and correctly.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(32)),
                  Text(
                    'Product category',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>()
                          .navigateNamed(PayvidenceRoutes.emptyCategory);
                    },
                    child: AppTextField(
                      hintText: currentCategory == null ? 'Select category' : currentCategory.name!,
                      controller: _controller,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: responsiveData.scaleHeight(20)),
                  Text(
                    'Product name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  AppTextField(
                    hintText: 'Product name',
                    controller: productNameController,
                    validator: (val) {
                      return Validator.validateName(val);
                    },
                  ),
                  SizedBox(height: responsiveData.scaleHeight(20)),
                  Text(
                    'Product brand',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.brands);
                    },
                    child: AppTextField(
                      hintText: currentBrand == null ? 'Select brand' : currentBrand.name!,
                      controller: _controller,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: responsiveData.scaleHeight(20)),
                  Text(
                    'Product description',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  AppTextField(
                    hintText: 'Product description',
                    validator: (val) => val != null && val.trim().isNotEmpty ? Validator.validateName(val) : null, // Allow empty
                    controller: productDescController,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(20)),
                  Text(
                    'Product quantity',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  AppTextField(
                    hintText: 'Product quantity',
                    controller: productQtyController,
                    enabled: widget.product == null,
                    validator: (val) {
                      return Validator.validateEmpty(val);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: responsiveData.scaleHeight(20)),
                  Text(
                    'Product price',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  AppTextField(
                    hintText: 'Product price',
                    controller: productPriceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(15),
                      RealTimeNumberFormatter(),
                    ],
                    validator: (val) {
                      if (val?.trim().isEmpty ?? true) {
                        return 'Please enter product price';
                      }
                      final cleanPrice = val!.replaceAll(',', '');
                      if (double.tryParse(cleanPrice) == null || double.parse(cleanPrice) <= 0) {
                        return 'Enter a valid price greater than 0';
                      }
                      return null;
                    },
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(
                          responsiveData.scaleWidth(16),
                          responsiveData.scaleHeight(16),
                          responsiveData.scaleWidth(6),
                          responsiveData.scaleHeight(16)),
                      child: AppNaira(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: responsiveData.scaleHeight(20)),
                  Text(
                    'Product image',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  GestureDetector(
                    onTap: () async {
                      productImage.value = await AppFunctions.pickImage();
                    },
                    child: ValueListenableBuilder(
                      valueListenable: productImage,
                      builder: (context, val, _) {
                        if (val == null) {
                          if (widget.product != null && widget.product?.logoUrl != null) {
                            return Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Image.network(
                                    widget.product!.logoUrl!,
                                    height: responsiveData.scaleHeight(200),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        SvgPicture.asset(Assets.svg.uploadImage),
                                  ),
                                ),
                                Positioned(
                                  bottom: responsiveData.scaleHeight(8),
                                  right: responsiveData.scaleWidth(8),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: responsiveData.scaleWidth(8),
                                        vertical: responsiveData.scaleHeight(8)),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(responsiveData.smallRadius),
                                      color: Colors.grey,
                                    ),
                                    child: const Text(
                                      "Tap to Change",
                                      style: TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return SvgPicture.asset(Assets.svg.uploadImage);
                        }
                        return Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Image.file(
                                File(val.path),
                                height: responsiveData.scaleHeight(200),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: responsiveData.scaleHeight(8),
                              right: responsiveData.scaleWidth(8),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: responsiveData.scaleWidth(8),
                                    vertical: responsiveData.scaleHeight(8)),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(responsiveData.smallRadius),
                                  color: Colors.grey,
                                ),
                                child: const Text(
                                  "Tap to Change",
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: responsiveData.scaleHeight(20)),
                  Text(
                    'VAT rate',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  AppTextField(
                    hintText: 'VAT rate',
                    controller: vatRateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (val) => null, // VAT is optional
                  ),
                  SizedBox(height: responsiveData.scaleHeight(32)),
                  AppButton(
                    buttonText: widget.product == null ? 'Add product' : 'Update details',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        // if (currentCategory == null) {
                        //   ToastService.showErrorSnackBar("Select a category!");
                        // }
                         if (productImage.value == null && widget.product == null) {
                          ToastService.showErrorSnackBar("Select a product image");
                        } else {
                          createProduct();
                        }
                      }
                    },
                  ),
                  SizedBox(height: responsiveData.scaleHeight(12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}