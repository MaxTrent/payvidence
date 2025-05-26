import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';
import '../../providers/client_providers/get_all_client_provider.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';

@RoutePage(name: 'ClientSuccessRoute')
class ClientSuccess extends HookConsumerWidget {
  final String name;

  const ClientSuccess({super.key, @QueryParam('name') this.name = ''});

  @override
  Widget build(BuildContext context, ref) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        floatingActionButton: AppButton(
          buttonText: 'Alright!',
          onPressed: () {
            ref.read(getAllClientsProvider.notifier).fetchClients();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.svg.clientSuccess),
                SizedBox(
                  height: responsiveData.scaleHeight(40),
                ),
                Text(
                  'Client added! ',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(10),
                ),
                Text(
                  '$name has been successfully added to your clients. You can now select the client while generating receipt and invoice.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}