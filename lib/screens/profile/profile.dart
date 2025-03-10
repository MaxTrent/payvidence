import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
 import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
@RoutePage(name: 'ProfileRoute')


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                                    // backgroundImage: SvgPicture.asset(Assets.svg.defaultProfilepic),,
                                    child: SvgPicture.asset(
                                        Assets.svg.defaultProfilepic),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.h,
                                  right: 0.w,
                                  child: GestureDetector(
                                    onTap: (){
                                      locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.changeProfilePicture);
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
                                    onTap: (){
                                      locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.notifications);
                                      // context.router.push(NotificationsRoute());
                                    },
                                    child: SvgPicture.asset(Assets.svg.notification)),
                                SizedBox(
                                  width: 12.w,
                                ),
                                GestureDetector(
                                    onTap: (){
                                      locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.settings);

                                      // context.router.push(SettingsRoute());
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
              SizedBox(
                height: 40.h,
              ),
              ProfileOptionTile(
                onTap: (){
                  locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.updatePersonalDetails);
                  // context.router.push(UpdatePersonalDetailsRoute());
                },
                // navigateTo: AppRoutes.updatePersonalDetails,
                title: 'Update personal details',
                icon: Assets.svg.userSquare,
              ),
              SizedBox(
                height: 24.h,
              ),
              ProfileOptionTile(
                onTap: (){
                  locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.mySubscription);

                  // context.router.push(MySubscriptionRoute());
                },
                  // navigateTo: AppRoutes.mySubscription,
                  icon: Assets.svg.medalStar, title: 'Manage subscription plan'),
              SizedBox(
                height: 24.h,
              ),
              ProfileOptionTile(
                onTap: (){
                  locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.businessData);
                  // context.router.push(BusinessDataRoute());
                },
                  // navigateTo: ,
                  icon: Assets.svg.chart, title: 'Access business data'),
              SizedBox(
                height: 24.h,
              ),
              ProfileOptionTile(
                  onTap: (){
                    locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.payvidenceInfo);
                    // context.router.push(PayvidenceInfoRoute());
                  },
                // navigateTo: AppRoutes.payvidenceInfo,
                  icon: Assets.svg.documentText,
                  title: 'View Payvidence information'),
              SizedBox(
                height: 24.h,
              ),
              ProfileOptionTile(
                  // navigateTo: '',
                  icon: Assets.svg.like, title: 'Rate app'),
              SizedBox(
                height: 24.h,
              ),
              ProfileOptionTile(
                // navigateTo: '',
                icon: Assets.svg.logout,
                title: 'Log out',
                showTrailing: false,
                color: appRed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOptionTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
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
            leading: SvgPicture.asset(icon, height: 32.h, width: 32.w,),
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
