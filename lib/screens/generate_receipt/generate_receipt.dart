import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import 'package:payvidence/providers/client_providers/get_all_client_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/all_transactions/all_transactions_vm.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/app_button.dart';
import '../../components/app_naira.dart';
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
import '../../utilities/number_formatter.dart';
import '../../utilities/real_time_number_formatter.dart';
import '../../utilities/validators.dart';
import '../add_client/add_client_viewmodel.dart';
import '../client_details/client_details_vm.dart';

@RoutePage(name: 'GenerateReceiptRoute')
class GenerateReceipt extends ConsumerStatefulWidget {
  final bool? isInvoice;
  final bool? isService;

  const GenerateReceipt({super.key, this.isInvoice = false, this.isService = false});

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
  final clientPhoneController = TextEditingController();
  final clientAddressController = TextEditingController();
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
  bool isPrefilledProduct = false;
  bool isLoading = false;

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
    clientPhoneController.dispose();
    clientAddressController.dispose();
    clientNameFocusNode.dispose();
    overlayEntry?.remove();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    qtyControllers.add(qtyController);
    // Set default value of 1 for service frequency
    if (widget.isService == true) {
      qtyController.text = '1';
    }
    discountControllers.add(discountController);
    productNameControllers.add(productNameController);
    productPriceControllers.add(productPriceController);

    // Initialize the first form field
    _textFields.add(FormFields(
      qtyController: qtyController,
      discountController: discountController,
      productNameController: productNameController,
      productPriceController: productPriceController,
      onPressed: widget.isService! ? null : selectProduct,
      index: 1,
      onRemove: _removeTextField,
      productNameEditable: widget.isService! ? true : null,
      productPriceEditable: widget.isService! ? true : null,
      isService: widget.isService,
    ));

    // Listen to client name changes for search
    clientNameController.addListener(_onClientNameChanged);
    clientNameFocusNode.addListener(_onClientNameFocusChanged);
    
