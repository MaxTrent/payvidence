import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/app_button.dart';

import '../../components/app_dot.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 320.h,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      Assets.png.productpic.path,
                    ),
                    fit: BoxFit.cover)),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
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
                              child: SvgPicture.asset(Assets.svg.backArrow),
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
                        )
                      ],
                    ),
                    Container(
                      height: 40.h,
                      width: 139.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 12.w),
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.svg.edit),
                            Text(
                              'Edit product',
                              style: Theme.of(context).textTheme.displaySmall,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24.h,
                ),
                Text(
                  'Lucas Dinner Gown',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 22.sp,
                      ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                    'This is a beautiful and exquisite gown that can be used for formal outings like dinner, wedding.',
                    style: Theme.of(context).textTheme.displaySmall),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Gown   ',
                        style: Theme.of(context).textTheme.displaySmall),
                    AppDot(
                      color: Colors.black,
                    ),
                    Text('   Fendi',
                        style: Theme.of(context).textTheme.displaySmall),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  '₦220,000.00',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  children: [
                    SvgPicture.asset(Assets.svg.star),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      '33 units sold',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    AppDot(
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      '2 units left',
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  ],
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  'Update quantity',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: primaryColor2,
                      decoration: TextDecoration.underline),
                ),
                SizedBox(height: 73.h,),
                AppButton(buttonText: 'Record sale', onPressed: (){},),
                SizedBox(height: 8.h,),
                AppButton(buttonText: 'Generate invoice', onPressed: (){},backgroundColor: Colors.white, textColor: primaryColor2,),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
