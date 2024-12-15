import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/constants/app_colors.dart';

import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    context.push(AppRoutes.changeProfilePicture);
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
                                    context.push(AppRoutes.notifications);
                                  },
                                  child: SvgPicture.asset(Assets.svg.notification)),
                              SizedBox(
                                width: 12.w,
                              ),
                              GestureDetector(
                                  onTap: (){
                                    context.push(AppRoutes.settings);
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
                        height: 80.h,
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
              navigateTo: AppRoutes.updatePersonalDetails,
              title: 'Update personal details',
              icon: Assets.svg.userSquare,
            ),
            SizedBox(
              height: 24.h,
            ),
            ProfileOptionTile(
                navigateTo: '',
                icon: Assets.svg.medalStar, title: 'Manage subscription plan'),
            SizedBox(
              height: 24.h,
            ),
            ProfileOptionTile(
                navigateTo: AppRoutes.businessData,
                icon: Assets.svg.chart, title: 'Access business data'),
            SizedBox(
              height: 24.h,
            ),
            ProfileOptionTile(
              navigateTo: AppRoutes.payvidenceInfo,
                icon: Assets.svg.documentText,
                title: 'View Payvidence information'),
            SizedBox(
              height: 24.h,
            ),
            ProfileOptionTile(
                navigateTo: '',
                icon: Assets.svg.like, title: 'Rate app'),
            SizedBox(
              height: 24.h,
            ),
            ProfileOptionTile(
              navigateTo: '',
              icon: Assets.svg.logout,
              title: 'Log out',
              showTrailing: false,
              color: appRed,
            ),
          ],
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
    required this.navigateTo,
    this.color,
    super.key,
  });

  String title;
  String icon;
  bool showTrailing;
  Color? color;
  String navigateTo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            context.push(navigateTo);
          },
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
