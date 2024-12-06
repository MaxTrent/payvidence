import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';

import '../../components/business_card.dart';
import '../../gen/assets.gen.dart';

class AllBusinesses extends StatelessWidget {
  AllBusinesses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: [
            SizedBox(height: 16.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All businesses', style: Theme.of(context).textTheme.displayLarge,),
              Text('+ Add New', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 14.sp, color: primaryColor2))
              ],
            ),
            SizedBox(height: 32.h,),
            BusinessCard(
              businessName: 'Keekee Store',
              numberOfReceipts: '304',
              numberOfInvoices: '214',
            ),
            SizedBox(height: 24.h,),
            BusinessCard(
              businessName: 'Keekee Electronics',
              numberOfReceipts: '94',
              numberOfInvoices: '51',
            ),
          ],
        ),
      ),
    );
  }
}

