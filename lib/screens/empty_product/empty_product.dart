import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/product_tile.dart';

import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class EmptyProduct extends StatelessWidget {
  EmptyProduct({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('All products (0)', style: Theme.of(context).textTheme.displayLarge!.copyWith(),),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextField(
                  width: 282.w,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: SvgPicture.asset(Assets.svg.search),
                  ),
                  hintText: 'Search for product',
                  controller: _searchController,
                  radius: 80,
                  filled: true,
                  fillColor: appGrey5,
                  appBorderColor: Colors.transparent,
                ),
                GestureDetector(
                  onTap: (){
                    buildFilterBottomSheet(context);
                  },
                  child: Container(
                    height: 48.h,
                    width: 56.w,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(56.r)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(14.h),
                      child: SvgPicture.asset(Assets.svg.filter),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 72.h,),
            // SvgPicture.asset(Assets.svg.emptyProduct),
            // SizedBox(height: 40.h,),
            // Text('No product yet!', style: Theme.of(context).textTheme.displayLarge,),
            // SizedBox(height: 10.h,),
            // Text('Add products to your business account. All products added will show here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
          const ProductTile(),
            const ProductTile(),
            const ProductTile(),
            const ProductTile(),
            const ProductTile(),
            const ProductTile(),
            const ProductTile(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor2,
        child: Icon(
          Icons.add,
          size: 40.h,
        ),
      ),
      // AppButton(buttonText: 'Add product', onPressed: (){
      //   context.push(AppRoutes.addProduct);
      // }),

    );
  }

  Future<dynamic> buildFilterBottomSheet(BuildContext context) {
    return showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        clipBehavior: Clip.none,
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 470.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40.r),
                                    topLeft: Radius.circular(40.r))
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              child: Stack(
                                children: [
                                  ListView(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: 140.w),
                                        child: Container(height: 5.h, width: 67.w,

                                          decoration: BoxDecoration(
                                            color: const Color(0xffd9d9d9),
                                            borderRadius: BorderRadius.circular(100.r),
                                          ),),
                                      ),
                                      SizedBox(height: 38.h,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox.shrink(),
                                          Center(
                                            child: Text(
                                              'Filter products',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .copyWith(
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.w600,),
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: context.pop,
                                              child: const Icon(Icons.close,))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      Center(
                                        child: Text(
                                          'Select category you’ll like to see.', style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                        ),
                                      ),
                                      SizedBox(height: 40.h,),
                                      Padding(
                                        padding:  EdgeInsets.symmetric(vertical: 24.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(Assets.svg.shapes),
                                            SizedBox(width: 16.w,),
                                            Text('Accessories', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp),),


                                          ],
                                        ),
                                      ),
                                      Divider(height: 1.h,),
                                      Padding(
                                        padding:  EdgeInsets.symmetric(vertical: 24.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(Assets.svg.shapes),
                                            SizedBox(width: 16.w,),
                                            Text('Bag', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp),),
                                          ],
                                        ),
                                      ),
                                      Divider(height: 1.h,),
                                      Padding(
                                        padding:  EdgeInsets.symmetric(vertical: 24.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(Assets.svg.shapes),
                                            SizedBox(width: 16.w,),
                                            Text('Clothes', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp),),


                                          ],
                                        ),
                                      ),
                                      Divider(height: 1.h,),
                                      Padding(
                                        padding:  EdgeInsets.symmetric(vertical: 24.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(Assets.svg.shapes),
                                            SizedBox(width: 16.w,),
                                            Text('Footwears', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp),),


                                          ],
                                        ),
                                      ),
                                      Divider(height: 1.h,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
  }
}
