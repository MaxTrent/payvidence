import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/screens/nav_screens/home.dart';
import 'package:payvidence/screens/nav_screens/homepage_vm.dart';
import 'package:payvidence/screens/profile/profile.dart';
import 'package:payvidence/screens/sales/sales.dart';

import '../../gen/assets.gen.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});


  @override
  Widget build(BuildContext context, ref) {
    final viewModel = HomePageViewModel(ref);

    final List<Widget> _pages = [
     HomeScreen(),
      Scaffold(
        appBar: AppBar(
          title: Text('2'),
        ),
      ),
      Sales(),
      Profile(),

    ];

    return Scaffold(
      body: _pages[viewModel.selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          currentIndex: viewModel.selectedIndex,
          onTap: viewModel.onItemTapped,
          selectedLabelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12.sp),
          items: [
        BottomNavigationBarItem(icon: viewModel.selectedIndex == 0 ? SvgPicture.asset(Assets.svg.home):SvgPicture.asset(Assets.svg.homeOl), label: 'Home'),
        BottomNavigationBarItem(icon: viewModel.selectedIndex == 1 ? SvgPicture.asset(Assets.svg.transaction):SvgPicture.asset(Assets.svg.transactionOl), label: 'Transactions'),
        BottomNavigationBarItem(icon:viewModel.selectedIndex == 2 ? SvgPicture.asset(Assets.svg.wallet):SvgPicture.asset(Assets.svg.walletOl), label: 'Sales'),
        BottomNavigationBarItem(icon: viewModel.selectedIndex == 3 ? SvgPicture.asset(Assets.svg.profile):SvgPicture.asset(Assets.svg.profileOl), label: 'Account'),
      ]),
    );
  }
}
