import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/app_naira.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/screens/all_receipts/all_receipts.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';

@RoutePage(name: 'TransactionDetailsRoute')
class TransactionDetails extends HookConsumerWidget {
  final Receipt transaction;
  final bool isInvoice;

  const TransactionDetails({
    super.key,
    required this.transaction,
    this.isInvoice = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);

    double calculateSubtotal() {
      return transaction.recordProductDetails.fold(0.0, (sum, detail) {
        final price = double.tryParse(detail.price ?? '0') ?? 0.0;
        final quantity = detail.quantity ?? 1;
        return sum + (price * quantity);
      });
    }

    double calculateDiscountAmount() {
      return transaction.recordProductDetails.fold(0.0, (sum, detail) {
        final price = double.tryParse(detail.price ?? '0') ?? 0.0;
        final quantity = detail.quantity ?? 1;
        final discount = double.tryParse(detail.discount ?? '0') ?? 0.0;
        return sum + ((price * quantity) * (discount / 100));
      });
    }

    double calculateTotal() {
      final total = double.tryParse(transaction.total ?? '0') ?? 0.0;
      return total;
    }

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Transaction details',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: responsiveData.scaleHeight(16)),
              ReceiptTile(receipt: transaction),
              SizedBox(height: responsiveData.scaleHeight(24)),
              if (transaction.isCancelled == true) ...[
                Text(
                  'Reason for cancellation',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: responsiveData.scaleHeight(10)),
                Text(
                  transaction.cancellationReason ?? 'No reason provided',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: responsiveData.scaleHeight(32)),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Client name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    transaction.client?.name ?? 'Unknown Client',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
              if (!isInvoice)
                SizedBox(height: responsiveData.scaleHeight(24)),
              if (!isInvoice)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mode of payment',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      transaction.modeOfPayment?.replaceAll('_', ' ') ?? 'Not specified',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              SizedBox(height: responsiveData.scaleHeight(24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal amount',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Row(
                    children: [
                      AppNaira(fontSize: 14),
                      Text(
                        calculateSubtotal().toString().toCommaSeparated(),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: responsiveData.scaleHeight(24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discount amount',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Row(
                    children: [
                      AppNaira(fontSize: 14),
                      Text(
                        calculateDiscountAmount().toString().toCommaSeparated(),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: responsiveData.scaleHeight(24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total amount',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      AppNaira(fontSize: 14),
                      Text(
                        calculateTotal().toString().toCommaSeparated(),
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          SizedBox(height: responsiveData.scaleHeight(24)),
              if (transaction.isCancelled != true && transaction.canBeCancelled == true) ...[
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        locator<PayvidenceAppRouter>().navigate(
                          CancelTransactionRoute(
                            transaction: transaction,
                            isInvoice: isInvoice,
                          ),
                        );
                      },
                      child: Text(
                        'Cancel transaction',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: responsiveData.scaleHeight(40)),
              AppButton(
                buttonText: 'View transaction ${isInvoice ? 'invoice' : 'receipt'}',
                onPressed: () {
                  locator<PayvidenceAppRouter>().navigate(
                    ReceiptScreenRoute(
                      record: transaction,
                      isInvoice: isInvoice,
                      source: 'transaction_details',
                    ),
                  );
                },
              ),
              SizedBox(height: responsiveData.scaleHeight(26)),
              GestureDetector(
                onTap: transaction.isCancelled == true ? null : () {
                  locator<PayvidenceAppRouter>().navigate(
                    GenerateReceiptRoute(
                      isInvoice: isInvoice,
                      isService: transaction.recordProductDetails.any((detail) => detail.isService ?? false),
                      existingReceipt: transaction,
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    'Re-issue ${isInvoice ? 'invoice' : 'receipt'}',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(
                          color: transaction.isCancelled == true ? Colors.grey : primaryColor2,
                        ),
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