
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(description, style: Theme.of(context).textTheme.displaySmall!,),
            Text(status, style: Theme.of(context).textTheme.displaySmall!,),
          ],
        ),
        SizedBox(height: 18.h,),
      ],
    );
  }
}