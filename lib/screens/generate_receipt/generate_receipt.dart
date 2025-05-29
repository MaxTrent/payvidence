import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../constants/app_colors.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../data/network/api_response.dart';
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
  String? selectedPayment;

  bool? isDraft;

  final List<Widget> _textFields = [];

  @override
  void dispose() {
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
    // Initialize the first form field
    _textFields.add(FormFields(
      qtyController: qtyController,
      discountController: discountController,
      onPressed: selectProduct,
      index: 1,
    ));
  }

  void _addTextField() {
    // Create new TextEditingControllers
    TextEditingController qtyController = TextEditingController();
    TextEditingController discountController = TextEditingController();

    // Add the controllers to the lists
    qtyControllers.add(qtyController);
    discountControllers.add(discountController);
    // Add a new FormFields widget to the list
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
      products[index] = product;
    }

    return product;
  }

  Future<void> selectClient() async {
    final businessId = ref.watch(getCurrentBusinessProvider)?.id;
    if (businessId != null) {
      locator<SessionManager>()
          .save(key: SessionConstants.businessId, value: businessId);
    }
    ClientModel? selectedClient = await locator<PayvidenceAppRouter>()
        .push(ClientsRoute(businessId: businessId!, forSelection: true));
    await Future.delayed(const Duration(milliseconds: 100));
    if (selectedClient != null) {
      client = selectedClient;
      setState(() {});
    }
  }

  Future<dynamic> buildPaymentBottomSheet(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(326),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(responsiveData.largeRadius),
              topLeft: Radius.circular(responsiveData.largeRadius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveData.paddingHorizontal,
                vertical: responsiveData.scaleHeight(10)),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(140)),
                      child: Container(
                        height: responsiveData.scaleHeight(5),
                        width: responsiveData.scaleWidth(67),
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(responsiveData.largeRadius),
                        ),
                      ),
                    ),
                    SizedBox(height: responsiveData.scaleHeight(38)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Select Payment Method',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                              fontSize: Responsive.fontSize(context, 22),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsiveData.scaleHeight(12)),
                    Center(
                      child: Text(
                        'Choose the mode of payment for the receipt.',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    SizedBox(height: responsiveData.scaleHeight(40)),
                    ...paymentOptions.map((option) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPayment = option;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                option.replaceAll(RegExp('_'), ' '),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: Responsive.fontSize(context, 14)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> createReceipt() async {
    String error = findMissingProducts();
    if (error != '') {
      ToastService.showErrorSnackBar(error);
      return;
    }
    List<Map<String, dynamic>> productList = [];

    for (int index in products.keys) {
      final product = products[index]!;

      if (qtyControllers[index - 1].text.isEmpty) {
        ToastService.showErrorSnackBar('Enter the qty purchased for product $index');
        return; // Stops the entire function execution
      } else {
        productList.add({
          "id": product.id.toString(),
          "quantity_purchased": int.parse(qtyControllers[index - 1].text),
          "discount": discountControllers[index - 1].text.isNotEmpty
              ? double.parse(discountControllers[index - 1].text)
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
      Navigator.of(context).pop(); // pop loading dialog on success
      ToastService.showSnackBar("Receipt generated successfully");
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
      });
    } on ApiErrorResponseV2 catch (e) {
      Navigator.of(context).pop();
      String errorMessage = e.message ?? 'An unknown error has occurred!';
      ToastService.showErrorSnackBar(errorMessage);
    } catch (e, stackTrace) {
      Navigator.of(context).pop();
      ToastService.showErrorSnackBar('An unknown error has occurred!');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: responsiveData.scaleHeight(16),
                      ),
                      Text(
                        'Generate ${widget.isInvoice == true ? "invoice" : "receipt"}',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(8),
                      ),
                      Text(
                        'Fill in the details below to record new sales.',
                        style: Theme.of(context).textTheme.displaySmall!,
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(32),
                      ),
                      Text(
                        'Client name',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(8),
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
                        ),
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(20),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (ctx, idx) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: responsiveData.scaleHeight(12)),
                              Text(
                                'PRODUCT ${idx + 2} DETAILS',
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(context, 15),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: responsiveData.scaleHeight(12)),
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
                              height: responsiveData.scaleHeight(20),
                            ),
                            Text(
                              'Mode of payment',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            SizedBox(
                              height: responsiveData.scaleHeight(8),
                            ),
                            GestureDetector(
                              onTap: () {
                                buildPaymentBottomSheet(context);
                              },
                              child: AppTextField(
                                enabled: false,
                                hintText: selectedPayment?.replaceAll(RegExp('_'), ' ') ?? 'Select payment method',
                                controller: TextEditingController(),
                                suffixIcon: const Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(28),
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
                                color: primaryColor2,
                                fontSize: Responsive.fontSize(context, 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(32),
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
                                  ToastService.showErrorSnackBar("Select a client please");
                                  return;
                                }
                                isDraft = false;
                                createReceipt();
                              }
                            },
                          ),
                          SizedBox(
                            height: responsiveData.scaleHeight(26),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if (client == null) {
                                  ToastService.showErrorSnackBar("Select a client please");
                                  return;
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
                      ),
                    ],
                  ),
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
  final bool? invoiceToReceipt;

  FormFields({
    super.key,
    required this.qtyController,
    required this.discountController,
    required this.onPressed,
    required this.index,
    this.product,
    this.invoiceToReceipt = false,
  });

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product name',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: responsiveData.scaleHeight(8),
        ),
        GestureDetector(
          onTap: () async {
            if (widget.invoiceToReceipt == true) {
              return;
            }
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
          height: responsiveData.scaleHeight(20),
        ),
        Text(
          'Quantity purchased',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: responsiveData.scaleHeight(8),
        ),
        AppTextField(
          hintText: 'Quantity purchased',
          controller: widget.qtyController,
          keyboardType: TextInputType.number,
          validator: (val) {
            if (val!.trim().isEmpty) {
              return 'Enter quantity purchased';
            }
            if (int.tryParse(val)! <= 0) {
              return 'Enter a value greater than 0';
            }
            return null;
          },
          enabled: !widget.invoiceToReceipt!,
        ),
        SizedBox(
          height: responsiveData.scaleHeight(20),
        ),
        Text(
          'Discount percentage (if any)',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: responsiveData.scaleHeight(8),
        ),
        AppTextField(
          hintText: 'Discount percentage',
          controller: widget.discountController,
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(
              responsiveData.scaleWidth(16),
              responsiveData.scaleHeight(16),
              responsiveData.scaleWidth(6),
              responsiveData.scaleHeight(16),
            ),
            child: Text(
              '%',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: Responsive.fontSize(context, 14)),
            ),
          ),
          enabled: !widget.invoiceToReceipt!,
        ),
      ],
    );
  }
}