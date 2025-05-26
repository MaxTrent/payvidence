import 'package:flutter/material.dart';
import '../utilities/responsive_wrapper.dart';

class PlanList extends StatelessWidget {
  PlanList({
    required this.description,
    required this.status,
    super.key,
  });

  String description;
  String status;

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              description,
              style: Theme.of(context).textTheme.displaySmall!,
            ),
            Text(
              status,
              style: Theme.of(context).textTheme.displaySmall!,
            ),
          ],
        ),
        SizedBox(
          height: responsiveData.scaleHeight(18),
        ),
      ],
    );
  }
}