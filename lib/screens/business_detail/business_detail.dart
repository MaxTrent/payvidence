import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';


@RoutePage(name: 'BusinessDetailRoute')
class BusinessDetail extends StatelessWidget {
  const BusinessDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 320.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        Assets.jpg.keekee.path,
                      ),
                      fit: BoxFit.cover)),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.router.maybePop();
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
                      GestureDetector(
                        onTap: () {
                          _buildConfirmDeleteBottomSheet(context);
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
                            child: SvgPicture.asset(Assets.svg.delete),
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
                    'Keekee Store',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(Assets.svg.location),
                      SizedBox(width: 6.w,),
                      Text('No. 2, New Area Street, Lagos State, Nigeria',
                          style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phone number', style: Theme.of(context).textTheme.displaySmall,),
                      Text('0803 455 4522', style: Theme.of(context).textTheme.displaySmall,),
        
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Business VAT rate', style: Theme.of(context).textTheme.displaySmall,),
                      Text('2%', style: Theme.of(context).textTheme.displaySmall,),
        
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Receipts issuer', style: Theme.of(context).textTheme.displaySmall,),
                      Text('Peter Ogunkunle', style: Theme.of(context).textTheme.displaySmall,),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Issuer role', style: Theme.of(context).textTheme.displaySmall,),
                      Text('Business Manager', style: Theme.of(context).textTheme.displaySmall,),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Issuer signature', style: Theme.of(context).textTheme.displaySmall,),
                      Container(
                        height: 64.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(Assets.png.signature.path))
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 32.h,),
                  Text('Bank details', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18.sp),),
                  SizedBox(height: 20.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bank name', style: Theme.of(context).textTheme.displaySmall,),
                      Text('First Bank', style: Theme.of(context).textTheme.displaySmall,),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Account number', style: Theme.of(context).textTheme.displaySmall,),
                      Text('3013334434', style: Theme.of(context).textTheme.displaySmall,),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Account name', style: Theme.of(context).textTheme.displaySmall,),
                      Text('Keekee Store', style: Theme.of(context).textTheme.displaySmall,),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  AppButton(
                    buttonText: 'Edit business detailse',
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppButton(
                    buttonText: 'Edit bank details',
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    textColor: primaryColor2,
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildConfirmDeleteBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.none,
        context: context,
        builder: (context) {
          return Container(
            height: 398.h,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.r),
                    topLeft: Radius.circular(40.r))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.w, vertical: 10.h),
              child: Stack(
                children: [
                  ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 140.w),
                        child: Container(
                          height: 5.h,
                          width: 67.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffd9d9d9),
                            borderRadius:
                            BorderRadius.circular(
                                100.r),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 38.h,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          const SizedBox.shrink(),
                          Center(
                            child: Text(
                              'Confirm delete',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                fontSize: 22.sp,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: ()=> context.router.maybePop(),
                              child: const Icon(
                                Icons.close,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Center(
                        child: Text(
                          'Are you sure you want to delete this product?\n\nAll details and statistics will be gone.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall,
                        ),
                      ),
                      SizedBox(
                        height: 47.h,
                      ),
                      AppButton(
                        buttonText: 'Delete product',
                        onPressed: () {},
                        backgroundColor: appRed,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      AppButton(
                        buttonText: 'Cancel',
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