    // Prefill product data if coming from product details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentProduct = ref.read(getCurrentProductProvider);
      if (currentProduct != null) {
        productNameController.text = currentProduct.name ?? '';
        // Format price with commas manually
        final price = currentProduct.price ?? '0';
        final numPrice = double.tryParse(price) ?? 0;
        final formattedPrice = numPrice.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
        productPriceController.text = formattedPrice;
        products[1] = currentProduct;
        isPrefilledProduct = true;
        
        // Update the first form field to be uneditable for products, but editable for services
        _textFields[0] = FormFields(
          qtyController: qtyController,
          discountController: discountController,
          productNameController: productNameController,
          productPriceController: productPriceController,
          onPressed: widget.isService! ? null : selectProduct,
          index: 1,
          invoiceToReceipt: widget.isService! ? false : true,
          productNameEditable: widget.isService! ? true : false,
          productPriceEditable: widget.isService! ? true : false,
          isService: widget.isService,
          onRemove: _removeTextField,
        );
        setState(() {});
      }
    });
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
      
      // Fill in phone number and address if available
      if (selectedClient.phoneNumber.isNotEmpty) {
        clientPhoneController.text = selectedClient.phoneNumber;
      }
      
      if (selectedClient.address.isNotEmpty) {
        clientAddressController.text = selectedClient.address;
      }
      
      showClientDropdown = false;
    });
    _hideOverlay();
    clientNameFocusNode.unfocus();
  }

  void _removeTextField(int index) {
    if (_textFields.length <= 1) return; // Don't remove if only one product left
    
    final actualIndex = index - 1; // Convert to 0-based index
    
    // Dispose controllers
    qtyControllers[actualIndex].dispose();
    discountControllers[actualIndex].dispose();
    productNameControllers[actualIndex].dispose();
    productPriceControllers[actualIndex].dispose();
    
    // Remove from lists
    qtyControllers.removeAt(actualIndex);
    discountControllers.removeAt(actualIndex);
    productNameControllers.removeAt(actualIndex);
    productPriceControllers.removeAt(actualIndex);
    
    // Remove from products map
    products.remove(index);
    
    setState(() {
      _textFields.removeAt(actualIndex);
      // Update indices for remaining fields
      for (int i = 0; i < _textFields.length; i++) {
        final field = _textFields[i] as FormFields;
        _textFields[i] = FormFields(
          qtyController: qtyControllers[i],
          discountController: discountControllers[i],
          productNameController: productNameControllers[i],
          productPriceController: productPriceControllers[i],
          onPressed: widget.isService! ? null : selectProduct,
          index: i + 1,
          onRemove: _removeTextField,
          invoiceToReceipt: field.invoiceToReceipt,
          productNameEditable: widget.isService! ? true : field.productNameEditable,
          productPriceEditable: widget.isService! ? true : field.productPriceEditable,
          isService: widget.isService,
        );
      }
    });
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
        onPressed: widget.isService! ? null : selectProduct,
        index: _textFields.length + 1,
        onRemove: _removeTextField,
        productNameEditable: widget.isService! ? true : null,
        productPriceEditable: widget.isService! ? true : null,
        isService: widget.isService,
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
      
      // Get phone and address from controllers
      final phoneNumber = clientPhoneController.text.trim();
      final address = clientAddressController.text.trim();

      ref.read(addClientViewModelProvider).addClient(
        name: name,
        address: address.isNotEmpty ? address : null,
        phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
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
        phoneNumber: phoneNumber,
        address: address,
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
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedPayment = option;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                          child: Text(
                            option.replaceAll(RegExp('_'), ' '),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: Responsive.fontSize(context, 14)),
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
    if (isLoading) return; // Prevent multiple clicks
    
    String error = findMissingProducts();
    if (error != '') {
      ToastService.showErrorSnackBar(error);
      return;
    }
    
    setState(() {
      isLoading = true;
    });
    
    if (!context.mounted) return;
    LoadingDialog.show(context);

    // Handle client creation or update
    ClientModel? finalClient = client;
    final clientName = clientNameController.text.trim();
    final clientPhone = clientPhoneController.text.trim();
    final clientAddress = clientAddressController.text.trim();
    
    print('Client update check: finalClient=${finalClient?.name}, clientName=$clientName');
    
    if (finalClient == null && clientName.isNotEmpty) {
      // Check if the typed name matches any existing client
      final allClients = ref.read(getAllClientsProvider).value ?? [];
      final existingClient = allClients.firstWhere(
            (c) => c.name.toLowerCase() == clientName.toLowerCase(),
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
        print('Found existing client: ${existingClient.name}');
        print('Current phone: "${existingClient.phoneNumber}", New phone: "$clientPhone"');
        print('Current address: "${existingClient.address}", New address: "$clientAddress"');
        
        // Check if client info has been updated
        bool needsUpdate = false;
        
        if (clientPhone != existingClient.phoneNumber) {
          needsUpdate = true;
          print('Phone number changed: "${existingClient.phoneNumber}" -> "$clientPhone"');
        }
        
        if (clientAddress != existingClient.address) {
          needsUpdate = true;
          print('Address changed: "${existingClient.address}" -> "$clientAddress"');
        }
        
        print('Need update: $needsUpdate');
        
        if (needsUpdate) {
          // Update existing client with new information
          try {
            final businessId = ref.read(getCurrentBusinessProvider)?.id;
            if (businessId != null) {
              print('Updating client with businessId: $businessId, clientId: ${existingClient.id}');
              
              final clientDetailsVM = ref.read(clientDetailsViewModelViewModelProvider);
              clientDetailsVM.clientInfo = existingClient;
              
              bool updateSuccess = false;
              
              await clientDetailsVM.updateClient(
                businessId: businessId,
                clientId: existingClient.id,
                newName: existingClient.name,
                newPhoneNumber: clientPhone,
                newAddress: clientAddress,
                navigateOnSuccess: () {
                  updateSuccess = true;
                  print('Client update successful');
                  ref.read(getAllClientsProvider.notifier).fetchClients();
                },
              );
              
              // Wait for the update to complete
              await Future.doWhile(() async {
                if (clientDetailsVM.isLoading) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  return true;
                }
                return false;
              });
              
              print('Update completed, success: $updateSuccess');
            }
          } catch (e) {
            print('Failed to update client: $e');
          }
        }
        
        finalClient = existingClient;
      } else {
        // Create new client
        finalClient = await createClient(clientName);
        if (finalClient == null) {
          ToastService.showErrorSnackBar('Failed to create client');
          return;
        }
      }
    } else if (finalClient != null) {
      // Check if selected client info has been updated
      print('Checking selected client for updates');
      print('Selected client phone: "${finalClient.phoneNumber}", New phone: "$clientPhone"');
      print('Selected client address: "${finalClient.address}", New address: "$clientAddress"');
      
      bool needsUpdate = false;
      
      if (clientPhone != finalClient.phoneNumber) {
        needsUpdate = true;
        print('Selected client phone changed: "${finalClient.phoneNumber}" -> "$clientPhone"');
      }
      
      if (clientAddress != finalClient.address) {
        needsUpdate = true;
        print('Selected client address changed: "${finalClient.address}" -> "$clientAddress"');
      }
      
      if (needsUpdate) {
        try {
          final businessId = ref.read(getCurrentBusinessProvider)?.id;
          if (businessId != null) {
            print('Updating selected client with businessId: $businessId, clientId: ${finalClient.id}');
            
            final clientDetailsVM = ref.read(clientDetailsViewModelViewModelProvider);
            clientDetailsVM.clientInfo = finalClient;
            
            await clientDetailsVM.updateClient(
              businessId: businessId,
              clientId: finalClient.id,
              newName: finalClient.name,
              newPhoneNumber: clientPhone,
              newAddress: clientAddress,
              navigateOnSuccess: () {
                print('Selected client update successful');
                ref.read(getAllClientsProvider.notifier).fetchClients();
              },
            );
            
            // Wait for the update to complete
            await Future.doWhile(() async {
              if (clientDetailsVM.isLoading) {
                await Future.delayed(const Duration(milliseconds: 100));
                return true;
              }
              return false;
            });
          }
        } catch (e) {
          print('Failed to update selected client: $e');
        }
      }
    }

    List<Map<String, dynamic>> productList = [];
    List<Map<String, dynamic>> serviceList = [];

    for (int i = 0; i < _textFields.length; i++) {
      final index = i + 1;
      
      if (qtyControllers[i].text.isEmpty) {
        if (widget.isService == true) {
          ToastService.showErrorSnackBar('Enter the service frequency for service $index');
        } else {
          ToastService.showErrorSnackBar('Enter the quantity purchased for product $index');
        }
        return;
      }

      final quantity = int.parse(qtyControllers[i].text);
      final discount = discountControllers[i].text.isNotEmpty
          ? double.parse(discountControllers[i].text)
          : null;

      if (widget.isService == true) {
        // Service entry - always use direct entry
        final serviceName = productNameControllers[i].text.trim();
        final servicePrice = double.tryParse(NumberFormatter.unformatNumber(productPriceControllers[i].text.trim())) ?? 0.0;
        
        if (serviceName.isEmpty || servicePrice <= 0) {
          ToastService.showErrorSnackBar('Enter valid service name and price for service $index');
          return;
        }

        // Create service entry without discount if it's null or empty
        // Always default service frequency to 1 when sending to backend
        Map<String, dynamic> serviceEntry = {
          "name": serviceName,
          "price": servicePrice,
          "quantity_purchased": 1, // Default to 1 regardless of what user entered
        };
        
        // Store the service name in the products map to ensure it's available for display
        final newService = Product(
          name: serviceName,
          price: servicePrice.toString(),
          quantitySold: quantity
        );
        products[index] = newService;
        
        // Only add discount if it has a value
        if (discount != null) {
          serviceEntry["discount"] = discount;
        }
        
        serviceList.add(serviceEntry);
      } else {
        // Product entry
        if (products.containsKey(index)) {
          // Existing product
          // Create product entry with required fields
          Map<String, dynamic> productEntry = {
            "id": products[index]!.id.toString(),
            "quantity_purchased": quantity,
            "vat": "0",
          };
          
          // Only add discount if it has a value
          if (discount != null) {
            productEntry["discount"] = discount;
          }
          
          productList.add(productEntry);
        } else {
          // New product
          final productName = productNameControllers[i].text.trim();
          final productPrice = double.tryParse(NumberFormatter.unformatNumber(productPriceControllers[i].text.trim())) ?? 0.0;
          
          if (productName.isEmpty || productPrice <= 0) {
            ToastService.showErrorSnackBar('Enter valid product name and price for product $index');
            return;
          }

          // Create new product entry with required fields
          Map<String, dynamic> newProductEntry = {
            "name": productName,
            "price": productPrice,
            "quantity_purchased": quantity,
            "vat": "0",
          };
          
          // Store the product name in the products map to ensure it's available for display
          final newProduct = Product(
            name: productName,
            price: productPrice.toString(),
            quantitySold: quantity
          );
          products[index] = newProduct;
          
          // Only add discount if it has a value
          if (discount != null) {
            newProductEntry["discount"] = discount;
          }
          
          productList.add(newProductEntry);
        }
      }
    }
    
    Map<String, dynamic> requestData = {
      "record_type": widget.isInvoice == true ? "invoice" : "receipt",
      "business_id": ref.read(getCurrentBusinessProvider)!.id!,
      "client_id": finalClient?.id,
      "is_draft": widget.isService == true ? false : isDraft, // Services cannot be saved as draft
    };
    
    // Add products or services to the request data
    if (widget.isService == true) {
      requestData["services"] = serviceList;
    } else {
      requestData["products"] = productList;
    }
    
    // Only include mode_of_payment for receipts, not for invoices
    if (widget.isInvoice != true && (isDraft != true || selectedPayment != null)) {
      // For receipts: include if not draft OR if payment method is selected
      requestData["mode_of_payment"] = selectedPayment?.toLowerCase();
    }
    try {
      final Receipt response = await ref
          .read(getAllReceiptProvider.notifier)
          .addReceipt(requestData);
      if (!context.mounted) return;
      Navigator.of(context).pop(); // pop loading dialog on success
      
      // Show comprehensive success message
      if (isDraft == true) {
        ToastService.showSnackBar("Draft saved successfully");
      } else {
        // Count new items created
        int newProductsCount = 0;
        bool newClientCreated = finalClient != null && client == null && clientNameController.text.trim().isNotEmpty;
        
        for (int i = 0; i < _textFields.length; i++) {
          final index = i + 1;
          if (!products.containsKey(index)) {
            newProductsCount++;
          }
        }
        
        String message = widget.isInvoice == true ? "Invoice generated successfully" : "Receipt generated successfully";
        
        if (newClientCreated && newProductsCount > 0) {
          message += widget.isService == true 
              ? "${newProductsCount} service${newProductsCount > 1 ? 's' : ''} added" 
              : "${newProductsCount} product${newProductsCount > 1 ? 's' : ''} added";
        } else if (newClientCreated) {
          message += "";
        } else if (newProductsCount > 0) {
          message += widget.isService == true 
              ? ". ${newProductsCount} new service${newProductsCount > 1 ? 's' : ''} added" 
              : ". ${newProductsCount} new product${newProductsCount > 1 ? 's' : ''} added";
        }
        
        ToastService.showSnackBar(message);
      }
      
      ref.invalidate(getAllReceiptProvider);
      ref.invalidate(getAllInvoiceProvider);
      ref.invalidate(getAllProductProvider);
      
      // Refresh transactions list
      final businessId = ref.read(getCurrentBusinessProvider)?.id;
      if (businessId != null) {
        ref.read(allTransactionsViewModelProvider).forceRefreshTransactions(businessId);
      }
      
      // Navigate to receipt screen if not a draft
      if (isDraft != true) {
        // Refresh the receipts list to get the full data
        await ref.refresh(widget.isInvoice == true
            ? getAllInvoiceProvider.future
            : getAllReceiptProvider.future);
        
        // Find the newly created receipt with full data
        final receipts = ref.read(widget.isInvoice == true
            ? getAllInvoiceProvider
            : getAllReceiptProvider).value ?? [];
        final fullReceipt = receipts.firstWhere(
          (r) => r.id == response.id,
          orElse: () => response,
        );
        
        locator<PayvidenceAppRouter>().navigate(
          ReceiptScreenRoute(
            record: fullReceipt,
            isInvoice: widget.isInvoice == true,
            source: isPrefilledProduct ? 'product' : null,
          ),
        );
      } else {
        // For drafts, just go back
        Navigator.of(context).pop();
      }
    } on ApiErrorResponseV2 catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
      String errorMessage = e.message ?? 'An unknown error has occurred!';
      
      // Handle specific error types with user-friendly messages
      if (errorMessage.contains('not enough stock')) {
        errorMessage = 'Not enough stock available for this product. Please check quantity.';
      } else if (errorMessage.contains('timeout')) {
        errorMessage = 'Connection is slow. Please try again.';
      } else if (errorMessage.contains('unauthorized')) {
        errorMessage = 'Session expired. Please log in again.';
      } else if (errorMessage.contains('Server Error') || errorMessage.contains('500')) {
        // Handle 500 Internal Server Error specifically for services
        if (widget.isService == true) {
          errorMessage = 'Unable to generate service ${widget.isInvoice! ? "invoice" : "receipt"}. Please check your inputs and try again.';
        } else {
          errorMessage = 'Server error occurred. Please try again later.';
        }
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
      setState(() {
        isLoading = false;
      });
      ToastService.showErrorSnackBar('An unknown error has occurred!');
    }
  }

  String findMissingProducts() {
    for (int i = 0; i < _textFields.length; i++) {
      final index = i + 1;
      final hasExistingProduct = products.containsKey(index);
      final hasProductName = productNameControllers[i].text.trim().isNotEmpty;
      
      if (!hasExistingProduct && !hasProductName) {
        return "Missing ${widget.isService! ? 'service' : 'product'} $index name";
      }
    }
    return "";
  }



  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: PopScope(
        canPop: !isPrefilledProduct,
        onPopInvoked: (didPop) {
          if (!didPop && isPrefilledProduct) {
            Navigator.of(context).pop();
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _hideOverlay();
          },
          child: KeyboardDismissibleScaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,

          ),
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
                        'Generate ${widget.isInvoice == true ? "invoice" : "receipt"} for ${widget.isService == true ? "service" : "product"}',
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
                      Text(
                        'Client phone number',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(8),
                      ),
                      AppTextField(
                        hintText: 'Phone number',
                        controller: clientPhoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (val) {
                          if (val != null && val.trim().isNotEmpty) {
                            // Only validate if not empty
                            if (!val.trim().isValidPhone) {
                              return 'Enter a valid phone number';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(20),
                      ),
                      Text(
                        'Client address',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(8),
                      ),
                      AppTextField(
                        hintText: 'Address',
                        controller: clientAddressController,
                        keyboardType: TextInputType.streetAddress,
                        validator: (val) {
                          // Address is optional, so no validation needed
                          return null;
                        },
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
                                '${widget.isService == true ? "SERVICE" : "PRODUCT"} ${idx + 2} DETAILS',
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
                              'Add another ${widget.isService == true ? "service" : "product"}',
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
                            buttonText: isLoading ? 'Generating...' : 'Generate',
                            onPressed: isLoading ? null : () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if (clientNameController.text.trim().isEmpty) {
                                  ToastService.showErrorSnackBar("Please enter client name");
                                  return;
                                }
                                // Check payment method only for receipts when generating (not draft)
                                if (widget.isInvoice == false && selectedPayment == null) {
                                  ToastService.showErrorSnackBar("Please select a payment method");
                                  return;
                                }
                                
                                // Check if bank details are required for invoices
                                if (widget.isInvoice == true) {
                                  final business = ref.read(getCurrentBusinessProvider);
                                  if (business?.bankName == null || business?.bankName?.isEmpty == true || 
                                      business?.accountNumber == null || business?.accountNumber?.isEmpty == true || 
                                      business?.accountName == null || business?.accountName?.isEmpty == true) {
                                    // Navigate to add bank details screen
                                    final result = await locator<PayvidenceAppRouter>().push(UpdateBankDetailsRoute());
                                    if (result != true) {
                                      // User cancelled adding bank details
                                      return;
                                    }
                                  }
                                }
                                
                                isDraft = false;
                                createReceipt();
                              }
                            },
                          ),
                          SizedBox(
                            height: responsiveData.scaleHeight(26),
                          ),
                          // Only show save as draft for products, not for services
                          if (!widget.isService!) 
                            GestureDetector(
                              onTap: isLoading ? null : () {
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
                                    .copyWith(color: isLoading ? Colors.grey : primaryColor2),
                              ),
                            ),
                          SizedBox(
                            height: responsiveData.scaleHeight(14),
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
      ),
    );
  }
}

