import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/constants/app_colors.dart';

import '../../gen/assets.gen.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8.h,
            ),
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 28.h,),
            NotifcationTile(),
            NotifcationTile(),
            NotifcationTile(),
          ],
        ),
      ),
    );
  }
}

class NotifcationTile extends StatelessWidget {
  const NotifcationTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: Color(0xffD9D9D966),
      contentPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 18.h),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      leading: Container(
        height: 62.h,
        width: 58.w,
        decoration: BoxDecoration(
          color: primaryColor4,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding:  EdgeInsets.all(14.h),
          child: SvgPicture.asset(Assets.svg.notification),
        ),
      ),
      title: Text('Your account has been successfully created and your first business has been set up. Well done!',style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16.sp),),
    trailing: Text('3:45PM', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: Color(0xff8B8B8B)),),
    );
  }
}
