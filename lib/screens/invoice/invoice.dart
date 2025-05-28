import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';

@RoutePage(name: 'InvoiceRoute')
class Invoice extends StatelessWidget {
  Invoice({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: SafeArea(
              child: ListView(
                children: [
                  SizedBox(
                    height: responsiveData.scaleHeight(16),
                  ),
                  Text(
                    'Generate receipt',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  Text(
                    'Fill in the details below to record new sales.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(32),
                  ),
                  Text(
                    'Client name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>().push(SelectClientRoute());
                    },
                    child: AppTextField(
                      enabled: false,
                      hintText: 'Select client',
                      controller: _controller,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(20),
                  ),
                  Text(
                    'Product name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  AppTextField(
                    hintText: 'Select product',
                    controller: _controller,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(20),
                  ),
                  Text(
                    'Quantity available',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  AppTextField(
                    hintText: 'Quantity available',
                    controller: _controller,
                    fillColor: borderColor,
                    filled: true,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(20),
                  ),
                  Text(
                    'Quantity purchased',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  AppTextField(
                    hintText: 'Quantity purchased',
                    controller: _controller,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(20),
                  ),
                  Text(
                    'Discount percentage (if any)',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  AppTextField(
                    hintText: 'Discount percentage',
                    controller: _controller,
                    suffixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(
                        responsiveData.scaleWidth(16),
                        responsiveData.scaleHeight(16),
                        responsiveData.scaleWidth(6),
                        responsiveData.scaleHeight(16),
                      ),
                      child: Text(
                        '%',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: Responsive.fontSize(context, 14)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(20),
                  ),
                  Text(
                    'Product price',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  AppTextField(
                    hintText: 'Product price',
                    controller: _controller,
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(
                        responsiveData.scaleWidth(16),
                        responsiveData.scaleHeight(16),
                        responsiveData.scaleWidth(6),
                        responsiveData.scaleHeight(16),
                      ),
                      child: Text(
                        '₦',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: Responsive.fontSize(context, 14)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(20),
                  ),
                  Text(
                    'VAT rate',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  AppTextField(
                    hintText: '',
                    controller: _controller,
                    suffixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(
                        responsiveData.scaleWidth(16),
                        responsiveData.scaleHeight(16),
                        responsiveData.scaleWidth(6),
                        responsiveData.scaleHeight(16),
                      ),
                      child: Text(
                        '%',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: Responsive.fontSize(context, 14)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(20),
                  ),
                  Text(
                    'Mode of payment',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  AppTextField(
                    hintText: 'Select mode of payment',
                    controller: _controller,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(28),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.add,
                        color: primaryColor2,
                      ),
                      Text(
                        'Add another product',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                          color: primaryColor2,
                          fontSize: Responsive.fontSize(context, 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(32),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        buttonText: 'Generate',
                        onPressed: () {
                          // context.push(AppRoutes.receipt);
                        },
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(26),
                      ),
                      Text(
                        'Save as draft',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: primaryColor2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}