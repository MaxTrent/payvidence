import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:payvidence/routes/app_routes.dart';

import '../../components/app_text_field.dart';
import '../../components/category_tile.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.gr.dart';


@RoutePage(name: 'BrandsRoute')
class Brands extends StatelessWidget {
  Brands({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTextField(
          prefixIcon: Padding(
            padding: EdgeInsets.all(16.h),
            child: SvgPicture.asset(Assets.svg.backbutton),
          ),
          hintText: 'Search for brand',
          controller: _searchController,
          radius: 80,
          filled: true,
          fillColor: appGrey5,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(AddBrandRoute());
        },
        backgroundColor: primaryColor2,
        child: Icon(
          Icons.add,
          size: 40.h,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
          Column(
            children: [
              CategoryTile(
                title: 'Fendi',
                subtitle: 'This is one of the common brands in fashion industry as most people cherish their footwears.',
              ),
              CategoryTile(
                title: 'Gucci',
                subtitle: 'This is one of the majors brands in fashion industry as most people cherish their footwears.',
              ),
              CategoryTile(
                title: 'Nike',
                subtitle: 'This is one of the favorite brands in fashion industry as most people cherish their footwears.',
              ),
            ],
          )
        ),
      ),
    );
  }
}
