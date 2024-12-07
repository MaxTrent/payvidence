import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/constants/app_colors.dart';

import '../../gen/assets.gen.dart';

class EmptyCategory extends StatelessWidget {
   EmptyCategory({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  AppTextField(prefixIcon: Padding(
          padding:  EdgeInsets.all(16.h),
          child: SvgPicture.asset(Assets.svg.backbutton),
        ), hintText: 'Search for category', controller: _searchController, radius: 80, filled: true, fillColor: appGrey5,),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add), backgroundColor: primaryColor2,),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('No category added!', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 10.h,),
              Text('All added categories will appear here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, )),
              SizedBox(height: 48.h,),
              AppButton(buttonText: 'Add category', onPressed: (){})
            ],
          ),
        ),
      ),
    );
  }
}