class FormFields extends StatefulWidget {
  final TextEditingController qtyController;
  final TextEditingController discountController;
  final TextEditingController productNameController;
  final TextEditingController productPriceController;
  final Future<Product?> Function(int index)? onPressed;
  final int index;
  Product? product;
  final bool? invoiceToReceipt;
  final bool? productNameEditable;
  final bool? productPriceEditable;
  final bool? isService;
  final Function(int index)? onRemove;

  FormFields({
    super.key,
    required this.qtyController,
    required this.discountController,
    required this.productNameController,
    required this.productPriceController,
    this.onPressed,
    required this.index,
    this.product,
    this.invoiceToReceipt = false,
    this.productNameEditable,
    this.productPriceEditable,
    this.isService = false,
    this.onRemove,
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
    // Only add listeners if product name is editable
    final isProductNameEditable = widget.productNameEditable ?? !widget.invoiceToReceipt!;
    if (isProductNameEditable) {
      widget.productNameController.addListener(_onProductNameChanged);
      productNameFocusNode.addListener(_onProductNameFocusChanged);
    }
  }

  @override
  void dispose() {
    productNameFocusNode.dispose();
    productOverlayEntry?.remove();
    super.dispose();
  }

  void _onProductNameChanged() {
    // Don't show suggestions if field is disabled
    final isProductNameEditable = widget.productNameEditable ?? !widget.invoiceToReceipt!;
    if (!isProductNameEditable) return;
    
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
                          subtitle: Row(
                            children: [
                              AppNaira(fontSize: 14, color: Colors.grey),
                              Text(
                                (double.tryParse(product.price ?? '0') ?? 0).toStringAsFixed(2).replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]},',
                                ),
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: Responsive.fontSize(context, 12),
                                  color: Colors.grey,
                                ),
                              ),
                            ],
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
      // Format price with commas manually
      final price = selectedProduct.price ?? '0';
      final numPrice = double.tryParse(price) ?? 0;
      final formattedPrice = numPrice.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
      widget.productPriceController.text = formattedPrice;
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
        // Add remove button for additional products (not the first one)
        if (widget.index > 1 && widget.onRemove != null)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => widget.onRemove!(widget.index),
              child: Container(
                padding: EdgeInsets.all(responsiveData.scaleHeight(4)),
                child: Icon(
                  Icons.close,
                  size: responsiveData.scaleHeight(20),
                  color: appRed,
                ),
              ),
            ),
          ),
        Text(
          widget.isService == true ? 'Service name' : 'Product name',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: responsiveData.scaleHeight(8),
        ),
        CompositedTransformTarget(
          link: _productLayerLink,
          child: AppTextField(
            hintText: widget.isService == true ? 'Enter service name' : 'Type or select product name',
            controller: widget.productNameController,
            focusNode: productNameFocusNode,
            keyboardType: TextInputType.text,
            enabled: widget.productNameEditable ?? !widget.invoiceToReceipt!,
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
          widget.isService == true ? 'Service price' : 'Product price',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        SizedBox(
          height: responsiveData.scaleHeight(8),
        ),
        AppTextField(
          hintText: widget.isService == true ? 'Service price' : 'Product price',
          controller: widget.productPriceController,
          keyboardType: TextInputType.number,
          enabled: widget.productPriceEditable ?? (!widget.invoiceToReceipt! && !isExistingProduct),
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
        ),
        SizedBox(
          height: responsiveData.scaleHeight(20),
        ),
        // Only show quantity field for products, not for services
        // Show different fields based on whether it's a service or product
        if (widget.isService != true) ...[  
          // For products
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
          ),
          SizedBox(
            height: responsiveData.scaleHeight(20),
          ),
        ],
        
        // Discount field for both products and services
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
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(3),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (val) {
            if (val != null && val.isNotEmpty) {
              final discount = int.tryParse(val);
              if (discount == null) {
                return 'Enter a valid number';
              }
              if (discount > 100) {
                return 'Discount cannot exceed 100%';
              }
            }
            return null;
          },
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
        )
        // Discount field is now handled in the conditional above
      ],
    );
  }
}