import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/providers/sales_providers/sales_data_provider.dart';
import 'package:payvidence/providers/sales_providers/sales_fillter_provider.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../components/custom_shimmer.dart';
import '../../gen/assets.gen.dart';
import '../../model/sales_model.dart';

@RoutePage(name: 'SalesRoute')
class Sales extends ConsumerWidget {
  Sales({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesData = ref.watch(salesDataProvider);
    final interval = ref.watch(salesFilterProvider)["interval"];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              12.verticalSpace,
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (interval == "weekly") {
                        return;
                      }
                      ref
                          .read(salesFilterProvider.notifier)
                          .setKey("interval", "weekly");
                      ref.read(salesDataProvider.notifier).setFilter();
                    },
                    child: Container(
                      height: 45.h,
                      width: 83.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(43.r),
                          color: interval == "weekly"
                              ? primaryColor2
                              : Colors.transparent),
                      child: Center(
                          child: Text(
                        'Weekly',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: interval == "weekly"
                                    ? Colors.white
                                    : Colors.black),
                      )),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      if (interval == "monthly") {
                        return;
                      }
                      ref
                          .read(salesFilterProvider.notifier)
                          .setKey("interval", "monthly");
                      ref.read(salesDataProvider.notifier).setFilter();
                    },
                    child: Container(
                      height: 45.h,
                      width: 83.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(43.r),
                          color: interval == "monthly"
                              ? primaryColor2
                              : Colors.transparent),
                      child: Center(
                          child: Text(
                        'Monthly',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: interval == "monthly"
                                    ? Colors.white
                                    : Colors.black),
                      )),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      if (interval == "yearly") {
                        return;
                      }
                      ref
                          .read(salesFilterProvider.notifier)
                          .setKey("interval", "yearly");
                      ref.read(salesDataProvider.notifier).setFilter();
                    },
                    child: Container(
                      height: 45.h,
                      width: 83.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(43.r),
                          color: interval == "yearly"
                              ? primaryColor2
                              : Colors.transparent),
                      child: Center(
                          child: Text(
                        'Yearly',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: interval == "yearly"
                                    ? Colors.white
                                    : Colors.black),
                      )),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 24.h,
              // ),
              // AppTextField(
              //   hintText: '08 / 09 / 2024',
              //   controller: _controller,
              //   suffixIcon: const Icon(Icons.keyboard_arrow_down),
              // ),
              SizedBox(
                height: 36.h,
              ),
              salesData.when(data: (data) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SalesInfoTile(
                          icon: Assets.svg.statusUp,
                          amount:
                              '₦${data.totalRevenue.toString().commaSeparated()}',
                          description: 'Total revenue',
                        ),
                        SalesInfoTile(
                          icon: Assets.svg.boxTick,
                          amount: data.totalSales.toString().commaSeparated(),
                          description: 'Total sales',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SalesInfoTile(
                          icon: Assets.svg.noteText,
                          amount:
                              data.totalReceipts.toString().commaSeparated(),
                          description: 'Total receipts',
                        ),
                        SalesInfoTile(
                          icon: Assets.svg.archiveBook,
                          amount:
                              data.totalInvoices.toString().commaSeparated(),
                          description: 'Total invoices',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 36.h,
                    ),
                    SalesOverviewChart(
                      graphData: data.graphData!,
                    )
                  ],
                );
              }, error: (error, _) {
                return const Text('An error has occurred');
              }, loading: () {
                return const CustomShimmer();
              }),
              SizedBox(
                height: 36.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesInfoTile extends StatelessWidget {
  const SalesInfoTile({
    required this.icon,
    required this.amount,
    required this.description,
    super.key,
  });

  final String amount;
  final String description;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.h,
      width: 167.w,
      decoration: BoxDecoration(
        color: const Color(0xffE3DDFF),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, top: 16.h, bottom: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(48.r)),
                  child: Padding(
                    padding: EdgeInsets.all(8.h),
                    child: SvgPicture.asset(icon),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Text(
                    amount,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 14.sp),
            )
          ],
        ),
      ),
    );
  }
}

//TODO: rebase the chart 
class SalesOverviewChart extends StatelessWidget {
  final List<GraphDatum> graphData;

  const SalesOverviewChart({super.key, required this.graphData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sales overview",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400.h,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: graphData.length * 100.w,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: getMaxSales(graphData),
                      barGroups: List.generate(graphData.length, (int index) {
                        return _buildBarData(
                            index,
                            double.tryParse(
                                    graphData[index].salesValue.toString()) ??
                                0);
                      }),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 80.w,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "${value.toInt()}₦",
                                style: const TextStyle(fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              var days =
                                  List.generate(graphData.length, (int index) {
                                return graphData[index].salesKey == "date"
                                    ? DateFormat.E().format(DateTime.parse(
                                        graphData[index].week.toString()))
                                    : graphData[index].week.toString();
                              });
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  days[value.toInt()],
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(enabled: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.indigo,
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

double? getMaxSales(List<GraphDatum>? graphData) {
  print(graphData);
  if (graphData == null || graphData.isEmpty) return 0;
  return double.tryParse(graphData
      .reduce((curr, next) => curr.salesValue > next.salesValue ? curr : next)
      .salesValue
      .toString());
}
