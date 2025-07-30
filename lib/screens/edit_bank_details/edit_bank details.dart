import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/screens/business_detail/business_detail_vm.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';

@RoutePage(name: 'EditBankDetailsRoute')
class EditBankDetails extends HookConsumerWidget {
  final String businessId;

  const EditBankDetails({
    super.key,
    @QueryParam('businessId') this.businessId = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(businessDetailViewModel(businessId));
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final bankNameController = useTextEditingController();
    final accountNumberController = useTextEditingController();
    final accountNameController = useTextEditingController();
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    // Track original values to detect changes
    final originalBankName = useState<String?>(null);
    final originalAccountNumber = useState<String?>(null);
    final originalAccountName = useState<String?>(null);

    // Fetch business details and set initial values
    useEffect(() {
      viewModel.fetchBusinessInformation(businessId);
      return null;
    }, [businessId]);

    useEffect(() {
      if (viewModel.businessInfo != null && !viewModel.isLoading) {
        bankNameController.text = viewModel.businessInfo!.bankName?.toString() ?? '';
        accountNumberController.text = viewModel.businessInfo!.accountNumber?.toString() ?? '';
        accountNameController.text = viewModel.businessInfo!.accountName?.toString() ?? '';
        originalBankName.value = viewModel.businessInfo!.bankName?.toString();
        originalAccountNumber.value = viewModel.businessInfo!.accountNumber?.toString();
        originalAccountName.value = viewModel.businessInfo!.accountName?.toString();
      }
      return null;
    }, [viewModel.businessInfo, viewModel.isLoading]);

    // Function to check if there are any changes
    bool hasChanges() {
      return bankNameController.text != originalBankName.value ||
          accountNumberController.text != originalAccountNumber.value ||
          accountNameController.text != originalAccountName.value;
    }

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: SafeArea(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: responsiveData.scaleHeight(16)),
                      Text(
                        'Edit bank details',
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      Text(
                        'You can update your bank details here.',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(32)),
                      Text(
                        'Bank name',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      AppTextField(
                        hintText: 'Bank Name',
                        controller: bankNameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) => Validator.validateEmpty(val),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      Text(
                        'Account number',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      AppTextField(
                        hintText: 'Account number',
                        controller: accountNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (val) => Validator.validateEmpty(val),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      Text(
                        'Account name',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      AppTextField(
                        hintText: 'Account name',
                        /*fillColor: isDarkMode ? Colors.white24 : textFieldGrey,
                        filled: true,*/
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        controller: accountNameController,
                        validator: (val) => Validator.validateEmpty(val),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      AppButton(
                        buttonText: 'Update bank details',
                        textColor: Colors.white,
                        isProcessing: viewModel.isLoading,
                        onPressed: () {
                          _buildConfirmBankDetailsBottomSheet(context, viewModel, isDarkMode, () {
                            if (formKey.currentState!.validate() && hasChanges()) {
                              viewModel.updateBusinessInfo(
                                businessId,
                                bankName: bankNameController.text.trim(),
                                accountName: accountNameController.text.trim(),
                                accountNumber: accountNumberController.text.trim(),
                                navigateOnSuccess: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              );
                            }
                          });
                        },
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

  Future<dynamic> _buildConfirmBankDetailsBottomSheet(
      BuildContext context, BusinessDetailViewModel viewModel, bool isDarkMode, void Function() onPressed) {
    final responsiveData = ResponsiveInherited.of(context);
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(360),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(responsiveData.smallRadius * 2),
              topLeft: Radius.circular(responsiveData.smallRadius * 2),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveData.paddingHorizontal,
              vertical: responsiveData.scaleHeight(10),
            ),
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
                          color: isDarkMode ? Colors.white54 : const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(38),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Confirm Bank Details',
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: Responsive.fontSize(context, 22),
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black,
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
                    SizedBox(
                      height: responsiveData.scaleHeight(12),
                    ),
                    Center(
                      child: Text(
                        'Make sure your details are correct before continuing.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(47),
                    ),
                    AppButton(
                      isProcessing: viewModel.isLoading,
                      buttonText: 'Confirm',
                      onPressed: onPressed,
                      backgroundColor: isDarkMode ? Colors.white : primaryColor2,
                      textColor: isDarkMode ? Colors.black : Colors.white,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppButton(
                      buttonText: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: Colors.transparent,
                      textColor: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}