import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';

class Drafts extends StatelessWidget {
   Drafts({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('All drafts (0)', style: Theme.of(context).textTheme.displayLarge!.copyWith(),),

      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h,),
                AppTextField(
                  // width: 282.w,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: SvgPicture.asset(Assets.svg.search),
                  ),
                  hintText: 'Search for product',
                  controller: _searchController,
                  radius: 80,
                  filled: true,
                  fillColor: appGrey5,
                ),
                SizedBox(height: 20.h,),
                Text('You can click on specific draft to edit.', style: Theme.of(context).textTheme.displaySmall,),
                SizedBox(height: 8.h,),
                // SvgPicture.asset(Assets.svg.emptyReceipt),
                // SizedBox(height: 40.h,),
                // Text('No receipt yet!', style: Theme.of(context).textTheme.displayLarge,),
                // SizedBox(height: 10.h,),
                // Text('Generate receipts for your business sales. All receipts generated will show here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, )),

                DraftTile(),
                DraftTile(),
                DraftTile(),
                DraftTile(),
                DraftTile(),
                DraftTile(),
                DraftTile(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor2,
        child: Icon(
          Icons.add,
          size: 40.h,
        ),
      ),
      // AppButton(buttonText: 'Generate receipt', onPressed: (){
      //   // context.push('/addBusiness');
      // }),

    );
  }
}

class DraftTile extends StatelessWidget {
  DraftTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push(AppRoutes.completeDraft);
      },
      child: Container(
        height: 101.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.transparent
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 72.h,
              width: 72.h,
              decoration: BoxDecoration(
                  color: Colors.black
              ),
            ),
            SizedBox(width: 14.w,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lucas Dinner Gown', style: Theme.of(context).textTheme.displayMedium,),
                SizedBox(height: 6.h,),
                Row(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('15 units sold', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: appGrey4)),
                        SizedBox(width: 10.w,),
                        Container(
                          height: 6.h,
                          width: 6.h,
                          decoration: BoxDecoration(
                              color: appGrey4,
                              borderRadius: BorderRadius.circular(24.r)

                          ),
                        ),
                        SizedBox(width: 10.w,),
                        Text('Today, 8:50PM', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: appGrey4)),

                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(Assets.svg.delete),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 8.h,),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('₦220,000.00', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 14.sp)),


                  ],
                )
              ],
            ),

          ],
        ),
      ),
    );;
  }
}

