import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import 'package:payvidence/providers/client_providers/get_all_client_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
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
import '../add_client/add_client_viewmodel.dart';

@RoutePage(name: 'GenerateReceiptRoute')
class GenerateReceipt extends ConsumerStatefulWidget {
  final bool? isInvoice;

  const GenerateReceipt({super.key, this.isInvoice = false});

  @override
  ConsumerState<GenerateReceipt> createState() => _GenerateReceiptState();
}

class _GenerateReceiptState extends ConsumerState<GenerateReceipt> {
  final _layerLink = LayerLink();
  final qtyController = TextEditingController();
  final discountController = TextEditingController();
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final clientNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController> discountControllers = [];
  List<TextEditingController> qtyControllers = [];
  List<TextEditingController> productNameControllers = [];
  List<TextEditingController> productPriceControllers = [];
  Map<int, Product> products = {};
  Map<int, String> productNames = {};
  Map<int, double> productPrices = {};
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

  // For client search functionality
  List<ClientModel> filteredClients = [];
  bool showClientDropdown = false;
  final FocusNode clientNameFocusNode = FocusNode();
  OverlayEntry? overlayEntry;

  @override
  void dispose() {
    for (var controller in qtyControllers) {
      controller.dispose();
    }
    for (var controller in discountControllers) {
      controller.dispose();
    }
    for (var controller in productNameControllers) {
      controller.dispose();
    }
    for (var controller in productPriceControllers) {
      controller.dispose();
    }
    clientNameController.dispose();
    clientNameFocusNode.dispose();
    overlayEntry?.remove();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    qtyControllers.add(qtyController);
    discountControllers.add(discountController);
    productNameControllers.add(productNameController);
    productPriceControllers.add(productPriceController);

    // Initialize the first form field
    _textFields.add(FormFields(
      qtyController: qtyController,
      discountController: discountController,
      productNameController: productNameController,
      productPriceController: productPriceController,
      onPressed: selectProduct,
      index: 1,
    ));

    // Listen to client name changes for search
    clientNameController.addListener(_onClientNameChanged);
    clientNameFocusNode.addListener(_onClientNameFocusChanged);
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
    _hideOverlay(); // Remove existing overlay first

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Invisible barrier to detect taps outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            // The actual dropdown
            Positioned(
              left: ResponsiveInherited.of(context).paddingHorizontal,
              right: ResponsiveInherited.of(context).paddingHorizontal,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 60), // Positions dropdown below text field
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
                          subtitle: Text(
                            client.address.isNotEmpty ? client.address : client.phoneNumber,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontSize: Responsive.fontSize(context, 12),
                              color: Colors.grey,
                            ),
                          ),
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

