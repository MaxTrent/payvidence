import 'dart:async';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:flutter/services.dart';
import 'package:payvidence/providers/client_providers/get_all_client_provider.dart';
import '../../data/network/api_response.dart';
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
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/toast_service.dart';
import '../generate_receipt/generate_receipt.dart';

@RoutePage(name: 'CompleteDraftRoute')
class CompleteDraft extends ConsumerStatefulWidget {
  final bool? isInvoice;
  final Receipt draft;
  final bool? inVoiceToReceipt;

  const CompleteDraft({
    super.key,
    required this.draft,
    this.isInvoice = false,
    this.inVoiceToReceipt = false,
  });

  @override
  ConsumerState<CompleteDraft> createState() => _CompleteDraftState();
}

class _CompleteDraftState extends ConsumerState<CompleteDraft> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<int, Product> products = {};
  ClientModel? client;
  List<TextEditingController> discountControllers = [];
  List<TextEditingController> qtyControllers = [];
  List<TextEditingController> productNameControllers = [];
  List<TextEditingController> productPriceControllers = [];
  final clientNameController = TextEditingController();
  final _layerLink = LayerLink();
  int productIndex = 0;
  final List<Widget> _textFields = [];
  
  // For client search functionality
  List<ClientModel> filteredClients = [];
  bool showClientDropdown = false;
  final FocusNode clientNameFocusNode = FocusNode();
  OverlayEntry? overlayEntry;
  final List<String> paymentOptions = [
    'bank_transfer',
    'cash',
    'cheque',
    'pos',
  ];
  String? selectedPayment;
  bool? isDraft;

  @override
  void dispose() {
    clientNameController.dispose();
    clientNameFocusNode.dispose();
    overlayEntry?.remove();
    super.dispose();
  }

  void _addTextField(String? qty, String? discount, Product? product) {
    TextEditingController qtyController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    TextEditingController productNameController = TextEditingController();
    TextEditingController productPriceController = TextEditingController();

    if (qty != null) {
      qtyController.text = qty;
    }
    if (discount != null) {
      discountController.text = discount;
    }
    if (product != null) {
      productNameController.text = product.name ?? '';
      final price = product.price ?? '0';
      final numPrice = double.tryParse(price) ?? 0;
      final formattedPrice = numPrice.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
      productPriceController.text = formattedPrice;
    }
    
    qtyControllers.add(qtyController);
    discountControllers.add(discountController);
    productNameControllers.add(productNameController);
    productPriceControllers.add(productPriceController);
    
    setState(() {
      _textFields.add(FormFields(
        key: ValueKey('form_field_${_textFields.length}'),
        qtyController: qtyControllers.last,
        discountController: discountControllers.last,
        productNameController: productNameControllers.last,
        productPriceController: productPriceControllers.last,
        onPressed: selectProduct,
        index: _textFields.length + 1,
        product: product,
        invoiceToReceipt: true,
        productNameEditable: true,
        productPriceEditable: false,
        onRemove: null,
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
      this.client = client;
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
      "client_id": client?.id ?? (clientNameController.text.trim().isNotEmpty ? null : null),
      "client_name": clientNameController.text.trim().isNotEmpty ? clientNameController.text.trim() : null,
      "mode_of_payment": selectedPayment?.toLowerCase()
    };
    
    if (!context.mounted) return;
    LoadingDialog.show(context);
    
    try {
      if (widget.inVoiceToReceipt == true) {
        await ref.read(getAllReceiptProvider.notifier).reIssueReceipt(
          widget.draft.id!,
          {"mode_of_payment": selectedPayment?.toLowerCase()},
        );
      } else {
        await ref.read(getAllReceiptProvider.notifier)
            .updateReceipt(widget.draft.id!, requestData, !isDraft!);
      }

      if (!context.mounted) return;
      Navigator.of(context).pop();
      ToastService.showSnackBar(
          isDraft == true ? "Draft saved successfully" : "${(widget.isInvoice == true && widget.inVoiceToReceipt == false) ? "invoice" : "receipt"} generated successfully");
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
    } on ApiErrorResponseV2 catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      String errorMessage = e.message ?? 'An unknown error has occurred!';
      
      // Handle specific error types with user-friendly messages
      if (errorMessage.contains('not enough stock')) {
        errorMessage = 'Not enough stock available for this product. Please check quantity.';
      } else if (errorMessage.contains('timeout')) {
        errorMessage = 'Connection is slow. Please try again.';
      } else if (errorMessage.contains('unauthorized')) {
        errorMessage = 'Session expired. Please log in again.';
      } else if (errorMessage.startsWith('ApiErrorResponseV2(')) {
        // Extract just the meaningful part from complex error messages
        final match = RegExp(r'not enough stock.*?Available: (\d+)').firstMatch(errorMessage);
        if (match != null) {
          errorMessage = 'Not enough stock available. Only ${match.group(1)} units left.';
        } else {
          errorMessage = 'Something went wrong. Please try again.';
        }
      }
      
      ToastService.showErrorSnackBar(errorMessage);
    } catch (e, stackTrace) {
      if (context.mounted) Navigator.of(context).pop();
      ToastService.showErrorSnackBar('An unknown error has occurred!');
    }
  }

  void _onClientNameChanged() {
    final query = clientNameController.text.trim();
    if (query.isEmpty) {
      setState(() {
        filteredClients.clear();
        showClientDropdown = false;
      });
      _hideOverlay();
      return;
    }

    final allClients = ref.read(getAllClientsProvider).value ?? [];
    final filtered = allClients
        .where((client) =>
        client.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredClients = filtered;
      showClientDropdown = filtered.isNotEmpty;
    });

    if (filtered.isNotEmpty) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _onClientNameFocusChanged() {
    if (!clientNameFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 150), () {
        _hideOverlay();
      });
    }
  }
  
  void _showOverlay() {
    _hideOverlay();

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: ResponsiveInherited.of(context).paddingHorizontal,
              right: ResponsiveInherited.of(context).paddingHorizontal,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 60),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          title: Text(
                            client.name,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          subtitle: client.address.isNotEmpty || client.phoneNumber.isNotEmpty
                              ? Text(
                                  client.address.isNotEmpty ? client.address : client.phoneNumber,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontSize: Responsive.fontSize(context, 12),
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                          onTap: () {
                            _selectExistingClient(client);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void _hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void _selectExistingClient(ClientModel selectedClient) {
    setState(() {
      client = selectedClient;
      clientNameController.text = selectedClient.name;
      showClientDropdown = false;
    });
    _hideOverlay();
    clientNameFocusNode.unfocus();
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
    
    if (client != null) {
      clientNameController.text = client!.name;
    }
    clientNameController.addListener(_onClientNameChanged);
    clientNameFocusNode.addListener(_onClientNameFocusChanged);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _hideOverlay();
        },
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
                        widget.inVoiceToReceipt == true
                            ? "Re-issue to receipt"
                            : widget.isInvoice == true
                            ? "Complete invoice"
                            : "Complete receipt",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(8),
                      ),
                      Text(
                        widget.inVoiceToReceipt == true
                            ? 'Fill and confirm the details below.'
                            : 'Fill in the details below to generate ${widget.isInvoice == true ? "invoice" : "receipt"}',
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
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: AppTextField(
                          hintText: 'Type or select client name',
                          controller: clientNameController,
                          focusNode: clientNameFocusNode,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                          ],
                          validator: (val) {
                            if (val?.trim().isEmpty ?? true) {
                              return 'Please enter client name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(20),
                      ),
                      if (_textFields.isNotEmpty)
                        Column(
                          children: [
                            for (int index = 0; index < _textFields.length; index++) ...[
                              if (index > 0) ...[
                                SizedBox(height: responsiveData.scaleHeight(12)),
                                Text(
                                  'PRODUCT ${index + 2} DETAILS',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 15),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: responsiveData.scaleHeight(12)),
                              ],
                              _textFields[index],
                            ],
                          ],
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
                              height: responsiveData.scaleHeight(20),
                            ),
                            Text(
                              'Mode of payment',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            SizedBox(
                              height: responsiveData.scaleHeight(8),
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
                        height: responsiveData.scaleHeight(28),
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
                                if (client == null && clientNameController.text.trim().isEmpty) {
                                  ToastService.showErrorSnackBar("Please enter client name");
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
                          Visibility(
                            visible: widget.inVoiceToReceipt == false,
                            child: GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  if (client == null && clientNameController.text.trim().isEmpty) {
                                    ToastService.showErrorSnackBar("Please enter client name");
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
      ),
    );
  }
}