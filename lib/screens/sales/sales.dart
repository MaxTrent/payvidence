import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/providers/sales_providers/sales_data_provider.dart';
import 'package:payvidence/providers/sales_providers/sales_fillter_provider.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/animations.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../components/app_naira.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../gen/assets.gen.dart';
import '../../model/sales_model.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'SalesRoute')
class Sales extends HookConsumerWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesData = ref.watch(salesDataProvider);
    final interval = ref.watch(salesFilterProvider)["interval"];
    DateTime date = ref.watch(salesDateFilterProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    Future<void> onRefresh() async {
      await ref.refresh(salesDataProvider.future);
    }

    return ResponsiveWrapper(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: PullToRefresh(
              onRefresh: onRefresh,
              child: ListView(
                children: [
                  SizedBox(height: responsiveData.scaleHeight(12)),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 100),
                    child: Row(
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
                          height: responsiveData.scaleHeight(45),
                          width: responsiveData.scaleWidth(83),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2.15), // Approx 43.r
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
                                    color: (interval == "weekly" || isDarkMode)
                                        ? Colors.white
                                        : Colors.black),
                              )),
                        ),
                      ),
                      SizedBox(width: responsiveData.scaleWidth(12)),
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
                          height: responsiveData.scaleHeight(45),
                          width: responsiveData.scaleWidth(83),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2.15), // Approx 43.r
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
                                    color: (interval == "monthly" || isDarkMode)
                                        ? Colors.white
                                        : Colors.black),
                              )),
                        ),
                      ),
                      SizedBox(width: responsiveData.scaleWidth(12)),
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
                          height: responsiveData.scaleHeight(45),
                          width: responsiveData.scaleWidth(83),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2.15), // Approx 43.r
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
                                    color: (interval == "yearly" || isDarkMode)
                                        ? Colors.white
                                        : Colors.black),
                              )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(24),
                  ),
                  SlideInWidget(
                    begin: const Offset(0, 0.3),
                    delay: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: () async {
                      if (interval == "weekly") {
                        ref.read(salesDateFilterProvider.notifier).state =
                            (await selectDay(context)) ?? DateTime.now();

                        ref.read(salesFilterProvider.notifier).setKey(
                            "endDate",
                            DateFormat("y-M-d")
                                .format(ref.read(salesDateFilterProvider)));
                        ref.read(salesFilterProvider.notifier).setKey(
                            "startDate",
                            DateFormat("y-M-d").format(ref
                                .read(salesDateFilterProvider)
                                .subtract(const Duration(days: 7))));
                        ref.read(salesDataProvider.notifier).setFilter();
                      } else if (interval == "monthly") {
                        ref.read(salesDateFilterProvider.notifier).state =
                            (await showMonthPicker(
                                context: context,
                                initialDate: DateTime.now())) ??
                                DateTime.now();
                        ref.read(salesFilterProvider.notifier).setKey(
                            "endDate",
                            DateFormat("y-M-d").format(DateTime(
                                ref.read(salesDateFilterProvider).year,
                                ref.read(salesDateFilterProvider).month,
                                31)));
                        ref.read(salesFilterProvider.notifier).setKey(
                            "startDate",
                            DateFormat("y-M-d").format(DateTime(
                                ref.read(salesDateFilterProvider).year,
                                ref.read(salesDateFilterProvider).month,
                                1)));
                        ref.read(salesDataProvider.notifier).setFilter();
                      } else {
                        ref.read(salesDateFilterProvider.notifier).state =
                            (await showYearPicker(
                                context: context,
                                initialDate: DateTime.now())) ??
                                DateTime.now();
                        ref.read(salesFilterProvider.notifier).setKey(
                            "endDate",
                            DateFormat("y-M-d").format(DateTime(
                                ref.read(salesDateFilterProvider).year, 12, 31)));
                        ref.read(salesFilterProvider.notifier).setKey(
                            "startDate",
                            DateFormat("y-M-d").format(DateTime(
                                ref.read(salesDateFilterProvider).year, 1, 1)));
                        ref.read(salesDataProvider.notifier).setFilter();
                      }
                    },
                      child: AppTextField(
                        hintText: interval == "weekly"
                            ? DateFormat('d/M/y').format(date)
                            : interval == "monthly"
                            ? DateFormat('MMMM').format(date)
                            : DateFormat('y').format(date),
                        controller: TextEditingController(),
                        enabled: false,
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(36),
                  ),
                  salesData.when(data: (data) {
                    return FadeInWidget(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SalesInfoTile(
                                icon: Assets.svg.statusUp,
                                amount: data.totalRevenue.toString().toKMB(),
                                description: 'Total revenue',
                                showCurrency: true,
                              ),
                              SalesInfoTile(
                                icon: Assets.svg.boxTick,
                                amount: data.totalSales.toString().commaSeparated(),
                                description: 'Total sales',
                                showCurrency: false,
                              ),
                            ],
                          ),
                        SizedBox(
                          height: responsiveData.scaleHeight(18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SalesInfoTile(
                              icon: Assets.svg.noteText,
                              amount:
                              data.totalReceipts.toString().commaSeparated(),
                              description: 'Total receipts',
                              showCurrency: false,
                            ),
                            SalesInfoTile(
                              icon: Assets.svg.archiveBook,
                              amount:
                              data.totalInvoices.toString().commaSeparated(),
                              description: 'Total invoices',
                              showCurrency: false,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsiveData.scaleHeight(36),
                        ),
                        Visibility(
                          visible: data.graphData!.isNotEmpty,
                          replacement: const Text("No graph data available"),
                          child: SalesOverviewChart(
                            graphData: data.graphData!,
                          ),
                          )
                        ],
                      ),
                    );
                  }, error: (error, _) {
                    return const Text('An error has occurred');
                  }, loading: () {
                    return const CustomShimmer();
                  }),
                  SizedBox(
                    height: responsiveData.scaleHeight(36),
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

class SalesInfoTile extends StatelessWidget {
  const SalesInfoTile({
    required this.icon,
    required this.amount,
    required this.description,
    super.key,
    required this.showCurrency,
  });

  final String amount;
  final String description;
  final String icon;
  final bool showCurrency;

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return Container(
      height: responsiveData.scaleHeight(98),
      width: responsiveData.scaleWidth(167),
      decoration: BoxDecoration(
        color: const Color(0xffE3DDFF),
        borderRadius: BorderRadius.circular(responsiveData.smallRadius * 0.3), // Approx 6.r
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: responsiveData.scaleWidth(12),
            right: responsiveData.scaleWidth(12),
            top: responsiveData.scaleHeight(16),
            bottom: responsiveData.scaleHeight(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: responsiveData.scaleHeight(40),
                  width: responsiveData.scaleWidth(40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2.4)), // Approx 48.r
                  child: Padding(
                    padding: EdgeInsets.all(responsiveData.scaleHeight(8)),
                    child: SvgPicture.asset(
                      icon,
                      width: responsiveData.scaleWidth(24), // Adjusted for consistency
                      height: responsiveData.scaleHeight(24),
                    ),
                  ),
                ),
                SizedBox(
                  width: responsiveData.scaleWidth(8),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      showCurrency
                          ? AppNaira(
                        fontSize: Responsive.fontSize(context, 22).toInt(),
                      )
                          : const SizedBox.shrink(),
                      Text(
                        amount,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                            fontSize: Responsive.fontSize(context, 22),
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: responsiveData.scaleHeight(6),
            ),
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(
                  fontSize: Responsive.fontSize(context, 14),
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}

class SalesOverviewChart extends StatelessWidget {
  final List<GraphDatum> graphData;

  const SalesOverviewChart({super.key, required this.graphData});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsiveData.smallRadius * 0.6)), // Approx 12.r
      child: Padding(
        padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Sales overview",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: responsiveData.scaleHeight(16)),
            SizedBox(
              height: responsiveData.scaleHeight(400),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: graphData.length * responsiveData.scaleWidth(100),
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
                            reservedSize: responsiveData.scaleWidth(45),
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "${value.toString().toKMB()}₦",
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
                                    : graphData[index].salesKey == "week"
                                    ? "Week ${index + 1}"
                                    : graphData[index]
                                    .week
                                    .toString()
                                    .substring(0, 3);
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
                      gridData:
                      const FlGridData(show: true, drawVerticalLine: false),
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
  if (graphData == null || graphData.isEmpty) return 0;
  return double.tryParse(graphData
      .reduce((curr, next) => curr.salesValue > next.salesValue ? curr : next)
      .salesValue
      .toString());
}

Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final DateTime now = DateTime.now();
  final DateTime first = firstDate ?? DateTime(now.year - 1);
  final DateTime last = lastDate ?? DateTime(now.year + 1);

  DateTime selectedDate = DateTime(initialDate.year, initialDate.month);

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  int selectedYear = selectedDate.year;
  int selectedMonth = selectedDate.month;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Month'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      if (selectedYear > first.year) {
                        selectedYear--;
                      }
                    },
                  ),
                  Text(
                    selectedYear.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      if (selectedYear < last.year) {
                        selectedYear++;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Month grid
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(12, (index) {
                  final month = index + 1;
                  final isSelected = month == selectedMonth &&
                      selectedYear == selectedDate.year;
                  final isDisabled =
                      (selectedYear == first.year && month < first.month) ||
                          (selectedYear == last.year && month > last.month);

                  return InkWell(
                    onTap: isDisabled
                        ? null
                        : () {
                      selectedMonth = month;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          months[index].substring(0, 3),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isDisabled
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    },
  );

  return DateTime(selectedYear, selectedMonth);
}

Future<DateTime?> showYearPicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final DateTime first = firstDate ?? DateTime(initialDate.year - 10);
  final DateTime last = lastDate ?? DateTime(initialDate.year + 10);

  int selectedYear = initialDate.year;

  final DateTime? picked = await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Year'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: YearPicker(
            firstDate: first,
            lastDate: last,
            initialDate: initialDate,
            selectedDate: initialDate,
            onChanged: (DateTime date) {
              selectedYear = date.year;
              Navigator.of(context).pop(DateTime(selectedYear));
            },
          ),
        ),
      );
    },
  );

  return picked;
}

Future<DateTime?> selectDay(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryColor2,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: primaryColor2,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  return picked;
}