  void _addTextField() {
    // Create new TextEditingControllers
    TextEditingController qtyController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    TextEditingController productNameController = TextEditingController();
    TextEditingController productPriceController = TextEditingController();

    // Add the controllers to the lists
    qtyControllers.add(qtyController);
    discountControllers.add(discountController);
    productNameControllers.add(productNameController);
    productPriceControllers.add(productPriceController);
    // Add a new FormFields widget to the list
    setState(() {
      _textFields.add(FormFields(
        discountController: discountControllers.last,
        qtyController: qtyControllers.last,
        productNameController: productNameControllers.last,
        productPriceController: productPriceControllers.last,
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

  Future<ClientModel?> createClient(String name) async {
    try {
      final businessId = ref.read(getCurrentBusinessProvider)?.id;
      if (businessId == null) {

        return null;
      }

      bool success = false;
      String? newClientId;


      ref.read(addClientViewModelProvider).addClient(
        name: name,
        address: null,
        phoneNumber: null,
        businessId: businessId,
        navigateOnSuccess: () {

          success = true;
          final response = ref.read(addClientLastResponseProvider);
          newClientId = response?.data?['data']?['id'] as String?;

        },
      );


      await Future.doWhile(() async {
        final isLoading = ref.read(addClientLoadingProvider);

        if (isLoading) {
          await Future.delayed(const Duration(milliseconds: 100));
          return true;
        }
        return false;
      });


      if (!success || newClientId == null) {

        return null;
      }


      ref.read(getAllClientsProvider.notifier).fetchClients();

      return ClientModel(
        id: newClientId!,
        businessId: businessId,
        name: name,
        phoneNumber: '',
        address: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {

      return null;
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

    // Handle client creation if needed
    ClientModel? finalClient = client;
    if (finalClient == null && clientNameController.text.trim().isNotEmpty) {
      // Check if the typed name matches any existing client
      final allClients = ref.read(getAllClientsProvider).value ?? [];
      final existingClient = allClients.firstWhere(
            (c) => c.name.toLowerCase() == clientNameController.text.trim().toLowerCase(),
        orElse: () => ClientModel(
          id: '',
          businessId: '',
          name: '',
          phoneNumber: '',
          address: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      if (existingClient.id.isNotEmpty) {
        finalClient = existingClient;
      } else {
        // Create new client
        finalClient = await createClient(clientNameController.text.trim());
        if (finalClient == null) {
          ToastService.showErrorSnackBar('Failed to create client');
          return;
        }
      }
    }

    List<Map<String, dynamic>> productList = [];

    for (int i = 0; i < _textFields.length; i++) {
      final index = i + 1;
      
      if (qtyControllers[i].text.isEmpty) {
        ToastService.showErrorSnackBar('Enter the qty purchased for product $index');
        return;
      }

      final quantity = int.parse(qtyControllers[i].text);
      final discount = discountControllers[i].text.isNotEmpty
          ? double.parse(discountControllers[i].text)
          : null;

      if (products.containsKey(index)) {
        // Existing product
        productList.add({
          "id": products[index]!.id.toString(),
          "quantity_purchased": quantity,
          "discount": discount,
          "vat": "0",
        });
      } else {
        // New product
        final productName = productNameControllers[i].text.trim();
        final productPrice = double.tryParse(productPriceControllers[i].text.trim()) ?? 0.0;
        
        if (productName.isEmpty || productPrice <= 0) {
          ToastService.showErrorSnackBar('Enter valid product name and price for product $index');
          return;
        }

        productList.add({
          "name": productName,
          "price": productPrice,
          "quantity_purchased": quantity,
          "discount": discount,
          "vat": "0",
        });
      }
    }
    Map<String, dynamic> requestData = {
      "products": productList,
      "record_type": widget.isInvoice == true ? "invoice" : "receipt",
      "business_id": ref.read(getCurrentBusinessProvider)!.id!,
      "client_id": finalClient?.id,
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
      ref.invalidate(getAllProductProvider);
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
    for (int i = 0; i < _textFields.length; i++) {
      final index = i + 1;
      final hasExistingProduct = products.containsKey(index);
      final hasProductName = productNameControllers[i].text.trim().isNotEmpty;
      
      if (!hasExistingProduct && !hasProductName) {
        return "Missing product $index name";
      }
    }
    return "";
  }



  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: AppTextField(
                          hintText: 'Type or select client name',
                          controller: clientNameController,
                          focusNode: clientNameFocusNode,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            // LengthLimitingTextInputFormatter(11),
                            // FilteringTextInputFormatter.digitsOnly,
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
                                if (clientNameController.text.trim().isEmpty) {
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
                          GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if (clientNameController.text.trim().isEmpty) {
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
  final TextEditingController productNameController;
  final TextEditingController productPriceController;
  final Future<Product?> Function(int index) onPressed;
  final int index;
  Product? product;
  final bool? invoiceToReceipt;

  FormFields({
    super.key,
    required this.qtyController,
    required this.discountController,
    required this.productNameController,
    required this.productPriceController,
    required this.onPressed,
    required this.index,
    this.product,
    this.invoiceToReceipt = false,
  });

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  List<Product> filteredProducts = [];
  bool showProductDropdown = false;
  final FocusNode productNameFocusNode = FocusNode();
  OverlayEntry? productOverlayEntry;
  final LayerLink _productLayerLink = LayerLink();
  bool isExistingProduct = false;

  @override
  void initState() {
    super.initState();
    widget.productNameController.addListener(_onProductNameChanged);
    productNameFocusNode.addListener(_onProductNameFocusChanged);
  }

  @override
  void dispose() {
    productNameFocusNode.dispose();
    productOverlayEntry?.remove();
    super.dispose();
  }

  void _onProductNameChanged() {
    final query = widget.productNameController.text.trim();
    if (query.isEmpty) {
      setState(() {
        filteredProducts.clear();
        showProductDropdown = false;
        isExistingProduct = false;
      });
      _hideProductOverlay();
      return;
    }

    // Get products from provider using Consumer
    if (mounted) {
      final container = ProviderScope.containerOf(context);
      final asyncProducts = container.read(getAllProductProvider);
      final allProducts = asyncProducts.value ?? [];
      
      final filtered = allProducts
          .where((product) =>
              product.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();

      setState(() {
        filteredProducts = filtered;
        showProductDropdown = filtered.isNotEmpty;
      });

      if (filtered.isNotEmpty) {
        _showProductOverlay();
      } else {
        _hideProductOverlay();
      }
    }
  }

  void _onProductNameFocusChanged() {
    if (!productNameFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 150), () {
        _hideProductOverlay();
      });
    }
  }

  void _showProductOverlay() {
    _hideProductOverlay();

    productOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideProductOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: ResponsiveInherited.of(context).paddingHorizontal,
              right: ResponsiveInherited.of(context).paddingHorizontal,
              child: CompositedTransformFollower(
                link: _productLayerLink,
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
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          title: Text(
                            product.name ?? '',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          subtitle: Text(
                            '₦${product.price ?? '0'}',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontSize: Responsive.fontSize(context, 12),
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            _selectExistingProduct(product);
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

    Overlay.of(context).insert(productOverlayEntry!);
  }

  void _hideProductOverlay() {
    productOverlayEntry?.remove();
    productOverlayEntry = null;
  }

  void _selectExistingProduct(Product selectedProduct) {
    setState(() {
      widget.product = selectedProduct;
      widget.productNameController.text = selectedProduct.name ?? '';
      widget.productPriceController.text = selectedProduct.price ?? '';
      showProductDropdown = false;
      isExistingProduct = true;
    });
    _hideProductOverlay();
    productNameFocusNode.unfocus();
    
    // Store the selected product in the parent's products map
    final parentState = context.findAncestorStateOfType<_GenerateReceiptState>();
    if (parentState != null) {
      parentState.products[widget.index] = selectedProduct;
    }
  }

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
        CompositedTransformTarget(
          link: _productLayerLink,
          child: AppTextField(
            hintText: 'Type or select product name',
            controller: widget.productNameController,
            focusNode: productNameFocusNode,
            keyboardType: TextInputType.text,
            enabled: !widget.invoiceToReceipt!,
            validator: (val) {
              if (val?.trim().isEmpty ?? true) {
                return 'Please enter product name';
              }
              return null;
            },
          ),
        ),
        SizedBox(
          height: responsiveData.scaleHeight(20),
        ),
        Text(
          'Product price',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: responsiveData.scaleHeight(8),
        ),
        AppTextField(
          hintText: 'Product price',
          controller: widget.productPriceController,
          keyboardType: TextInputType.number,
          enabled: !widget.invoiceToReceipt! && !isExistingProduct,
          validator: (val) {
            if (val?.trim().isEmpty ?? true) {
              return 'Please enter product price';
            }
            if (double.tryParse(val!) == null || double.parse(val) <= 0) {
              return 'Enter a valid price greater than 0';
            }
            return null;
          },
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