import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/app_button.dart';
import '../../components/app_drop_down.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../constants/app_colors.dart';
import '../../model/client_model.dart';
import '../../model/product_model.dart';
import '../../providers/business_providers/current_business_provider.dart';
import '../../providers/receipt_providers/get_all_invoice_provider.dart';
import '../../providers/receipt_providers/get_all_receipt_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/toast_service.dart';
import '../generate_receipt/generate_receipt.dart';

@RoutePage(name: 'CompleteDraftRoute')
class CompleteDraft extends ConsumerStatefulWidget {
  final bool? isInvoice;
  final Receipt draft;
  final bool? inVoiceToReceipt;

  const CompleteDraft(
      {super.key,
        required this.draft,
        this.isInvoice = false,
        this.inVoiceToReceipt = false});

  @override
  ConsumerState<CompleteDraft> createState() => _CompleteDraftState();
}

class _CompleteDraftState extends ConsumerState<CompleteDraft> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<int, Product> products = {};
  ClientModel? client;
  List<TextEditingController> discountControllers = [];
  List<TextEditingController> qtyControllers = [];
  final _controller = TextEditingController();
  int productIndex = 0;
  final List<Widget> _textFields = [];
  final List<String> paymentOptions = [
    'bank_transfer',
    'cash',
    'cheque',
    'pos',
  ];
  String? selectedPayment; // Holds the selected payment method
  bool? isDraft;

  void _addTextField(String? qty, String? discount, Product? product) {
    // Create a new TextEditingController
    TextEditingController qtyController = TextEditingController();
    TextEditingController discountController = TextEditingController();

    if (qty != null) {
      qtyController.text = qty;
    }
    if (discount != null) {
      discountController.text = discount;
    }
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
        product: product,
        invoiceToReceipt: widget.inVoiceToReceipt,
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
      products[index] = product;
    }

    return product;
  }

  Future<void> selectClient() async {
    ClientModel? client = await locator<PayvidenceAppRouter>()
        .push(ClientsRoute(forSelection: true));
    await Future.delayed(const Duration(milliseconds: 100));
    if (client != null) {
      client = client;
      setState(() {});
    }
  }

  Future<void> createReceipt() async {
    List<Map<String, dynamic>> productList = [];

    for (var index = 0; index < products.length; index++) {
      final product = products[index]!;

      productList.add({
        "id": product.id,
        "quantity_purchased": int.tryParse(qtyControllers[index].text) ?? 0,
        "discount": discountControllers[index].text.isNotEmpty
            ? double.tryParse(discountControllers[index].text)
            : null,
      });
    }
    Map<String, dynamic> requestData = {
      "products": productList,
      "record_type": widget.inVoiceToReceipt == true
          ? "receipt"
          : (widget.isInvoice == true && widget.inVoiceToReceipt == false)
          ? "invoice"
          : "receipt",
      "business_id": ref.read(getCurrentBusinessProvider)!.id!,
      "client_id": client?.id,
      "mode_of_payment": selectedPayment?.toLowerCase()
    };
    if (!context.mounted) return;
    LoadingDialog.show(context);
    try {
      if (widget.inVoiceToReceipt == true) {
        final Receipt response =
        await ref.read(getAllReceiptProvider.notifier).reIssueReceipt(
          widget.draft.id!,
          {"mode_of_payment": selectedPayment?.toLowerCase()},
        );
      } else {
        final Receipt response = await ref
            .read(getAllReceiptProvider.notifier)
            .updateReceipt(widget.draft.id!, requestData, !isDraft!);
      }

      if (!context.mounted) return;
      Navigator.of(context).pop(); //pop loading dialog on success
      ToastService.showSnackBar(
          "${(widget.isInvoice == true && widget.inVoiceToReceipt == false) ? "invoice" : "receipt"} generated successfully");
      ref.invalidate(
          widget.isInvoice == true && widget.inVoiceToReceipt == false
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

  @override
  void initState() {
    super.initState();
    for (var product in widget.draft.recordProductDetails!) {
      products[productIndex] = product.product!;
      productIndex += 1;
      _addTextField(product.quantity.toString(), product.discount?.toString(),
          product.product!);
    }
    if (paymentOptions.contains(widget.draft.modeOfPayment)) {
      selectedPayment = widget.draft.modeOfPayment;
    } else {
      log(widget.draft.modeOfPayment.toString());
    }
    client = widget.draft.client;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                      widget.inVoiceToReceipt == true
                          ? "Re-issue to receipt"
                          : widget.isInvoice == true
                          ? "Complete invoice"
                          : "Complete receipt",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'Fill in the details below to generate ${widget.isInvoice == true ? "invoice" : "receipt"}',
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
                          if (widget.inVoiceToReceipt == true) {
                            return;
                          }
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
                      visible: (widget.isInvoice == false &&
                          widget.inVoiceToReceipt == false) ||
                          widget.inVoiceToReceipt == true,
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
                          AppDropdown<String>(
                            hintText: "Mode of payment",
                            items: paymentOptions,
                            value: selectedPayment,
                            displayText: (option) => option.replaceAll(RegExp('_'), " ").capitalize(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedPayment = value;
                              });
                            },
                            validator: (value) => value == null ? 'Please select a payment method' : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppButton(
                          buttonText:
                          'Generate ${widget.isInvoice == true && widget.inVoiceToReceipt == false ? "invoice" : "receipt"}',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (client == null) {
                                ToastService.showErrorSnackBar("Select a client please");
                              }
                              isDraft = false;
                              createReceipt();
                            }
                          },
                        ),
                        SizedBox(
                          height: 26.h,
                        ),
                        Visibility(
                          visible: widget.inVoiceToReceipt == false,
                          child: GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if (client == null) {
                                  ToastService.showErrorSnackBar("Select a client please");
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