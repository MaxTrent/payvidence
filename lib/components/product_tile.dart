import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/model/product_model.dart';

import '../constants/app_colors.dart';
import '../routes/payvidence_app_router.dart';
import '../routes/payvidence_app_router.gr.dart';
import '../shared_dependency/shared_dependency.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<PayvidenceAppRouter>()
            .navigateNamed(PayvidenceRoutes.productDetails);
      },
      child: Container(
        height: 101.h,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 72.h,
              width: 72.h,
              decoration: const BoxDecoration(color: Colors.black),
            ),
            SizedBox(
              width: 14.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: 6.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${product.quantitySold.toString()} units sold',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 14.sp, color: appGrey4)),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      height: 6.h,
                      width: 6.h,
                      decoration: BoxDecoration(
                          color: appGrey4,
                          borderRadius: BorderRadius.circular(24.r)),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text('${product.quantityAvailable.toString()} units left',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 14.sp, color: appGrey4)),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(product.price ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 14.sp)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
