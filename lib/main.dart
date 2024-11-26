import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/router.dart';
import 'package:payvidence/screens/onboarding.dart';

import 'constants/app_theme.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

Future<void> main() async{

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  try{
    // await setupLocator();
    runApp(MyApp(appTheme: AppTheme(),));
  }
  catch(e){(e);}


}

class MyApp extends StatelessWidget {
  final AppTheme appTheme;
  const MyApp({super.key, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      // splitScreenMode: true,
      child: MaterialApp(
        title: 'Payvidence',
        debugShowCheckedModeBanner: false,
        theme: appTheme.light,
        routes: routes,
        onUnknownRoute: (settings){
          return MaterialPageRoute(builder: (ctx) => OnboardingScreen());
        },
      ),
    );
  }
}
