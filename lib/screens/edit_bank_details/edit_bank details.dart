import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/business_detail/business_detail_vm.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'Edit bank details',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'You can update your bank details here.',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Bank name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(height: 8.h),
                    AppTextField(
                      hintText: 'Bank Name',
                      controller: bankNameController,
                      keyboardType: TextInputType.name,

                      textCapitalization: TextCapitalization.words,
                      validator: (val) => Validator.validateEmpty(val),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Account number',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(height: 8.h),
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
                    SizedBox(height: 20.h),
                    Text(
                      'Account name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(height: 8.h),
                    AppTextField(
                      hintText: 'Account name',
                      fillColor: borderColor,
                      filled: true,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      controller: accountNameController,
                      validator: (val) => Validator.validateEmpty(val),
                    ),
                    SizedBox(height: 20.h),
                    AppButton(
                      buttonText: 'Update bank details',
                      // isDisabled: !hasChanges(),
                      isProcessing: viewModel.isLoading,
                      onPressed: () {
                        if (formKey.currentState!.validate() && hasChanges()) {
                          viewModel.updateBusinessInfo(
                            businessId,
                            bankName: bankNameController.text.trim(),
                            accountName: accountNameController.text.trim(),
                            accountNumber: accountNumberController.text.trim(),

                            navigateOnSuccess: () {
                             Navigator.pop(context);
                            },
                          );
                        }
                      },
                    ),
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