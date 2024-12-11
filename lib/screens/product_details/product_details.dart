import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/app_button.dart';

import '../../gen/assets.gen.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 320.h,
            width: double.infinity,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Image.asset(
                  Assets.png.productpic.path,
                  fit: BoxFit.contain,
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                context.pop();
                              },
                              child: Container(
                                height: 48.h,
                                width: 48.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(56.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.h),
                                  child: SvgPicture.asset(Assets.svg.backbutton),
                                ),
                              ),
                            ),
                            Container(
                              height: 48.h,
                              width: 48.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(56.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.h),
                                child: SvgPicture.asset(Assets.svg.delete),
                              ),
                            )],
                        ),
                        Container(
                          height: 40.h,
                          width: 39.w,
                          child: Row(
                            children: [Text('Edit product', style: Theme.of(context).textTheme.displaySmall,)],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h,),
                  Text('Lucas Dinner Gown', style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 22.sp,),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
