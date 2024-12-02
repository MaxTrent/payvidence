import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12.sp),
          unselectedLabelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12.sp),
          items: [
        BottomNavigationBarItem(icon: SvgPicture.asset(Assets.svg.homeOl), label: 'Home'),
        BottomNavigationBarItem(icon: SvgPicture.asset(Assets.svg.transactionOl), label: 'Transactions'),
        BottomNavigationBarItem(icon: SvgPicture.asset(Assets.svg.walletOl), label: 'Sales'),
        BottomNavigationBarItem(icon: SvgPicture.asset(Assets.svg.profileOl), label: 'Account'),
      ]),
    );
  }
}
