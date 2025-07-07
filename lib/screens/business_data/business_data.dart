import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/screens/profile/profile.dart';
import '../../gen/assets.gen.dart';
import '../../providers/business_providers/current_business_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'BusinessDataRoute')
class BusinessData extends HookConsumerWidget {
  const BusinessData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: responsiveData.scaleHeight(16),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
                  child: Text(
                    'Business data',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(60),
                ),
                ProfileOptionTile(
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.allBusiness);
                  },
                  isDarkMode: isDarkMode,
                  icon: Assets.svg.shop,
                  title: 'Businesses',
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(28),
                ),
                ProfileOptionTile(
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.allReceipts);
                  },
                  isDarkMode: isDarkMode,
                  icon: Assets.svg.receipt,
                  title: 'Receipts',
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(28),
                ),
                ProfileOptionTile(
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.allInvoices);
                  },
                  isDarkMode: isDarkMode,
                  icon: Assets.svg.invoice,
                  title: 'Invoices',
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(28),
                ),
                ProfileOptionTile(
                  onTap: () {
                    final businessId = ref.read(getCurrentBusinessProvider)?.id ?? '';
                    locator<PayvidenceAppRouter>().navigate(ClientsRoute(businessId: businessId));
                  },
                  isDarkMode: isDarkMode,
                  icon: Assets.svg.client,
                  title: 'Clients',
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(28),
                ),
                ProfileOptionTile(
                  onTap: () {
                    locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.product);
                  },
                  isDarkMode: isDarkMode,
                  icon: Assets.svg.product,
                  title: 'Products',
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}