import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/screens/profile/profile.dart';

import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'BusinessDataRoute')
class BusinessData extends HookWidget {
  const BusinessData({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Business data',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            ProfileOptionTile(
                onTap: () {
                  locator<PayvidenceAppRouter>()
                      .navigateNamed(PayvidenceRoutes.allBusiness);
                },
              isDarkMode: isDarkMode,
                icon: Assets.svg.shop, title: 'Businesses'),
            SizedBox(
              height: 28.h,
            ),
            ProfileOptionTile(
                onTap: () {
                  locator<PayvidenceAppRouter>()
                      .navigateNamed(PayvidenceRoutes.allReceipts);
                },
              isDarkMode: isDarkMode,
                icon: Assets.svg.receipt, title: 'Receipts'),
            SizedBox(
              height: 28.h,
            ),
            ProfileOptionTile(
                onTap: () {
                  locator<PayvidenceAppRouter>()
                      .navigateNamed(PayvidenceRoutes.allInvoices);
                },
              isDarkMode: isDarkMode,
                icon: Assets.svg.invoice, title: 'Invoices'),
            SizedBox(
              height: 28.h,
            ),
            ProfileOptionTile(
                onTap: () {
                  locator<PayvidenceAppRouter>()
                      .navigateNamed(PayvidenceRoutes.clients);
                },
              isDarkMode: isDarkMode,
               icon: Assets.svg.client, title: 'Clients'),
            SizedBox(
              height: 28.h,
            ),
            ProfileOptionTile(
                onTap: () {
                  locator<PayvidenceAppRouter>()
                      .navigateNamed(PayvidenceRoutes.product);
                },
              isDarkMode: isDarkMode,
                icon: Assets.svg.product, title: 'Products'),
          ],
        ),
      ),
    );
  }
}
