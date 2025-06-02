import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';
import '../gen/assets.gen.dart';
import '../utilities/responsive.dart';
import '../utilities/responsive_wrapper.dart';
import '../utilities/theme_mode.dart';
import 'app_naira.dart';

class TransactionTile extends HookWidget {
  String productName;
  String unitSold;
  String dateTime;
  String amount;
  String receiptOrInvoice;

  TransactionTile(
      {super.key,
        required this.amount,
        required this.dateTime,
        required this.productName,
        required this.receiptOrInvoice,
        required this.unitSold});

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return Container(
      height: responsiveData.scaleHeight(101),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: responsiveData.scaleHeight(72),
            width: responsiveData.scaleHeight(72),
            decoration: const BoxDecoration(color: Colors.black),
          ),
          SizedBox(
            width: responsiveData.scaleWidth(14),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(6),
                ),
                Row(
                  children: [
                    Text('$unitSold units sold',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: Responsive.fontSize(context, 14),
                            color: appGrey4)),
                    SizedBox(
                      width: responsiveData.scaleWidth(10),
                    ),
                    Container(
                      height: responsiveData.dotSize,
                      width: responsiveData.dotSize,
                      decoration: BoxDecoration(
                          color: appGrey4,
                          borderRadius: BorderRadius.circular(responsiveData.largeRadius)),
                    ),
                    SizedBox(
                      width: responsiveData.scaleWidth(10),
                    ),
                    Text(dateTime,
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: Responsive.fontSize(context, 14),
                            color: appGrey4)),
                  ],
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AppNaira(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        Text(amount,
                            style: Theme.of(context).textTheme.displayMedium!
                                .copyWith(fontSize: Responsive.fontSize(context, 14))),
                      ],
                    ),
                    Container(
                      height: responsiveData.scaleHeight(23),
                      padding: EdgeInsets.symmetric(
                          horizontal: responsiveData.scaleWidth(6),
                          vertical: responsiveData.scaleHeight(5)),
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? primaryColor2
                              : primaryColor2.withOpacity(0.2),
                          borderRadius:
                          BorderRadius.circular(responsiveData.smallRadius)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            receiptOrInvoice.trim().toLowerCase() == 'receipt'
                                ? Assets.svg.receipt
                                : Assets.svg.invoice,
                            colorFilter: ColorFilter.mode(
                                isDarkMode ? Colors.white : primaryColor2,
                                BlendMode.srcIn),
                          ),
                          Text(
                            receiptOrInvoice,
                            style: Theme.of(context).textTheme.displaySmall!
                                .copyWith(
                                fontSize: Responsive.fontSize(context, 12),
                                color: isDarkMode ? Colors.white : primaryColor2),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}