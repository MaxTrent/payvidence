import 'dart:developer' as developer;
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/components/simple_bottom_sheet.dart';
import 'package:payvidence/utilities/app_functions.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';
import '../../components/loading_dialog.dart';
import '../../components/create_product_dialog.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../model/business_model.dart';
import '../../gen/assets.gen.dart';
import '../../providers/business_providers/get_all_business_provider.dart';
import '../../providers/business_providers/current_business_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/toast_service.dart';
import 'add_business_vm.dart';

@RoutePage(name: 'AddBusinessRoute')
class AddBusiness extends HookConsumerWidget {
  AddBusiness({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final roleController = TextEditingController();
  final ValueNotifier<XFile?> logo = ValueNotifier(null);
  final ValueNotifier<XFile?> signature = ValueNotifier(null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasNavigated = useRef(false);
    final responsiveData = ResponsiveInherited.of(context);
    final vm = ref.watch(addBusinessViewModelProvider);
    final sessionManager = locator<SessionManager>();

    final isCreatingBusiness = useState(false);
    final selectedRole = useState<String?>(null);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final firstName = sessionManager.get<String>(SessionConstants.userFirstName);
    final lastName = sessionManager.get<String>(SessionConstants.userLastName);
    final email = sessionManager.get<String>(SessionConstants.userEmail);
    final fullName = [firstName, lastName].where((s) => s != null && s.isNotEmpty).join(' ').trim();
    final issuerName = fullName.isEmpty ? (email ?? '') : fullName;

    developer.log('AddBusiness: firstName=$firstName, lastName=$lastName, fullName=$fullName, issuerName=$issuerName');

    final issuerController = useTextEditingController();
    useEffect(() {
      issuerController.text = issuerName;
      return null;
    }, []);

    final createBusiness = useCallback(() async {
      if (isCreatingBusiness.value) return;

      isCreatingBusiness.value = true;

      final requestData = FormData.fromMap({
        "name": businessNameController.text,
        "address": businessAddressController.text,
        "phone_number": phoneNumberController.text,
        "issuer": issuerController.text,
        "issuer_role": selectedRole.value ?? '',
        "vat": 5,
        if (logo.value != null)
          "logo_image": await MultipartFile.fromFile(
            logo.value!.path,
            filename: logo.value!.path.split('/').last,
          ),
        "issuer_signature_image": await MultipartFile.fromFile(
          signature.value!.path,
          filename: signature.value!.path.split('/').last,
        ),
      });

      if (!context.mounted) {
        isCreatingBusiness.value = false;
        return;
      }

      LoadingDialog.show(context);

      try {
        final response = await vm.businessRepository.addBusiness(requestData);

        if (!context.mounted) {
          isCreatingBusiness.value = false;
          return;
        }

        Navigator.of(context).pop();
        ToastService.showSnackBar("Business created successfully");
        
        // Set the newly created business as current
        final businessId = response.id;
        print('Saving business ID to session: $businessId');
        
        if (businessId != null && businessId.isNotEmpty) {
          try {
            await locator<SessionManager>().save(key: SessionConstants.businessId, value: businessId);
            
            // Add a small delay to ensure the save completes
            await Future.delayed(const Duration(milliseconds: 100));
            
            // Verify the save operation
            final savedId = locator<SessionManager>().get<String>(SessionConstants.businessId);
            print('Verified saved business ID: $savedId');
            
            if (savedId == null || savedId != businessId) {
              print('Session save failed, trying alternative approach');
              // Try saving again without await
              locator<SessionManager>().save(key: SessionConstants.businessId, value: businessId);
              await Future.delayed(const Duration(milliseconds: 200));
              final retryId = locator<SessionManager>().get<String>(SessionConstants.businessId);
              print('Retry saved business ID: $retryId');
            }
          } catch (e) {
            print('Error saving business ID to session: $e');
          }
        } else {
          print('Business ID is null or empty, cannot save to session');
        }
        
        // Set current business immediately
        ref.read(getCurrentBusinessProvider.notifier).setCurrentBusiness(response);
        
        // Refresh business list and wait a moment for it to update
        ref.invalidate(getAllBusinessProvider);
        
        // Wait for business list to refresh before navigation
        await Future.delayed(const Duration(milliseconds: 500));

        if (context.mounted) {
          // Navigate to home screen
          context.router.replaceAll([const HomePageRoute()]);
          
          // Show create product dialog after navigation
          Future.delayed(const Duration(milliseconds: 1000), () {
            final currentContext = locator<PayvidenceAppRouter>().navigatorKey.currentContext;
            if (currentContext != null) {
              showDialog(
                context: currentContext,
                barrierDismissible: false,
                builder: (context) => const CreateProductDialog(),
              );
            }
          });
        }

      } on DioException catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop();
          ToastService.showErrorSnackBar(
            e.response?.data['message'] ?? 'An unknown error has occurred!!!',
          );
        }
      } catch (e) {
        print(e);
        if (context.mounted) {
          Navigator.of(context).pop();
          ToastService.showErrorSnackBar('An error has occurred!');
        }
      } finally {
        isCreatingBusiness.value = false;
      }
    }, [isCreatingBusiness.value]);

    useEffect(() {
      return () {
        isCreatingBusiness.value = false;
      };
    }, []);

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: PopScope(
          canPop: !isCreatingBusiness.value,
          onPopInvoked: (didPop) {
            if (didPop) return;
            if (isCreatingBusiness.value) {
              developer.log('AddBusinessRoute: Back navigation blocked during creation');
            }
          },
          child: KeyboardDismissibleScaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              // automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
                  child: ListView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      Text(
                        'Set-up business',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      Text(
                        'Fill in all details to add your business.',
                        style: Theme.of(context).textTheme.displaySmall!,
                      ),
                      SizedBox(height: responsiveData.scaleHeight(12)),
                      _buildSectionTitle(context, 'Business name'),
                      AppTextField(
                        hintText: 'Business name',
                        controller: businessNameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Business name is required';
                          }
                          if (val.trim().length < 2) {
                            return 'Business name must be at least 2 characters long';
                          }
                          return null;
                        },
                      ),
                      _buildSectionTitle(context, 'Business address'),
                      AppTextField(
                        hintText: 'Business address',
                        controller: businessAddressController,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Enter a valid address';
                          }
                          return null;
                        },
                      ),
                      _buildSectionTitle(context, 'Business phone number'),
                      AppTextField(
                        hintText: 'Business phone number',
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (val) {
                          if (!val!.trim().isValidPhone || val.isEmpty) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      _buildSectionTitle(context, 'Business logo'),
                      GestureDetector(
                        onTap: () async {
                          logo.value = await AppFunctions.pickImage();
                        },
                        child: ValueListenableBuilder(
                          valueListenable: logo,
                          builder: (context, val, _) {
                            if (val == null) {
                              return SvgPicture.asset(Assets.svg.uploadImage);
                            } else {
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
                                        borderRadius: BorderRadius.circular(responsiveData.smallRadius),
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
                          },
                        ),
                      ),
                      _buildSectionTitle(context, 'Who issues receipts and invoices?'),
                      AppTextField(
                        hintText: issuerName.isEmpty ? 'Issuer name not available' : 'Issuer name',
                        controller: issuerController,
                        enabled: true,
                        validator: issuerName.isEmpty ? (_) => 'Issuer name is required' : (val) => Validator.validateName(val),
                      ),
                      _buildSectionTitle(context, 'What is the role of this issuer?'),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            clipBehavior: Clip.none,
                            context: context,
                            builder: (context) => SimpleBottomSheet(
                              isDarkMode: isDarkMode,
                              title: 'Select Role',
                              subtitle: 'Choose the role of the issuer.',
                              height: 400,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectedRole.value = 'Sales Manager';
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sales Manager',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(height: responsiveData.scaleHeight(1)),
                                GestureDetector(
                                  onTap: () {
                                    selectedRole.value = 'Business Manager';
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Business Manager',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(height: responsiveData.scaleHeight(1)),
                                GestureDetector(
                                  onTap: () {
                                    selectedRole.value = 'Marketing Manager';
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Marketing Manager',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: AppTextField(
                          hintText: selectedRole.value ?? 'Select role',
                          controller: TextEditingController(text: selectedRole.value ?? ''),
                          enabled: false,
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                      _buildSectionTitle(context, 'Issuer signature'),
                      GestureDetector(
                        onTap: () async {
                          signature.value = await AppFunctions.pickImage();
                        },
                        child: ValueListenableBuilder(
                          valueListenable: signature,
                          builder: (context, val, _) {
                            if (val == null) {
                              return SvgPicture.asset(Assets.svg.uploadImage);
                            } else {
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
                                        borderRadius: BorderRadius.circular(responsiveData.smallRadius),
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
                          },
                        ),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(32)),
                      AppButton(
                        buttonText: 'Add business',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            if (signature.value == null) {
                              ToastService.showErrorSnackBar("Select a signature image");
                            } else if (issuerName.isEmpty) {
                              ToastService.showErrorSnackBar("Issuer name is not available. Please update your profile in Settings.");
                            } else if (selectedRole.value == null) {
                              ToastService.showErrorSnackBar("Please select a role");
                            } else {
                              createBusiness();
                            }
                          }
                        },
                      ),
                      SizedBox(height: responsiveData.scaleHeight(8)),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    final responsiveData = ResponsiveInherited.of(context);
    return Padding(
      padding: EdgeInsets.only(
          top: responsiveData.scaleHeight(20),
          bottom: responsiveData.scaleWidth(8)),
      child: Text(title, style: Theme.of(context).textTheme.displaySmall),
    );
  }
}