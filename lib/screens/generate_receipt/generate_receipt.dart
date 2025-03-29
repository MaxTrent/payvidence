import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/utilities/toast_service.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../constants/app_colors.dart';
import '../../model/product_model.dart';
import '../../providers/business_providers/current_business_provider.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'GenerateReceiptRoute')
class GenerateReceipt extends ConsumerStatefulWidget {
  final bool? isInvoice;

  const GenerateReceipt({super.key, this.isInvoice = false});

  @override
  ConsumerState<GenerateReceipt> createState() => _GenerateReceiptState();
}

class _GenerateReceiptState extends ConsumerState<GenerateReceipt> {
  final qtyController = TextEditingController();
  final discountController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController> discountControllers = [];
  List<TextEditingController> qtyControllers = [];
  Map<int, Product> products = {};
  ClientModel? client;
  final List<String> paymentOptions = [
    'Bank_Transfer',
    'Cash',
    'Cheque',
    'POS',
  ];
  String? selectedPayment; // Holds the selected payment method

  bool? isDraft;

  // List to store TextField widgets
  final List<Widget> _textFields = [];

  @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    for (var controller in qtyControllers) {
      controller.dispose();
    }
    for (var controller in discountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    qtyControllers.add(qtyController);
    discountControllers.add(discountController);
    // Dispose all controllers to avoid memory leaks
    _textFields.add(FormFields(
      qtyController: qtyController,
      discountController: discountController,
      onPressed: selectProduct,
      index: 1,
    ));
  }

  void _addTextField() {
    // Create a new TextEditingController
    TextEditingController qtyController = TextEditingController();
    TextEditingController discountController = TextEditingController();

    // Add the controller to the list
    qtyControllers.add(qtyController);
    discountControllers.add(discountController);
    // Add a new TextField widget to the list
    setState(() {
      _textFields.add(FormFields(
        discountController: discountControllers.last,
        qtyController: qtyControllers.last,
        onPressed: selectProduct,
        index: _textFields.length + 1,
      ));
    });
  }

  Future<Product?> selectProduct(int index) async {
    final Product? product = await locator<PayvidenceAppRouter>()
        .push(ProductRoute(forProductSelection: true));
    await Future.delayed(const Duration(milliseconds: 100));
    if (product != null) {
      if (products.values.contains(product) == true) {
        ToastService.info(context, 'Product has been selected before');
        return null;
      }
      // if(products){
      //
      // }
      products[index] = product;
    }

    return product;
  }

