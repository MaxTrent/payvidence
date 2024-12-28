import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';

class ClientDetails extends StatelessWidget {
  ClientDetails({super.key});
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.h,
              ),
              Text(
                'Client details',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'You can update or remove client details.',
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
              Text(
                'Client name',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                hintText: 'Client name',
                controller: _controller,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Client phone number',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                hintText: 'Client phone number',
                controller: _controller,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Client address',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                hintText: 'Client address',
                controller: _controller,
              ),
              SizedBox(
                height: 32.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    buttonText: 'Update client details',
                    onPressed: () {
                      // context.push(AppRoutes.generateReceipt);
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppButton(
                    backgroundColor: Colors.transparent,
                    buttonText: 'Remove client',
                    textColor: appRed,
                    onPressed: () {
                      showModalBottomSheet(
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
                                              color: Color(0xffd9d9d9),
                                              borderRadius:
                                                  BorderRadius.circular(100.r),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 38.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox.shrink(),
                                            Center(
                                              child: Text(
                                                'Confirm remove',
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
                                                onTap: context.pop,
                                                child: Icon(
                                                  Icons.close,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        Center(
                                          child: Text(
                                            'Are you sure you want to remove this client? \n\nAll saved details will be gone.',
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
                                          buttonText: 'Remove client',
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
                      // context.push(AppRoutes.generateReceipt);
                    },
                  ),
                  // Text('Remove client', style: Theme.of(context).textTheme.displayMedium!.copyWith(color: primaryColor2),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
