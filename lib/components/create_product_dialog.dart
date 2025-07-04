import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/gen/assets.gen.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'app_button.dart';

class CreateProductDialog extends StatelessWidget {
  const CreateProductDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(responsiveData.scaleWidth(24)),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(responsiveData.largeRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.svg.product,
              height: responsiveData.scaleHeight(80),
              width: responsiveData.scaleWidth(80),
              colorFilter: ColorFilter.mode(
                isDarkMode ? Colors.white : Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: responsiveData.scaleHeight(24)),
            Text(
              'Create Your First Product',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: Responsive.fontSize(context, 20),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsiveData.scaleHeight(12)),
            Text(
              'Start building your inventory by adding your first product. This will help you generate receipts and invoices.',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: Responsive.fontSize(context, 14),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsiveData.scaleHeight(32)),
            AppButton(
              buttonText: 'Create Product',
              onPressed: () {
                Navigator.of(context).pop();
                locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.addProduct);
              },
            ),
            SizedBox(height: responsiveData.scaleHeight(8)),
            AppButton(
              buttonText: 'Maybe Later',
              backgroundColor: Colors.transparent,
              textColor: isDarkMode ? Colors.white : Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}