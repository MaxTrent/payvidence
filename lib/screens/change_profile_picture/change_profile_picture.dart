import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/components/app_button.dart';



@RoutePage(name: 'ChangeProfilePictureRoute')
class ChangeProfilePicture extends StatelessWidget {
  const ChangeProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                'Change profile picture',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'You can update your picture here.',
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
              Center(
                child: CircleAvatar(
                  radius: 100.r,
                  backgroundColor: Colors.purple,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              AppButton(buttonText: 'Choose image', onPressed: () {
                // context.push();
              })
            ],
          ),
        ),
      ),
    );
  }
}
