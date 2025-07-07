import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';
import '../../gen/assets.gen.dart';
import '../business_detail/business_detail_vm.dart';

@RoutePage(name: 'EditBusinessRoute')
class EditBusinessDetail extends ConsumerStatefulWidget {
  final String businessId;

  const EditBusinessDetail({
    super.key,
    @QueryParam('businessId') this.businessId = '',
  });

  @override
  ConsumerState<EditBusinessDetail> createState() => _EditBusinessDetailState();
}

class _EditBusinessDetailState extends ConsumerState<EditBusinessDetail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final issuerController = TextEditingController();
  final issuerRoleController = TextEditingController();
  
  String? originalName;
  String? originalAddress;
  String? originalPhone;
  String? originalIssuer;
  String? originalIssuerRole;
  String? originalLogo;
  String? originalSignature;
  bool hasInitialized = false;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    issuerController.dispose();
    issuerRoleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessDetailViewModel(widget.businessId)).fetchBusinessInformation(widget.businessId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(businessDetailViewModel(widget.businessId));
    final responsiveData = ResponsiveInherited.of(context);

    // Initialize data when first loaded
    if (viewModel.businessInfo != null && !viewModel.isLoading && !hasInitialized) {
      nameController.text = viewModel.businessInfo!.name ?? '';
      addressController.text = viewModel.businessInfo!.address ?? '';
      phoneController.text = viewModel.businessInfo!.phoneNumber ?? '';
      issuerController.text = viewModel.businessInfo!.issuer ?? '';
      issuerRoleController.text = viewModel.businessInfo!.issuerRole ?? '';
      originalName = viewModel.businessInfo!.name;
      originalAddress = viewModel.businessInfo!.address;
      originalPhone = viewModel.businessInfo!.phoneNumber;
      originalIssuer = viewModel.businessInfo!.issuer;
      originalIssuerRole = viewModel.businessInfo!.issuerRole;
      originalLogo = viewModel.currentLogo;
      originalSignature = viewModel.currentSignature;
      hasInitialized = true;
    }

    // Function to check if there are any changes
    bool hasChanges() {
      return nameController.text != originalName ||
          addressController.text != originalAddress ||
          phoneController.text != originalPhone ||
          issuerController.text != originalIssuer ||
          issuerRoleController.text != originalIssuerRole ||
          viewModel.selectedLogoImage != null ||
          viewModel.selectedSignatureImage != null;
    }

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: KeyboardDismissibleScaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Edit business details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  Text(
                    'You can update business details here.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(12)),
                  _buildSectionTitle(context, 'Business name'),
                  GestureDetector(
                    onTap: () => print('EditBusinessDetail: Business name field tapped'),
                    child: AppTextField(
                      hintText: 'Business name',
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (val) {
                        return Validator.validateName(val);
                      },
                    ),
                  ),
                  _buildSectionTitle(context, 'Business address'),
                  AppTextField(
                    hintText: 'Business address',
                    controller: addressController,
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      return Validator.validateName(val);
                    },
                  ),
                  _buildSectionTitle(context, 'Business phone number'),
                  AppTextField(
                    hintText: 'Business phone number',
                    controller: phoneController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (val) {
                      return Validator.validatePhoneNumber(val);
                    },
                  ),
                  _buildSectionTitle(context, 'Business logo'),
                  GestureDetector(
                    onTap: () {
                      viewModel.pickLogoImage();
                    },
                    child: viewModel.selectedLogoImage != null
                        ? Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Image.file(
                            viewModel.selectedLogoImage!,
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
                              vertical: responsiveData.scaleHeight(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                              color: Colors.grey,
                            ),
                            child: Text(
                              "Tap to Change",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.fontSize(context, 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : viewModel.currentLogo != null
                        ? Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            viewModel.currentLogo!,
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
                              vertical: responsiveData.scaleHeight(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                              color: Colors.grey,
                            ),
                            child: Text(
                              "Tap to Change",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.fontSize(context, 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : SvgPicture.asset(Assets.svg.uploadImage),
                  ),
                  _buildSectionTitle(context, 'Who issues receipts and invoices?'),
                  AppTextField(
                    hintText: 'Issuer name',
                    controller: issuerController,
                    enabled: false,
                    validator: (val) {
                      return Validator.validateName(val);
                    },
                  ),
                  _buildSectionTitle(context, 'What is the role of this issuer?'),
                  AppTextField(
                    hintText: 'Role of issuer',
                    controller: issuerRoleController,
                    validator: (val) {
                      return Validator.validateName(val);
                    },
                  ),
                  _buildSectionTitle(context, 'Issuer signature'),
                  GestureDetector(
                    onTap: () {
                      viewModel.pickSignatureImage();
                    },
                    child: viewModel.selectedSignatureImage != null
                        ? Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Image.file(
                            viewModel.selectedSignatureImage!,
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
                              vertical: responsiveData.scaleHeight(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                              color: Colors.grey,
                            ),
                            child: Text(
                              "Tap to Change",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.fontSize(context, 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : viewModel.currentSignature != null
                        ? Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            viewModel.currentSignature!,
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
                              vertical: responsiveData.scaleHeight(8),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                              color: Colors.grey,
                            ),
                            child: Text(
                              "Tap to Change",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.fontSize(context, 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : SvgPicture.asset(Assets.svg.uploadImage),
                  ),
                  SizedBox(height: responsiveData.scaleHeight(32)),
                  AppButton(
                    buttonText: 'Update business details',
                    isProcessing: viewModel.isLoading,
                    onPressed: () {
                      if (formKey.currentState!.validate() && hasChanges()) {
                        viewModel.updateBusinessInfo(
                          widget.businessId,
                          name: nameController.text.trim(),
                          address: addressController.text.trim(),
                          phone: phoneController.text.trim(),
                          issuer: issuerController.text.trim(),
                          issuerRole: issuerRoleController.text.trim(),
                          logo: viewModel.selectedLogoImage,
                          signature: viewModel.selectedSignatureImage,
                          navigateOnSuccess: () {
                            Navigator.of(context).pop();
                          },
                        );
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
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final responsiveData = ResponsiveInherited.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: responsiveData.scaleHeight(20),
        bottom: responsiveData.scaleWidth(8),
      ),
      child: Text(title, style: Theme.of(context).textTheme.displaySmall),
    );
  }
}