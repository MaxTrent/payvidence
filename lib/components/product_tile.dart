import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/model/product_model.dart';
import '../constants/app_colors.dart';
import '../utilities/responsive.dart';
import '../utilities/responsive_wrapper.dart';
import '../utilities/theme_mode.dart';
import '../gen/assets.gen.dart';

import 'app_naira.dart';

class ProductTile extends HookWidget {
  final Product product;
  final WidgetRef ref;
  final void Function() onPressed;

  const ProductTile({
    super.key,
    required this.product,
    required this.ref,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: responsiveData.scaleHeight(101),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: responsiveData.scaleHeight(72),
              width: responsiveData.scaleHeight(72),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: product.logoUrl != null && product.logoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              Assets.png.payvidenceLogo.path,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        Assets.png.payvidenceLogo.path,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
            SizedBox(width: responsiveData.scaleWidth(14)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(6)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${product.quantitySold.toString()} units sold',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: Responsive.fontSize(context, 14),
                          color: appGrey4,
                        ),
                      ),
                      SizedBox(width: responsiveData.scaleWidth(10)),
                      Container(
                        height: responsiveData.dotSize,
                        width: responsiveData.dotSize,
                        decoration: BoxDecoration(
                          color: appGrey4,
                          borderRadius: BorderRadius.circular(responsiveData.largeRadius),
                        ),
                      ),
                      SizedBox(width: responsiveData.scaleWidth(10)),
                      Text(
                        product.quantityAvailable == 0 
                            ? 'Out of stock'
                            : '${product.quantityAvailable.toString()} units left',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: Responsive.fontSize(context, 14),
                          color: product.quantityAvailable == 0 ? appRed : appGrey4,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppNaira(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      Text(
                        NumberFormat('#,###').format(
                            double.tryParse(product.price.toString()) ?? 0
                        ),
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: Responsive.fontSize(context, 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}