import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import 'onboarding_vm.dart';

@RoutePage(name: 'OnboardingScreenRoute')
class OnboardingScreen extends HookConsumerWidget {
  static String routeName = "/onboardingScreen";
  OnboardingScreen({super.key});

  final _pageController = PageController();

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(onboardingScreenViewModelProvider);
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: scaffoldBackground,
        body: SafeArea(
          child: Stack(
            children: [
              PageView(
                allowImplicitScrolling: true,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (index) {
                  viewModel.changeIndex(index);
                },
                children: [
                  OnboardingPage(
                    text: 'Your digital transaction evidence',
                    subtext:
                    'Easily issue receipts, invoices, and purchase orders to clients on the go.',
                    image: Assets.png.onboard1.path,
                  ),
                  OnboardingPage(
                    text: 'Simplify your inventory management',
                    subtext:
                    'Manage all your transactions, invoices, receipts, and sales reports in one centralized location.',
                    image: Assets.png.onboard2.path,
                  ),
                  OnboardingPage(
                    text: 'Gain Insights with Analytics',
                    subtext:
                    'Access reports to understand sales performance and make smarter decisions.',
                    image: Assets.png.onboard3.path,
                  )
                ],
              ),
              AnimatedSlide(
                offset: Offset(0, 0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: CustomCurveClipper(curveHeight: responsiveData.scaleHeight(40)),
                    child: Container(
                      height: responsiveData.scaleHeight(310),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scaffoldBackground,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, -responsiveData.scaleHeight(2)),
                            blurRadius: responsiveData.smallRadius * 0.2,
                            spreadRadius: responsiveData.scaleHeight(10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: responsiveData.scaleHeight(62),
                            ),
                            PageIndicator(
                              viewModel: viewModel,
                            ),
                            SizedBox(
                              height: responsiveData.scaleHeight(45),
                            ),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(20)),
                              child: AppButton(
                                buttonText: 'Get started',
                                onPressed: () {
                                  locator<PayvidenceAppRouter>()
                                      .navigateNamed(PayvidenceRoutes.createAccount);
                                },
                              ),
                            ),
                            SizedBox(height: responsiveData.scaleHeight(26)),
                            GestureDetector(
                              onTap: () {
                                locator<PayvidenceAppRouter>()
                                    .navigateNamed(PayvidenceRoutes.login);
                              },
                              child: Text(
                                'Log in instead',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: primaryColor2),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.viewModel,
    super.key,
  });

  final OnboardingScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(6)),
          height: responsiveData.scaleHeight(8),
          width: viewModel.currentPageIndex == index
              ? responsiveData.scaleWidth(20)
              : responsiveData.scaleHeight(8),
          decoration: BoxDecoration(
            color: viewModel.currentPageIndex == index
                ? primaryColor2
                : primaryColor2.withOpacity(0.4),
            borderRadius: BorderRadius.circular(responsiveData.smallRadius * 1.6),
          ),
        );
      }),
    );
  }
}

class OnboardingPage extends HookWidget {
  const OnboardingPage({
    required this.image,
    required this.subtext,
    required this.text,
    super.key,
  });

  final String text;
  final String subtext;
  final String image;

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    final animationController = useAnimationController(duration: const Duration(milliseconds: 1200));
    
    final fadeAnimation = useMemoized(() => 
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut))
      )
    );
    
    final slideAnimation = useMemoized(() =>
      Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: animationController, curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack))
      )
    );
    
    final scaleAnimation = useMemoized(() =>
      Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: const Interval(0.4, 1.0, curve: Curves.elasticOut))
      )
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: responsiveData.scaleHeight(40),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: responsiveData.scaleHeight(10),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Text(
                      subtext,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.w400, color: const Color(0xff333030)),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: responsiveData.scaleHeight(85),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return ScaleTransition(
                  scale: scaleAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Image.asset(image),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CustomCurveClipper extends CustomClipper<Path> {
  final double curveHeight;

  CustomCurveClipper({required this.curveHeight});

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);

    path.quadraticBezierTo(
      size.width / 2,
      curveHeight,
      size.width,
      0,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}