  Future<void> selectClient() async {
    final ClientModel? _client = await locator<PayvidenceAppRouter>()
        .push(ClientsRoute(forSelection: true));
    await Future.delayed(const Duration(milliseconds: 100));
    if (_client != null) {
      client = _client;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String findMissingProducts() {
      List<int> productIndexes = products.keys.toList();
      List<int> missingIndexes = [];

      for (int i = 0; i < qtyControllers.length; i++) {
        if (!productIndexes.contains(i + 1)) {
          missingIndexes.add(i + 1);
        }
      }

      if (missingIndexes.isNotEmpty) {
        return "Missing product ${missingIndexes[0]} name";
      } else {
        return "";
      }
    }

    Future<void> createReceipt() async {
      String error = findMissingProducts();
      if (error == '') {
      } else {
        ToastService.error(context, error);
        return;
      }
      List<Map<String, dynamic>> productList = [];

      for (int index in products.keys) {
        final product = products[index]!;

        if (qtyControllers[index - 1].text.isEmpty) {
          ToastService.error(
              context, 'Enter the qty purchased for product $index');
          return; // Stops the entire function execution
        } else {
          productList.add({
            "id": product.id,
            "quantity_purchased":
                int.tryParse(qtyControllers[index - 1].text) ?? 0,
            "discount": discountControllers[index - 1].text.isNotEmpty
                ? double.tryParse(discountControllers[index - 1].text)
                : null,
          });
        }
      }
      Map<String, dynamic> requestData = {
        "products": productList,
        "record_type": widget.isInvoice == true ? "invoice" : "receipt",
        "business_id": ref.read(getCurrentBusinessProvider)!.id!,
        "client_id": client?.id,
        "is_draft": isDraft,
        "mode_of_payment":
            widget.isInvoice == true ? null : selectedPayment?.toLowerCase()
      };
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final Receipt response = await ref
            .read(getAllReceiptProvider.notifier)
            .addReceipt(requestData);
        if (!context.mounted) return;
        Navigator.of(context).pop(); //pop loading dialog on success
        ToastService.success(context, "Receipt generated successfully");
        ref.invalidate(widget.isInvoice == true
            ? getAllInvoiceProvider
            : getAllReceiptProvider);
        Future.delayed(const Duration(seconds: 2), () {
          if (ref.read(getCurrentBusinessProvider)?.accountNumber == null) {
            if (!context.mounted) return;

            Navigator.of(context).pop();
            locator<PayvidenceAppRouter>().navigate(UpdateBankDetailsRoute());
          } else {
            Navigator.of(context).pop();
          }

          //  context.router.pushAndPopUntil(const HomePageRoute(), predicate: (route)=>route.settings.name == '/');
        });
      } on DioException catch (e) {
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.error(context,
            e.response?.data['message'] ?? 'An unknown error has occurred!!!');
      } catch (e) {
        print(e);
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.error(context, 'An unknown error has occurred!');
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                      'Generate ${widget.isInvoice == true ? "invoice" : "receipt"}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'Fill in the details below to record new sales.',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Text(
                      'Client name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    GestureDetector(
                        onTap: () {
                          selectClient();
                        },
                        child: AppTextField(
                          enabled: false,
                          hintText: client?.name ?? 'Select client',
                          controller: TextEditingController(),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                        )),
                    SizedBox(
                      height: 20.h,
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (ctx, idx) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            12.verticalSpace,
                            Text(
                              'PRODUCT ${idx + 2} DETAILS',
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.w500),
                            ),
                            12.verticalSpace
                          ],
                        );
                      },
                      itemBuilder: (context, index) {
                        return _textFields[index];
                      },
                      shrinkWrap: true,
                      itemCount: _textFields.length,
                    ),
                    Visibility(
                      visible: widget.isInvoice == false,
                      replacement: const SizedBox(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            'Mode of payment',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          DropdownButtonFormField<String>(
                            hint: const Text("Mode of payment"),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12.w),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                            ),
                            value: selectedPayment,
                            items: paymentOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child:
                                    Text(option.replaceAll(RegExp('_'), " ")),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedPayment = value;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select a payment method'
                                : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        _addTextField();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.add,
                            color: primaryColor2,
                          ),
                          Text(
                            'Add another product',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: primaryColor2, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppButton(
                          buttonText: 'Generate',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (client == null) {
                                ToastService.error(
                                    context, "Select a client please");
                              }
                              isDraft = false;
                              createReceipt();
                            } // context.push(AppRoutes.receipt);
                          },
                        ),
                        SizedBox(
                          height: 26.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (client == null) {
                                ToastService.error(
                                    context, "Select a client please");
                              }
                              isDraft = true;
                              createReceipt();
                            }
                          },
                          child: Text(
                            'Save as draft',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: primaryColor2),
                          ),
                        ),
                      ],
                    )
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

class FormFields extends StatefulWidget {
  final TextEditingController qtyController;
  final TextEditingController discountController;
  final Future<Product?> Function(int index) onPressed;
  final int index;
  Product? product;

  FormFields(
      {super.key,
      required this.qtyController,
      required this.discountController,
      required this.onPressed,
      required this.index,
      this.product});

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product name',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: 8.h,
        ),
        GestureDetector(
          onTap: () async {
            final Product? result = await widget.onPressed.call(widget.index);
            if (result == null) {
            } else {
              widget.product = result;
              setState(() {});
            }
          },
          child: AppTextField(
            hintText: widget.product == null
                ? "Select product"
                : widget.product!.name!,
            enabled: false,
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
            controller: TextEditingController(),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          'Quantity purchased',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: 8.h,
        ),
        AppTextField(
          hintText: 'Quantity purchased',
          controller: widget.qtyController,
          keyboardType: TextInputType.number,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Enter quantity purchased';
            }
            if (int.tryParse(val)! <= 0) {
              return 'Enter a value greater than 0';
            }
            return null;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          'Discount percentage (if any)',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: 8.h,
        ),
        AppTextField(
          hintText: 'Discount percentage',
          controller: widget.discountController,
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 6.w, 16.h),
            child: Text('%',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 14.sp)),
          ),
        ),
      ],
    );
  }
}
