import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


@RoutePage(name: 'NotificationSettingsRoute')
class NotificationSettings extends StatelessWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h,),
            Text('Notifications setting', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 32.h,),
            Divider(
              thickness: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transactional alerts', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 22.sp
                ),),
                CupertinoSwitch(value: true, onChanged: (value){})
              ],
            ),
            SizedBox(height: 11.h,),
            Text('You will receive notifications about new receipts, invoices, products, and clients.', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 16.sp
            ),),
            SizedBox(height: 28.h,),
            Divider(
              thickness: 1.h,
            ),
            SizedBox(height: 28.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Promotional updates', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 22.sp
                ),),
                CupertinoSwitch(value: true, onChanged: (value){})
              ],
            ),
            SizedBox(height: 11.h,),
            Text('You will get notifications about new features, updates, or promotions within the app.', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 16.sp
            ),),
            SizedBox(height: 28.h,),
            Divider(
              thickness: 1.h,
            ),
            SizedBox(height: 28.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Security alerts', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 22.sp
                ),),
                CupertinoSwitch(value: true, onChanged: (value){})
              ],
            ),
            SizedBox(height: 11.h,),
            Text('You will be notified of new or unrecognized devices and any suspicious account activity.', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 16.sp
            ),),
            SizedBox(height: 28.h,),
            Divider(
              thickness: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
