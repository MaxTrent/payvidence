import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'SelectClientRoute')
class SelectClient extends StatelessWidget {
  SelectClient({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AppTextField(
            appBorderColor: Colors.transparent,
            prefixIcon: Padding(
              padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
              child: GestureDetector(
                onTap: () {
                  locator<PayvidenceAppRouter>().back();
                },
                child: SvgPicture.asset(Assets.svg.backbutton),
              ),
            ),
            hintText: 'Search for client',
            controller: _searchController,
            radius: responsiveData.smallRadius * 4, // Approx 80.r
            filled: true,
            fillColor: appGrey5,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            children: [
              SizedBox(
                height: responsiveData.scaleHeight(16),
              ),
              ClientTile(
                fullName: 'Bolatito Eniola',
                phoneNumber: '0812 224 6633',
              ),
              ClientTile(
                fullName: 'Elizabeth Ojo',
                phoneNumber: '0812 224 6633',
              ),
              ClientTile(
                fullName: 'James Akpan',
                phoneNumber: '0812 224 6633',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // context.push(AppRoutes.addBrand);
          },
          backgroundColor: primaryColor2,
          child: Icon(
            Icons.add,
            size: responsiveData.scaleHeight(40),
          ),
        ),
      ),
    );
  }
}

class ClientTile extends StatelessWidget {
  ClientTile({
    required this.fullName,
    required this.phoneNumber,
    super.key,
  });

  String fullName;
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return Container(
      height: responsiveData.scaleHeight(70),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: const Color(0xffF0F0F0), width: responsiveData.scaleHeight(1)))),
      child: Row(
        children: [
          SvgPicture.asset(Assets.svg.contact),
          SizedBox(
            width: responsiveData.scaleWidth(16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fullName,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: Responsive.fontSize(context, 14)),
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(4),
                ),
                Text(
                  phoneNumber,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: Responsive.fontSize(context, 14), fontWeight: FontWeight.w300),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}