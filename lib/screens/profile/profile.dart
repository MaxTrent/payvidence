import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/profile/profile_vm.dart';
import 'package:payvidence/screens/splash.dart';
import 'package:payvidence/screens/update_personal_details/update_personal_details_vm.dart';
import 'package:payvidence/utilities/theme_mode.dart';
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

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 252.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor4,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SafeArea(
                child: Column(
                  children: [
                    8.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 73.h,
                              height: 73.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.w,
                                ),
                              ),
                              child: (useUpdatePersonalDetailsViewModel.userInfo?.account.profilePictureUrl != null)
                                  ? CachedNetworkImage(
                                imageUrl: useUpdatePersonalDetailsViewModel.userInfo!.account.profilePictureUrl!,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => SvgPicture.asset(
                                  Assets.svg.defaultProfilepic,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) => SvgPicture.asset(
                                  Assets.svg.defaultProfilepic,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : SvgPicture.asset(
                                Assets.svg.defaultProfilepic,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0.h,
                              right: 0.w,
                              child: GestureDetector(
                                onTap: () {
                                  locator<PayvidenceAppRouter>().navigateNamed(
                                      PayvidenceRoutes.changeProfilePicture);
                                },
                                child: CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(7.h),
                                    child:
                                        SvgPicture.asset(Assets.svg.editImage),
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
                                child:
                                    SvgPicture.asset(Assets.svg.notification)),
                            SizedBox(
                              width: 12.w,
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
                      height: 24.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(Assets.svg.ribbon),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  'Current subscription plan',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          fontSize: 14.sp, color: Colors.black),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
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
          Expanded(
            child: ListView(
              children: [
                ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.updatePersonalDetails);
                  },
                  title: 'Update personal details',
                  icon: Assets.svg.userSquare,
                ),
                SizedBox(
                  height: 24.h,
                ),
                ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.mySubscription);
                  },
                  icon: Assets.svg.medalStar,
                  title: 'Manage subscription plan',
                ),
                SizedBox(
                  height: 24.h,
                ),
                ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.businessData);
                  },
                  icon: Assets.svg.chart,
                  title: 'Access business data',
                ),
                SizedBox(
                  height: 24.h,
                ),
                ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.payvidenceInfo);
                  },
                  icon: Assets.svg.documentText,
                  title: 'View Payvidence information',
                ),
                SizedBox(
                  height: 24.h,
                ),
                ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    // Handle rate app logic if needed
                  },
                  icon: Assets.svg.like,
                  title: 'Rate app',
                ),
                SizedBox(
                  height: 24.h,
                ),
                ProfileOptionTile(
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
              ],
            ),
          ),
        ],
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
                  .copyWith(fontSize: 18.sp, color: color),
            ),
            leading: SvgPicture.asset(
              icon,
              height: 32.h,
              width: 32.w,
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
          thickness: 1.h,
        ),
      ],
    );
  }
}
