import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/my_subscription/my_subscription_vm.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/subscription_card.dart';
import '../../gen/assets.gen.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'MySubscriptionRoute')
class MySubscription extends HookConsumerWidget {
  const MySubscription({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(mySubscriptionViewModel);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    useEffect(() {
      viewModel.fetchSubscriptions();
      return null;
    }, []);

    Future<void> onRefresh() async {
      await viewModel.fetchSubscriptions();
    }

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My subscription',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: responsiveData.scaleHeight(24),
              ),
              Expanded(
                child: PullToRefresh(
                  onRefresh: onRefresh,
                  child: ListView(
                    children: [
                      SubscriptionCard(
                        subscriptionTier:
                        viewModel.subInfo?.plan.name ?? "Starter subscription plan",
                        price: viewModel.subInfo?.plan.amount ?? '0',
                        checkOut: false,
                        active: viewModel.subInfo?.status == "active",
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(32),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current plan',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Row(
                            children: [
                              Container(
                                height: responsiveData.scaleHeight(12),
                                width: responsiveData.scaleHeight(12),
                                decoration: const BoxDecoration(
                                  color: primaryColor2,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: responsiveData.scaleWidth(6),
                              ),
                              Text(
                                viewModel.subInfo?.plan.name ?? 'Starter',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      viewModel.subInfo?.startDate == null
                          ? const SizedBox.shrink()
                          : SizedBox(
                        height: responsiveData.scaleHeight(18),
                      ),
                      viewModel.subInfo?.startDate == null
                          ? const SizedBox.shrink()
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subscription date',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            viewModel.subInfo!.startDate.toFormattedString(),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                      viewModel.subInfo?.startDate == null
                          ? const SizedBox.shrink()
                          : SizedBox(
                        height: responsiveData.scaleHeight(18),
                      ),
                      viewModel.subInfo?.expiryDate == null
                          ? const SizedBox.shrink()
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Expiration date',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            viewModel.subInfo?.expiryDate.toFormattedString() ??
                                "Not available",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(40),
                      ),
                      viewModel.subInfo == null
                          ? const SizedBox.shrink()
                          : _buildSubscriptionHistory(context, viewModel),
                      AppButton(
                        buttonText: 'Manage subscription',
                        onPressed: () {
                          _buildManageSubscriptionBottomSheet(context, isDarkMode, viewModel);
                        },
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(26),
                      ),
                      viewModel.subInfo?.startDate == null
                          ? const SizedBox.shrink()
                          : GestureDetector(
                        onTap: () {
                          _buildCancelSubBottomSheet(context, viewModel);
                        },
                        child: Center(
                          child: Text(
                            'Cancel subscription',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: appRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionHistory(
      BuildContext context, MySubscriptionViewModel viewModel) {
    final responsiveData = ResponsiveInherited.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription history',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        SizedBox(
          height: responsiveData.scaleHeight(12),
        ),
        ...viewModel.expiredSubscriptions.map(
              (sub) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              height: responsiveData.scaleHeight(56),
              width: responsiveData.scaleWidth(56),
              decoration: const BoxDecoration(
                color: primaryColor4,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(responsiveData.scaleHeight(14)),
                child: SvgPicture.asset(
                  Assets.svg.ribbon,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.plan.name,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: Responsive.fontSize(context, 16)),
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(8),
                ),
                Text(
                  '₦${sub.plan.amount}',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: Responsive.fontSize(context, 16)),
                ),
              ],
            ),
            trailing: Text(
              sub.startDate.toFormattedString(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(
                fontSize: Responsive.fontSize(context, 14),
                color: const Color(0xff979797),
              ),
            ),
          ),
        ),
        SizedBox(
          height: responsiveData.scaleHeight(60),
        ),
      ],
    );
  }

  Future<dynamic> _buildManageSubscriptionBottomSheet(
      BuildContext context, bool isDarkMode, MySubscriptionViewModel viewModel) {
    final responsiveData = ResponsiveInherited.of(context);

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: viewModel.subInfo?.startDate == null
              ? responsiveData.scaleHeight(300)
              : responsiveData.scaleHeight(398),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(responsiveData.smallRadius),
              topLeft: Radius.circular(responsiveData.smallRadius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveData.paddingHorizontal,
              vertical: responsiveData.scaleHeight(10),
            ),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(140)),
                      child: Container(
                        height: responsiveData.scaleHeight(5),
                        width: responsiveData.scaleWidth(67),
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(38),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Manage subscription',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                              fontSize: Responsive.fontSize(context, 22),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(12),
                    ),
                    Center(
                      child: Text(
                        'What will you like to do?',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(40),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        locator<PayvidenceAppRouter>()
                            .navigateNamed(PayvidenceRoutes.chooseSubscriptionPlan);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.svg.otherplans,
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? Colors.white : Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(
                              width: responsiveData.scaleWidth(16),
                            ),
                            Text(
                              'Check out other plans',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: Responsive.fontSize(context, 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    viewModel.subInfo?.startDate == null
                        ? const SizedBox.shrink()
                        : Divider(
                      height: responsiveData.scaleHeight(1),
                    ),
                    viewModel.subInfo?.startDate == null
                        ? const SizedBox.shrink()
                        : Padding(
                      padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.svg.renewplan,
                            colorFilter: ColorFilter.mode(
                              isDarkMode ? Colors.white : Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(
                            width: responsiveData.scaleWidth(16),
                          ),
                          Text(
                            'Renew plan',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: Responsive.fontSize(context, 14)),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: responsiveData.scaleHeight(1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _buildCancelSubBottomSheet(
      BuildContext context, MySubscriptionViewModel viewModel) {
    final responsiveData = ResponsiveInherited.of(context);

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(398),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(responsiveData.smallRadius),
              topLeft: Radius.circular(responsiveData.smallRadius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveData.paddingHorizontal,
              vertical: responsiveData.scaleHeight(10),
            ),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(140)),
                      child: Container(
                        height: responsiveData.scaleHeight(5),
                        width: responsiveData.scaleWidth(67),
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(38),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Cancel subscription',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                              fontSize: Responsive.fontSize(context, 22),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(12),
                    ),
                    Center(
                      child: Text(
                        'There will be no refund for cancelled\n\nsubscription. Are you sure you want to cancel?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(47),
                    ),
                    AppButton(
                      buttonText: 'Yes, cancel subscription',
                      onPressed: () {
                        // viewModel.cancelSubscription(onSuccess: () {
                        //   Navigator.of(context).pop();
                        //   ToastService.showSnackBar('Subscription cancelled.');
                        // });
                      },
                      backgroundColor: appRed,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppButton(
                      buttonText: 'Cancel',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      backgroundColor: Colors.transparent,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}