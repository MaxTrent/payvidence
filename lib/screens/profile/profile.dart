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
import 'package:payvidence/screens/update_personal_details/update_personal_details_vm.dart';
import '../../components/loading_dialog.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../gen/assets.gen.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../my_subscription/my_subscription_vm.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'ProfileRoute')
class Profile extends HookConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(profileViewModelProvider);
    final useMySubscriptionViewModel = ref.watch(mySubscriptionViewModel);
    final useUpdatePersonalDetailsViewModel =
        ref.watch(updatePersonalDetailsViewModelProvider);

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
        // rateMyApp.init();
      });
      return null;
    }, []);

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
                                  color: Colors.white, // Border color
                                  width: 1.w, // Border thickness
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 36.r,
                                // backgroundColor: Colors
                                //     .grey.shade200,
                                child: useUpdatePersonalDetailsViewModel
                                            .userInfo
                                            ?.account
                                            .profilePictureUrl !=
                                        null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            useUpdatePersonalDetailsViewModel
                                                .userInfo!
                                                .account
                                                .profilePictureUrl!,
                                        placeholder: (context, url) =>
                                            SvgPicture.asset(
                                                Assets.svg.defaultProfilepic),
                                        errorWidget: (context, url, error) =>
                                            SvgPicture.asset(
                                                Assets.svg.defaultProfilepic),
                                        fit: BoxFit.cover,
                                      )
                                    : SvgPicture.asset(
                                        Assets.svg.defaultProfilepic),
                              ),
                            ),
                            Positioned(
                              bottom: 0.h,
                              right: 0.w,
                              child: GestureDetector(
                                onTap: () {
                                  locator<PayvidenceAppRouter>().navigateNamed(
                                      PayvidenceRoutes.changeProfilePicture);
                                  // context.router.push(ChangeProfilePictureRoute());
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
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      // height: 80.h,
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
                                      .copyWith(fontSize: 14.sp),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2..h,
                            ),
                            Text(
                              useMySubscriptionViewModel.subInfo?.plan.name ??
                                  'Starter plan',
                              style: Theme.of(context).textTheme.displayLarge,
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
          // Text('Profile ooo'),
          Expanded(
            child: ListView(
              children: [
                // SizedBox(
                //   height: 20.h,
                // ),
                ProfileOptionTile(
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
                    onTap: () {
                      locator<PayvidenceAppRouter>()
                          .navigateNamed(PayvidenceRoutes.mySubscription);

                      // context.router.push(MySubscriptionRoute());
                    },
                    icon: Assets.svg.medalStar,
                    title: 'Manage subscription plan'),
                SizedBox(
                  height: 24.h,
                ),
                // ProfileOptionTile(
                //     onTap: () {
                //       locator<PayvidenceAppRouter>()
                //           .navigateNamed(PayvidenceRoutes.businessData);
                //       // context.router.push(BusinessDataRoute());
                //     },
                //     // navigateTo: ,
                //     icon: Assets.svg.chart,
                //     title: 'Access business data'),
                // SizedBox(
                //   height: 24.h,
                // ),
                ProfileOptionTile(
                    onTap: () {
                      locator<PayvidenceAppRouter>()
                          .navigateNamed(PayvidenceRoutes.payvidenceInfo);
                      // context.router.push(PayvidenceInfoRoute());
                    },
                    icon: Assets.svg.documentText,
                    title: 'View Payvidence information'),
                SizedBox(
                  height: 24.h,
                ),
                ProfileOptionTile(
                    onTap: () {
                      // rateMyApp.showRateDialog(
                      //   context,
                      //   title: 'Rate Payvidence',
                      //   message: 'If you enjoy using Payvidence, would you mind rating us?',
                      //   rateButton: 'Rate Now',
                      //   noButton: 'No Thanks',
                      //   laterButton: 'Maybe Later',
                      //   onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
                      // );
                    },
                    icon: Assets.svg.like,
                    title: 'Rate app'),
                SizedBox(
                  height: 24.h,
                ),
                ProfileOptionTile(
                  onTap: () {
                    if (!context.mounted) return;
                    LoadingDialog.show(context);
                    viewModel.logout(navigateOnSuccess: () async {
                      // locator<SessionManager>().clear();

                      locator<PayvidenceAppRouter>()
                          .popUntil((route) => route is OnboardingScreen);
                      locator<PayvidenceAppRouter>()
                          .navigateNamed(PayvidenceRoutes.login);
                    });
                  },
                  icon: Assets.svg.logout,
                  title: 'Log out',
                  showTrailing: false,
                  color: appRed,
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
  ProfileOptionTile({
    required this.icon,
    required this.title,
    this.showTrailing = true,
    // required this.navigateTo,
    this.color,
    this.onTap,
    super.key,
  });

  String title;
  String icon;
  bool showTrailing;
  Color? color;
  // String navigateTo;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(profileViewModelProvider);

    return Column(
      children: [
        GestureDetector(
          onTap: viewModel.isLoading ? null : onTap,
          //     (){
          //   context.push(navigateTo);
          // },
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
