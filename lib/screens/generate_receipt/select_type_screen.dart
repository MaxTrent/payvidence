import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../providers/product_providers/current_product_provider.dart';

@RoutePage(name: 'SelectTypeRoute')
class SelectTypeScreen extends ConsumerWidget {
  final bool? isInvoice;
  
  const SelectTypeScreen({super.key, this.isInvoice = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Select Type',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: responsiveData.scaleHeight(24)),
                Text(
                  'What would you like to generate?',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: responsiveData.scaleHeight(8)),
                Text(
                  'Select whether you want to generate a ${isInvoice! ? "invoice" : "receipt"} for products or services.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: responsiveData.scaleHeight(40)),
                _buildOptionCard(
                  context,
                  responsiveData,
                  isDarkMode,
                  'Products',
                  'Generate ${isInvoice! ? "invoice" : "receipt"} for physical products',
                  () {
                    ref.read(getCurrentProductProvider.notifier).state = null;
                    locator<PayvidenceAppRouter>().navigate(
                      GenerateReceiptRoute(isInvoice: isInvoice, isService: false)
                    );
                  },
                ),
                SizedBox(height: responsiveData.scaleHeight(16)),
                _buildOptionCard(
                  context,
                  responsiveData,
                  isDarkMode,
                  'Services',
                  'Generate ${isInvoice! ? "invoice" : "receipt"} for services',
                  () {
                    ref.read(getCurrentProductProvider.notifier).state = null;
                    locator<PayvidenceAppRouter>().navigate(
                      GenerateReceiptRoute(isInvoice: isInvoice, isService: true)
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    ResponsiveData responsiveData,
    bool isDarkMode,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(responsiveData.scaleHeight(20)),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(responsiveData.smallRadius),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.fontSize(context, 18),
              ),
            ),
            SizedBox(height: responsiveData.scaleHeight(8)),
            Text(
              description,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(height: responsiveData.scaleHeight(16)),
            AppButton(
              buttonText: 'Select',
              onPressed: onTap,
              height: responsiveData.scaleHeight(40),
            ),
          ],
        ),
      ),
    );
  }
}