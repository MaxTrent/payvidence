import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';
import '../../gen/assets.gen.dart';
import '../business_detail/business_detail_vm.dart';

@RoutePage(name: 'EditBusinessRoute')
class EditBusinessDetail extends HookConsumerWidget {
  final String businessId;

  const EditBusinessDetail({
    super.key,
    @QueryParam('businessId') this.businessId = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(businessDetailViewModel(businessId));
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameController = useTextEditingController();
    final addressController = useTextEditingController();
    final phoneController = useTextEditingController();
    final issuerController = useTextEditingController();
    final issuerRoleController = useTextEditingController();
    final responsiveData = ResponsiveInherited.of(context);

    final originalName = useState<String?>(null);
    final originalAddress = useState<String?>(null);
    final originalPhone = useState<String?>(null);
    final originalIssuer = useState<String?>(null);
    final originalIssuerRole = useState<String?>(null);
    final originalLogo = useState<String?>(null);
    final originalSignature = useState<String?>(null);

    useEffect(() {
      viewModel.fetchBusinessInformation(businessId);
      return null;
    }, [businessId]);

    useEffect(() {
      if (viewModel.businessInfo != null && !viewModel.isLoading) {
        nameController.text = viewModel.businessInfo!.name ?? '';
        addressController.text = viewModel.businessInfo!.address ?? '';
        phoneController.text = viewModel.businessInfo!.phoneNumber ?? '';
        issuerController.text = viewModel.businessInfo!.issuer ?? '';
        issuerRoleController.text = viewModel.businessInfo!.issuerRole ?? '';
        originalName.value = viewModel.businessInfo!.name;
        originalAddress.value = viewModel.businessInfo!.address;
        originalPhone.value = viewModel.businessInfo!.phoneNumber;
        originalIssuer.value = viewModel.businessInfo!.issuer;
        originalIssuerRole.value = viewModel.businessInfo!.issuerRole;
        originalLogo.value = viewModel.currentLogo;
        originalSignature.value = viewModel.currentSignature;
      }
      return null;
    }, [viewModel.businessInfo, viewModel.isLoading]);

    // Function to check if there are any changes
    bool hasChanges() {
      return nameController.text != originalName.value ||
          addressController.text != originalAddress.value ||
          phoneController.text != originalPhone.value ||
          issuerController.text != originalIssuer.value ||
          issuerRoleController.text != originalIssuerRole.value ||
          viewModel.selectedLogoImage != null ||
          viewModel.selectedSignatureImage != null;
    }

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
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
                  AppTextField(
                    hintText: 'Business name',
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      return Validator.validateName(val);
                    },
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
                          businessId,
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