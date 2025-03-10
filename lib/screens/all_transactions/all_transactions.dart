import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class AllTransactions extends StatelessWidget {
   AllTransactions({super.key});
final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('All transactions (0)', style: Theme.of(context).textTheme.displayLarge!.copyWith(),),
        actions: [
          Center(child: Padding(
            padding:  EdgeInsets.only(right: 20.w),
            child: GestureDetector(
                onTap: (){
                  // context.router.push(DraftsRoute());
                },
                child: Text('View drafts', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 14.sp, color: primaryColor2))),
          ))
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                SvgPicture.asset(Assets.svg.emptyInvoice),
                SizedBox(height: 40.h,),
                Text('No transaction yet!', style: Theme.of(context).textTheme.displayLarge,),
                SizedBox(height: 10.h,),
                Text('Start generating receipts and invoices for your business. All transactions will show here.s',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, )),

                // ReceiptTile(),
                // ReceiptTile(),
                // ReceiptTile(),
                // ReceiptTile(),
                // ReceiptTile(),
                // ReceiptTile(),
                // ReceiptTile(),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton:
      // FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: primaryColor2,
      //   child: Icon(
      //     Icons.add,
      //     size: 40.h,
      //   ),
      // ),
      // AppButton(buttonText: 'Generate invoice', onPressed: (){
      //   // context.push('/addBusiness');
      // }),

    );
  }
}
