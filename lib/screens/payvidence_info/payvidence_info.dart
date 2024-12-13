import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../profile/profile.dart';

class PayvidenceInfo extends StatelessWidget {
  PayvidenceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text('Payvidence information', style: Theme.of(context).textTheme.displayLarge,),
            ),
            SizedBox(height: 32.h,),
            Divider(
              thickness: 1.h,
            ),
            ProfileOptionTile(icon: Assets.svg.privacy, title: 'Privacy policy', navigateTo: ''),
            SizedBox(height: 28.h,),
            ProfileOptionTile(icon: Assets.svg.terms, title: 'Terms and conditions', navigateTo: ''),
            SizedBox(height: 28.h,),
            ProfileOptionTile(icon: Assets.svg.contactUs, title: 'Contact us', navigateTo: ''),

          ],
        ),
      ),
    );
  }
}
