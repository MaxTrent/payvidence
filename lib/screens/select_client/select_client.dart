import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';


@RoutePage(name: 'SelectClientRoute')
class SelectClient extends StatelessWidget {
  SelectClient({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTextField(
          appBorderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: EdgeInsets.all(16.h),
            child: GestureDetector(
                onTap: (){
                  context.router.maybePop();
                },
                child: SvgPicture.asset(Assets.svg.backbutton)),
          ),
          hintText: 'Search for client',
          controller: _searchController,
          radius: 80,
          filled: true,
          fillColor: appGrey5,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 16.h,),
            ClientTile(
              fullName: 'Bolatito Eniola',
              phoneNumber: '0812 224 6633',
            ),
            ClientTile(
              fullName: 'Elizabeth Ojo',
              phoneNumber: '0812 224 6633',
            ),
            ClientTile(
              fullName: 'James Akpan',
              phoneNumber: '0812 224 6633',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.push(AppRoutes.addBrand);
        },
        backgroundColor: primaryColor2,
        child: Icon(
          Icons.add,
          size: 40.h,
        ),
      ),
    );
  }
}

class ClientTile extends StatelessWidget {
  ClientTile({
    required this.fullName,
    required this.phoneNumber,
    super.key,
  });

  String fullName;
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: const Color(0xffF0F0F0),
                  width: 1.h
              )
          )
      ),
      child: Row(
        children: [
          SvgPicture.asset(Assets.svg.contact),
          SizedBox(width: 16.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fullName,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  phoneNumber,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
