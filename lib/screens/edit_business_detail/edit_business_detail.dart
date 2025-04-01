
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView(
              children: [
                Text(
                  'Edit business details',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 8.h),
                Text(
                  'You can update business details here.',
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(height: 12.h),
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
                      ? Image.file(
                    viewModel.selectedLogoImage!,
                    height: 260.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                  )
                      : viewModel.currentLogo != null
                      ? Image.network(
                    viewModel.currentLogo!,
                    height: 260.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        SvgPicture.asset(Assets.svg.uploadImage),
                  )
                      : SvgPicture.asset(Assets.svg.uploadImage),
                ),
                _buildSectionTitle(context, 'Who issues receipts and invoices?'),
                AppTextField(
                  hintText: 'Issuer name',
                  controller: issuerController,
                  fillColor: borderColor,
                  filled: true,
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
                      ? Image.file(
                    viewModel.selectedSignatureImage!,
                    height: 260.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                  )
                      : viewModel.currentSignature != null
                      ? Image.network(
                    viewModel.currentSignature!,
                    height: 260.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        SvgPicture.asset(Assets.svg.uploadImage),
                  )
                      : SvgPicture.asset(Assets.svg.uploadImage),
                ),
                SizedBox(height: 32.h),
                AppButton(
                  buttonText: 'Update business details',
                  // isDisabled: !hasChanges(),
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
                8.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 8.w),
      child: Text(title, style: Theme.of(context).textTheme.displaySmall),
    );
  }
}