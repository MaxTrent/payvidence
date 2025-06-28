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
              Align(
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
                          blurRadius: responsiveData.smallRadius * 0.2, // Approx 4.r equivalent
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
        return Container(
          margin: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(6)),
          height: responsiveData.scaleHeight(8),
          width: viewModel.currentPageIndex == index
              ? responsiveData.scaleWidth(20)
              : responsiveData.scaleHeight(8),
          decoration: BoxDecoration(
            color: viewModel.currentPageIndex == index
                ? primaryColor2
                : primaryColor2.withOpacity(0.4),
            borderRadius: BorderRadius.circular(responsiveData.smallRadius * 1.6), // Approx 32.r equivalent
          ),
        );
      }),
    );
  }
}

class OnboardingPage extends StatelessWidget {
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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: responsiveData.scaleHeight(40),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
            ),
            SizedBox(
              height: responsiveData.scaleHeight(10),
            ),
            Text(
              subtext,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w400, color: const Color(0xff333030)),
            ),
            SizedBox(
              height: responsiveData.scaleHeight(85),
            ),
            Image.asset(image)
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

    path.moveTo(0, 0); // Start at the top left corner

    // Create an inward curved top edge
    path.quadraticBezierTo(
      size.width / 2, // Control point x
      curveHeight, // Control point y (pulls the curve downward)
      size.width, // End point x
      0, // End point y (back to the top at the end)
    );

    // Draw right side
    path.lineTo(size.width, size.height);

    // Draw bottom
    path.lineTo(0, size.height);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}