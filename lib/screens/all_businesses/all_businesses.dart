import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';

import '../../components/business_card.dart';
import '../../model/business_model.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'AllBusinessesRoute')
class AllBusinesses extends ConsumerWidget {
  final List<Business> allBusiness;
  const AllBusinesses(this.allBusiness, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 16.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All businesses',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                GestureDetector(
                  onTap: () {
                    locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.addBusiness);
                  },
                  child: Text('+ Add New',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 14.sp, color: primaryColor2)),
                )
              ],
            ),
            SizedBox(
              height: 32.h,
            ),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return BusinessCard(
                      business: allBusiness[index],
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return SizedBox(
                      height: 24.h,
                    );
                  },
                  itemCount: allBusiness.length),
            ),
          ],
        ),
      ),
    );
  }
}
