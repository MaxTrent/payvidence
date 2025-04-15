import 'dart:developer' as developer;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';

import '../data/local/session_manager.dart';

@RoutePage(name: 'SplashRoute')
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final sessionManager = locator<SessionManager>();
    final isLoggedIn = sessionManager.get<bool>(SessionConstants.isUserLoggedIn) ?? false;
    // final isOnboarded = sessionManager.get<bool>(SessionConstants.isOnboarded) ?? false;

    // developer.log('Splash: isLoggedIn=$isLoggedIn,  isOnboarded=$isOnboarded' );

    final router = AutoRouter.of(context);
    if (isLoggedIn) {
      router.replace(const HomePageRoute());
    }
    // else if (!isOnboarded) {
    //   router.replace(OnboardingScreenRoute());
    // }
    else {
      router.replace( OnboardingScreenRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}