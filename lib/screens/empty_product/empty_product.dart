import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/product_tile.dart';

import '../../components/app_button.dart';
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     AppTextField(
            //       width: 282.w,
            //       prefixIcon: Padding(
            //         padding: EdgeInsets.all(16.h),
            //         child: SvgPicture.asset(Assets.svg.search),
            //       ),
            //       hintText: 'Search for product',
            //       controller: _searchController,
            //       radius: 80,
            //       filled: true,
            //       fillColor: appGrey5,
            //     ),
            //     Container(
            //       height: 48.h,
            //       width: 56.w,
            //       decoration: BoxDecoration(
            //         color: borderColor,
            //         borderRadius: BorderRadius.circular(56.r)
            //       ),
            //       child: Padding(
            //         padding:  EdgeInsets.all(14.h),
            //         child: SvgPicture.asset(Assets.svg.filter),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 72.h,),
            // SvgPicture.asset(Assets.svg.emptyProduct),
            // SizedBox(height: 40.h,),
            // Text('No product yet!', style: Theme.of(context).textTheme.displayLarge,),
            // SizedBox(height: 10.h,),
            // Text('Add products to your business account. All products added will show here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
          ProductTile(),
            ProductTile(),
            ProductTile(),
            ProductTile(),
            ProductTile(),
            ProductTile(),
            ProductTile(),
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
      //   context.push('/addBusiness');
      // }),

    );
  }
}
