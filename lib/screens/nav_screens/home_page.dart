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
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedIndex = useState(0);

    void onItemTapped(int index) {
      selectedIndex.value = index;
    }

    void switchToTab(int index) {
      selectedIndex.value = index;
    }

    final List<Widget> pages = [
      HomeScreen(onViewAllTransactions: () => switchToTab(1)),
      const AllTransactions(),
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
          selectedLabelStyle: Theme.of(context)
              .bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle:  Theme.of(context)
              .bottomNavigationBarTheme.unselectedLabelStyle,
          items: [

            BottomNavigationBarItem(
                icon: SvgPicture.asset(selectedIndex.value == 0 ? Assets.svg.home: Assets.svg.homeOl,
                colorFilter: ColorFilter.mode( selectedIndex.value == 0
                    ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                    : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,  BlendMode.srcIn,),
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(selectedIndex.value == 1 ? Assets.svg.transaction: Assets.svg.transactionOl,
                  colorFilter: ColorFilter.mode( selectedIndex.value == 1
                      ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                      : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,  BlendMode.srcIn,),
                ),
                label: 'Transactions'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(selectedIndex.value == 2 ? Assets.svg.wallet: Assets.svg.walletOl,
                  colorFilter: ColorFilter.mode( selectedIndex.value == 2
                      ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                      : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,  BlendMode.srcIn,),
                ),
                label: 'Sales'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(selectedIndex.value == 3 ? Assets.svg.profile: Assets.svg.profileOl,
                  colorFilter: ColorFilter.mode( selectedIndex.value == 3
                      ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                      : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,  BlendMode.srcIn,),
                ),
                label: 'Account'),
          ]),
    );
  }
}
