import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/all_transactions/all_transactions.dart';
import 'package:payvidence/screens/nav_screens/home.dart';
import 'package:payvidence/screens/profile/profile.dart';
import 'package:payvidence/screens/sales/sales.dart';

import '../../gen/assets.gen.dart';



@RoutePage(name: 'HomePageRoute')
class HomePage extends HookConsumerWidget {
  HomePage({super.key});



  @override
  Widget build(BuildContext context, ref) {

    final selectedIndex = useState(0);

    void onItemTapped(int index) {
      selectedIndex.value = index;
      }

    final List<Widget> pages = [
      HomeScreen(),
      AllTransactions(),
      Sales(),
      const Profile(),

    ];

    return Scaffold(
      body: pages[selectedIndex.value],

      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          currentIndex: selectedIndex.value,
          onTap: onItemTapped,
          selectedLabelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12.sp),
          items: [
        BottomNavigationBarItem(icon: selectedIndex.value == 0 ? SvgPicture.asset(Assets.svg.home):SvgPicture.asset(Assets.svg.homeOl), label: 'Home'),
        BottomNavigationBarItem(icon: selectedIndex.value == 1 ? SvgPicture.asset(Assets.svg.transaction):SvgPicture.asset(Assets.svg.transactionOl), label: 'Transactions'),
        BottomNavigationBarItem(icon:selectedIndex.value == 2 ? SvgPicture.asset(Assets.svg.wallet):SvgPicture.asset(Assets.svg.walletOl), label: 'Sales'),
        BottomNavigationBarItem(icon: selectedIndex.value == 3 ? SvgPicture.asset(Assets.svg.profile):SvgPicture.asset(Assets.svg.profileOl), label: 'Account'),
      ]),
    );
  }
}
