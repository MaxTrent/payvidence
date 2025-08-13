import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/screens/all_transactions/all_transactions_vm.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';

import '../../components/app_button.dart';
import '../../components/simple_bottom_sheet.dart';
import '../../constants/app_colors.dart';
import '../../data/api_services.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'CancelTransactionRoute')
class CancelTransaction extends HookConsumerWidget {
  final Receipt transaction;
  final bool isInvoice;

  const CancelTransaction({
    super.key,
    required this.transaction,
    this.isInvoice = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);
    final reasonController = useTextEditingController();
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final isLoading = useState(false);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
        ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(20)),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cancel transaction', style: Theme.of(context).textTheme.displayLarge,),
           SizedBox(height: responsiveData.scaleHeight(8)),
             Text('Give a reason to confirm you want to cancel this transaction.', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: responsiveData.scaleHeight(32)),
              Text('Cancellation reason', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: responsiveData.scaleHeight(8)),
              Container(
                height: responsiveData.scaleHeight(128),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(responsiveData.scaleHeight(8)),
                ),
                child: TextField(
                  controller: reasonController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: Theme.of(context).textTheme.displaySmall,
                  decoration: InputDecoration(
                    hintText: 'Cancellation reason',
                    hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(responsiveData.scaleHeight(12)),
                  ),
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(40)),
              AppButton(
                backgroundColor: appRed,
                buttonText: 'Confirm cancellation',
                isProcessing: isLoading.value,
                onPressed: isLoading.value ? null : () async {
                  final result = await showModalBottomSheet<bool>(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    clipBehavior: Clip.none,
                    context: context,
                    builder: (context) => SimpleBottomSheet(
                      isDarkMode: isDarkMode,
                      title: 'Cancel Transaction',
                      subtitle: 'Are you sure you want to cancel this transaction?',
                      height: 400,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(true),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: appRed,
                                ),
                                SizedBox(width: responsiveData.scaleWidth(16)),
                                Text(
                                  'Yes, cancel transaction',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                    fontSize: Responsive.fontSize(context, 14),
                                    color: appRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: responsiveData.scaleHeight(1)),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(false),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.close,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                SizedBox(width: responsiveData.scaleWidth(16)),
                                Text(
                                  'No, keep transaction',
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
                  if (result == true) {
                    if (reasonController.text.trim().isEmpty) {
                      ToastService.showErrorSnackBar('Please provide a cancellation reason');
                      return;
                    }
                    
                    try {
                      isLoading.value = true;
                      final apiResult = await locator<ApiServices>().cancelTransaction(
                        transaction.id!,
                        reasonController.text.trim(),
                      );
                      isLoading.value = false;
                      
                      if (apiResult.success) {
                        ToastService.showSnackBar('Transaction cancelled successfully');
                        // Refresh the receipts data
                        ref.invalidate(getAllReceiptProvider);
                        ref.invalidate(getAllInvoiceProvider);
                        // Refresh transactions list
                        final businessId = ref.read(getCurrentBusinessProvider)?.id;
                        if (businessId != null) {
                          ref.read(allTransactionsViewModelProvider).forceRefreshTransactions(businessId);
                        }
                        locator<PayvidenceAppRouter>().navigate(const HomePageRoute());
                      } else {
                        final errorMessage = apiResult.error?.errors?.isNotEmpty == true 
                            ? apiResult.error!.errors!.first.message ?? apiResult.error?.message ?? 'Failed to cancel transaction'
                            : apiResult.error?.message ?? 'Failed to cancel transaction';
                        ToastService.showErrorSnackBar(errorMessage);
                      }
                    } catch (e) {
                      isLoading.value = false;
                      ToastService.showErrorSnackBar('Failed to cancel transaction');
                    }
                  }
                },
              ),
              SizedBox(height: responsiveData.scaleHeight(26)),
              GestureDetector(
                onTap: () {
                  locator<PayvidenceAppRouter>().back();
                },
                child: Center(
                  child: Text(
                    'Go back',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(32)),

            ],
          ),
        ),
      ),
    );
  }
}