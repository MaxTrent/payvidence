import 'dart:developer' as developer;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/gen/assets.gen.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';

import '../data/local/session_manager.dart';

@RoutePage(name: 'SplashRoute')
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _revealAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.forward();
    _checkAuthState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    
    final sessionManager = locator<SessionManager>();
    final isLoggedIn = sessionManager.get<bool>(SessionConstants.isUserLoggedIn) ?? false;

    final router = AutoRouter.of(context);
    if (isLoggedIn) {
      router.replace(const HomePageRoute());
    } else {
      router.replace(OnboardingScreenRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF49379C),
      body: Center(
        child: AnimatedBuilder(
          animation: _revealAnimation,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: _revealAnimation.value,
                child: Image.asset(
                  Assets.png.newlogo2.path,
                  width: responsiveData.scaleWidth(240),
                  height: responsiveData.scaleHeight(240),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}