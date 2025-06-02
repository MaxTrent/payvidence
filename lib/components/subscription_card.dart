import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../gen/assets.gen.dart';
import '../utilities/responsive.dart';
import '../utilities/responsive_wrapper.dart';
import 'app_naira.dart';

class SubscriptionCard extends StatelessWidget {
  SubscriptionCard({
    required this.subscriptionTier,
    required this.price,
    this.active = false,
    this.recommended = false,
    this.checkOut = true,
    super.key,
  });

  String subscriptionTier;
  String price;
  bool active;
  bool recommended;
  bool checkOut;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffE3DDFF),
        borderRadius: BorderRadius.circular(responsiveData.smallRadius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsiveData.paddingHorizontal,
          vertical: responsiveData.scaleHeight(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            recommended
                ? Container(
              height: responsiveData.scaleHeight(26),
              width: responsiveData.scaleWidth(108),
              decoration: BoxDecoration(
                color: const Color(0xff7767BD),
                borderRadius: BorderRadius.circular(responsiveData.smallRadius),
              ),
              child: Center(
                child: Text(
                  'RECOMMENDED',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: Responsive.fontSize(context, 12),
                    color: Colors.white,
                  ),
                ),
              ),
            )
                : const SizedBox.shrink(),
            recommended
                ? SizedBox(
              height: responsiveData.scaleHeight(10),
            )
                : const SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.svg.ribbon,
                      height: responsiveData.scaleHeight(24),
                      width: responsiveData.scaleWidth(24),
                    ),
                    SizedBox(
                      width: responsiveData.scaleWidth(8),
                    ),
                    Text(subscriptionTier),
                  ],
                ),
                active
                    ? Container(
                  height: responsiveData.scaleHeight(34),
                  width: responsiveData.scaleWidth(84),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(responsiveData.radius),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsiveData.scaleWidth(12),
                        vertical: responsiveData.scaleHeight(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.check,
                            size: responsiveData.scaleHeight(12),
                          ),
                          Text(
                            'Active',
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontSize: Responsive.fontSize(context, 14),
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ],
            ),
            SizedBox(
              height: responsiveData.scaleHeight(6),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppNaira(fontSize: 28),
                Text.rich(
                  TextSpan(
                    text: price,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '/year',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: const Color(0xff444444),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            checkOut
                ? SizedBox(
              height: responsiveData.scaleHeight(4),
            )
                : const SizedBox.shrink(),
            checkOut
                ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Check it out',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.black),
                ),
                SizedBox(
                  width: responsiveData.scaleWidth(8),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: responsiveData.scaleHeight(14),
                ),
              ],
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}