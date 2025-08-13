import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../all_receipts/receipt_screen.dart';

@RoutePage(name: 'ReceiptPreviewRoute')
class ReceiptPreview extends ConsumerWidget {
  final Receipt record;
  final bool? isInvoice;
  final bool? isService;

  const ReceiptPreview({
    super.key,
    required this.record,
    this.isInvoice = false,
    this.isService = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Stack(
          children: [
            // Receipt content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: responsiveData.scaleHeight(32)),
                    ContainerWithClippedCircles(
                      record: record,
                      isInvoice: isInvoice ?? false,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(120)),
                  ],
                ),
              ),
            ),
            // White overlay with buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: responsiveData.scaleHeight(200),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(responsiveData.largeRadius),
                    topRight: Radius.circular(responsiveData.largeRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, -2),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveData.paddingHorizontal,
                    vertical: responsiveData.scaleHeight(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        buttonText: 'Continue',
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      SizedBox(height: responsiveData.scaleHeight(16)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Center(
                          child: Text(
                            'Edit ${isInvoice == true ? "invoice" : "receipt"}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: primaryColor2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}