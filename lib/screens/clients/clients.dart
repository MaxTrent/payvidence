import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.gr.dart';
   
    



@RoutePage(name: 'ClientsRoute')
class Clients extends StatelessWidget {
  Clients({super.key});

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Clients',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(),
        ),
        actions: [
          Center(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: GestureDetector(
                      onTap: () {
                        context.router.push(AddClientRoute());
                      },
                      child: Text('+ Add New',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 14.sp, color: primaryColor2)))))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32.h,
                ),
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
                SizedBox(
                  height: 20.h,
                ),
                // SvgPicture.asset(Assets.svg.emptyReceipt),
                // SizedBox(height: 40.h,),
                // Text('No receipt yet!', style: Theme.of(context).textTheme.displayLarge,),
                // SizedBox(height: 10.h,),
                // Text('Generate receipts for your business sales. All receipts generated will show here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, )),
                GestureDetector(
                  onTap: (){
                    context.router.push(ClientDetailsRoute());
                  },
                  child: SizedBox(
                    height: 101.h,
                    width: 350.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 56.h,
                          width: 56.h,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.lightGreen),
                          child: Center(
                              child: Text(
                            'BE',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 20.sp, color: Colors.white),
                          )),
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Bolatito Eniola',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(Assets.svg.location),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  'No. 2, New Area Street, Lagos State, Nigeria',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontSize: 14.sp),
                                  // maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  // softWrap: true,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  '0812 114 6633',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontSize: 14.sp),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                SvgPicture.asset(Assets.svg.copy)
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 101.h,
                  width: 350.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.lightGreen),
                        child: Center(
                            child: Text(
                              'BE',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20.sp, color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bolatito Eniola',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(Assets.svg.location),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'No. 2, New Area Street, Lagos State, Nigeria',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '0812 114 6633',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              SvgPicture.asset(Assets.svg.copy)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 101.h,
                  width: 350.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.lightGreen),
                        child: Center(
                            child: Text(
                              'BE',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20.sp, color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bolatito Eniola',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(Assets.svg.location),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'No. 2, New Area Street, Lagos State, Nigeria',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '0812 114 6633',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              SvgPicture.asset(Assets.svg.copy)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 101.h,
                  width: 350.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.lightGreen),
                        child: Center(
                            child: Text(
                              'BE',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20.sp, color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bolatito Eniola',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(Assets.svg.location),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'No. 2, New Area Street, Lagos State, Nigeria',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '0812 114 6633',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              SvgPicture.asset(Assets.svg.copy)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 101.h,
                  width: 350.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.lightGreen),
                        child: Center(
                            child: Text(
                              'BE',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20.sp, color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bolatito Eniola',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(Assets.svg.location),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'No. 2, New Area Street, Lagos State, Nigeria',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '0812 114 6633',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              SvgPicture.asset(Assets.svg.copy)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 101.h,
                  width: 350.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.lightGreen),
                        child: Center(
                            child: Text(
                              'BE',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20.sp, color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bolatito Eniola',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(Assets.svg.location),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'No. 2, New Area Street, Lagos State, Nigeria',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '0812 114 6633',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              SvgPicture.asset(Assets.svg.copy)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 101.h,
                  width: 350.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.lightGreen),
                        child: Center(
                            child: Text(
                              'BE',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20.sp, color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bolatito Eniola',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(Assets.svg.location),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'No. 2, New Area Street, Lagos State, Nigeria',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '0812 114 6633',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              SvgPicture.asset(Assets.svg.copy)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 101.h,
                  width: 350.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.lightGreen),
                        child: Center(
                            child: Text(
                              'BE',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20.sp, color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bolatito Eniola',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(Assets.svg.location),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'No. 2, New Area Street, Lagos State, Nigeria',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '0812 114 6633',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              SvgPicture.asset(Assets.svg.copy)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),

              ],
            ),
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
      // AppButton(buttonText: 'Generate receipt', onPressed: (){
      //   // context.push('/addBusiness');
      // }),
    );
  }
}
