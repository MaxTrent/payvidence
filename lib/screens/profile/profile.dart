import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/profile/profile_vm.dart';
import 'package:payvidence/screens/splash.dart';
import 'package:payvidence/screens/update_personal_details/update_personal_details_vm.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import 'package:payvidence/utilities/animations.dart';
import '../../components/loading_dialog.dart';
import '../../gen/assets.gen.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../my_subscription/my_subscription_vm.dart';

@RoutePage(name: 'ProfileRoute')
class Profile extends HookConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(profileViewModelProvider);
    final useMySubscriptionViewModel = ref.watch(mySubscriptionViewModel);
    final useUpdatePersonalDetailsViewModel =
    ref.watch(updatePersonalDetailsViewModelProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);
    // final rateMyApp = RateMyApp(
    //   minDays: 7, // Show after 7 days
    //   minLaunches: 10, // Show after 10 launches
    //   remindDays: 7, // Remind after 7 days if postponed
    //   remindLaunches: 5, // Remind after 5 launches if postponed
    //   googlePlayIdentifier: '',
    //   appStoreIdentifier: '',
    // );

    useEffect(() {
      Future.microtask(() {
        useUpdatePersonalDetailsViewModel.fetchUserInformation();
        useMySubscriptionViewModel.fetchSubscriptions();
      });
      return null;
    }, []);

    print('Profile: Theme mode = ${theme.mode}, Brightness = ${Theme.of(context).brightness}');

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        body: Column(
          children: [
            FadeInWidget(
              child: Container(
                height: responsiveData.scaleHeight(252),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor4,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(responsiveData.smallRadius * 0.6), // Approx 12.r equivalent
                    bottomRight: Radius.circular(responsiveData.smallRadius * 0.6), // Approx 12.r equivalent
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: responsiveData.scaleHeight(73),
                                height: responsiveData.scaleHeight(73),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: responsiveData.scaleWidth(1),
                                  ),
                                ),
                                child: (useUpdatePersonalDetailsViewModel.userInfo?.account.profilePictureUrl != null && useUpdatePersonalDetailsViewModel.userInfo!.account.profilePictureUrl!.isNotEmpty)
                                    ? CachedNetworkImage(
                                  key: ValueKey('${useUpdatePersonalDetailsViewModel.userInfo!.account.profilePictureUrl!}_${DateTime.now().millisecondsSinceEpoch}'),
                                  imageUrl: '${useUpdatePersonalDetailsViewModel.userInfo!.account.profilePictureUrl!}?t=${DateTime.now().millisecondsSinceEpoch}',
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFE8E8E8),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: responsiveData.scaleHeight(40),
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFE8E8E8),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: responsiveData.scaleHeight(40),
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                )
                                    : Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE8E8E8),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: responsiveData.scaleHeight(40),
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    await locator<PayvidenceAppRouter>().navigateNamed(
                                        PayvidenceRoutes.changeProfilePicture);
                                    // Refresh user info when returning from change profile picture
                                    useUpdatePersonalDetailsViewModel.fetchUserInformation();
                                  },
                                  child: CircleAvatar(
                                    radius: responsiveData.smallRadius * 0.7,
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(responsiveData.scaleHeight(5)),
                                      child: SvgPicture.asset(Assets.svg.editImage),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    locator<PayvidenceAppRouter>().navigateNamed(
                                        PayvidenceRoutes.notifications);
                                  },
                                  child: SvgPicture.asset(Assets.svg.notification)),
                              SizedBox(
                                width: responsiveData.scaleWidth(12),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    locator<PayvidenceAppRouter>()
                                        .navigateNamed(PayvidenceRoutes.settings);
                                  },
                                  child: SvgPicture.asset(Assets.svg.setting2)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(24),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(responsiveData.smallRadius * 0.6), // Approx 12.r equivalent
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsiveData.scaleWidth(16),
                              vertical: responsiveData.scaleHeight(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(Assets.svg.ribbon),
                                  SizedBox(
                                    width: responsiveData.scaleWidth(2),
                                  ),
                                  Text(
                                    'Current subscription plan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                        fontSize: Responsive.fontSize(context, 14),
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: responsiveData.scaleHeight(2),
                              ),
                              Text(
                                useMySubscriptionViewModel.subInfo?.plan.name ??
                                    'Starter plan',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  SlideInWidget(
                    begin: const Offset(0, 0.3),
                    delay: const Duration(milliseconds: 100),
                    child: ProfileOptionTile(
                      isDarkMode: isDarkMode,
                      onTap: () {
                        locator<PayvidenceAppRouter>()
                            .navigateNamed(PayvidenceRoutes.updatePersonalDetails);
                      },
                      title: 'Update personal details',
                      icon: Assets.svg.userSquare,
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(24),
                  ),
                  SlideInWidget(
                    begin: const Offset(0, 0.3),
                    delay: const Duration(milliseconds: 150),
                    child: ProfileOptionTile(
                      isDarkMode: isDarkMode,
                      onTap: () {
                        locator<PayvidenceAppRouter>()
                            .navigateNamed(PayvidenceRoutes.mySubscription);
                      },
                      icon: Assets.svg.medalStar,
                      title: 'Manage subscription plan',
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(24),
                  ),
                  SlideInWidget(
                    begin: const Offset(0, 0.3),
                    delay: const Duration(milliseconds: 200),
                    child: ProfileOptionTile(
                      isDarkMode: isDarkMode,
                      onTap: () {
                        locator<PayvidenceAppRouter>()
                            .navigateNamed(PayvidenceRoutes.businessData);
                      },
                      icon: Assets.svg.chart,
                      title: 'Access business data',
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(24),
                  ),
                  SlideInWidget(
                    begin: const Offset(0, 0.3),
                    delay: const Duration(milliseconds: 250),
                    child: ProfileOptionTile(
                      isDarkMode: isDarkMode,
                      onTap: () {
                        locator<PayvidenceAppRouter>()
                            .navigateNamed(PayvidenceRoutes.payvidenceInfo);
                      },
                      icon: Assets.svg.documentText,
                      title: 'View Payvidence information',
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(24),
                  ),
                  SlideInWidget(
                    begin: const Offset(0, 0.3),
                    delay: const Duration(milliseconds: 300),
                    child: ProfileOptionTile(
                      isDarkMode: isDarkMode,
                      onTap: () {
                        // Handle rate app logic if needed
                      },
                      icon: Assets.svg.like,
                      title: 'Rate app',
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(24),
                  ),
                  SlideInWidget(
                    begin: const Offset(0, 0.3),
                    delay: const Duration(milliseconds: 350),
                    child: ProfileOptionTile(
                      onTap: () {
                        if (!context.mounted) return;
                        LoadingDialog.show(context);
                        viewModel.logout(navigateOnSuccess: () async {
                          locator<PayvidenceAppRouter>()
                              .popUntil((route) => route is SplashScreen);
                          locator<PayvidenceAppRouter>()
                              .navigateNamed(PayvidenceRoutes.onboarding);
                        });
                      },
                      icon: Assets.svg.logout,
                      title: 'Log out',
                      showTrailing: false,
                      color: appRed,
                      isLogout: true,
                      isDarkMode: isDarkMode,
                    ),
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

class ProfileOptionTile extends ConsumerWidget {
  const ProfileOptionTile({
    required this.icon,
    required this.title,
    this.showTrailing = true,
    this.color,
    this.onTap,
    this.isLogout = false,
    required this.isDarkMode,
    super.key,
  });

  final String title;
  final String icon;
  final bool showTrailing;
  final Color? color;
  final bool isLogout;
  final bool isDarkMode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(profileViewModelProvider);
    final responsiveData = ResponsiveInherited.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: viewModel.isLoading ? null : onTap,
          child: ListTile(
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: Responsive.fontSize(context, 18), color: color),
            ),
            leading: SvgPicture.asset(
              icon,
              height: responsiveData.scaleHeight(32),
              width: responsiveData.scaleWidth(32),
              colorFilter: ColorFilter.mode(
                isLogout
                    ? appRed
                    : isDarkMode
                    ? Colors.white
                    : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            trailing: showTrailing
                ? const Icon(Icons.keyboard_arrow_right)
                : const SizedBox(),
          ),
        ),
        Divider(
          thickness: responsiveData.scaleHeight(1),
        ),
      ],
    );
  }
}