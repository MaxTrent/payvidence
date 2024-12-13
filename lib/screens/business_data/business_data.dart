import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/screens/profile/profile.dart';

import '../../gen/assets.gen.dart';

class BusinessData extends StatelessWidget {
  const BusinessData({super.key});

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
              child: Text('Business data', style: Theme.of(context).textTheme.displayLarge,),
            ),
            SizedBox(height: 60.h,),
            ProfileOptionTile(icon: Assets.svg.shop, title: 'Businesses', navigateTo: ''),
            SizedBox(height: 28.h,),
            ProfileOptionTile(icon: Assets.svg.receipt, title: 'Receipts', navigateTo: ''),
            SizedBox(height: 28.h,),
            ProfileOptionTile(icon: Assets.svg.invoice, title: 'Invoices', navigateTo: ''),
            SizedBox(height: 28.h,),
            ProfileOptionTile(icon: Assets.svg.client, title: 'Clients', navigateTo: ''),
            SizedBox(height: 28.h,),
            ProfileOptionTile(icon: Assets.svg.product, title: 'Products', navigateTo: ''),

          ],
        ),
      ),
    );
  }
}
