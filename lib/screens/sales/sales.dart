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
import '../../components/keyboard_dismissible_scaffold.dart';
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
      child: KeyboardDismissibleScaffold(
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
                            (await selectDay(context, date)) ?? date;

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
                                initialDate: date)) ??
                                date;
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
                                initialDate: date)) ??
                                date;
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
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: SalesInfoTile(
                                    icon: Assets.svg.statusUp,
                                    amount: data.totalRevenue.toString().toKMB(),
                                    description: 'Total revenue',
                                    showCurrency: true,
                                  ),
                                ),
                                SizedBox(width: responsiveData.scaleWidth(8)),
                                Flexible(
                                  child: SalesInfoTile(
                                    icon: Assets.svg.boxTick,
                                    amount: data.totalSales.toString().commaSeparated(),
                                    description: 'Total sales',
                                    showCurrency: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: responsiveData.scaleHeight(18),
                        ),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SalesInfoTile(
                                  icon: Assets.svg.noteText,
                                  amount: data.totalReceipts.toString().commaSeparated(),
                                  description: 'Total receipts',
                                  showCurrency: false,
                                ),
                              ),
                              SizedBox(width: responsiveData.scaleWidth(8)),
                              Flexible(
                                child: SalesInfoTile(
                                  icon: Assets.svg.archiveBook,
                                  amount: data.totalInvoices.toString().commaSeparated(),
                                  description: 'Total invoices',
                                  showCurrency: false,
                                ),
                              ),
                            ],
                          ),
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
      decoration: BoxDecoration(
        color: const Color(0xffE3DDFF),
        borderRadius: BorderRadius.circular(responsiveData.smallRadius * 0.3),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsiveData.scaleHeight(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  height: responsiveData.scaleHeight(32),
                  width: responsiveData.scaleWidth(32),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2)),
                  child: Padding(
                    padding: EdgeInsets.all(responsiveData.scaleHeight(6)),
                    child: SvgPicture.asset(
                      icon,
                      width: responsiveData.scaleWidth(16),
                      height: responsiveData.scaleHeight(16),
                    ),
                  ),
                ),
                SizedBox(width: responsiveData.scaleWidth(6)),
                Expanded(
                  child: Row(
                    children: [
                      if (showCurrency)
                        AppNaira(
                          fontSize: Responsive.fontSize(context, 16).toInt(),
                        ),
                      Flexible(
                        child: Text(
                          amount,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                              fontSize: Responsive.fontSize(context, 16),
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: responsiveData.scaleHeight(6)),
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(
                  fontSize: Responsive.fontSize(context, 11),
                  color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
  final responsiveData = ResponsiveInherited.of(context);

  DateTime selectedDate = DateTime(initialDate.year, initialDate.month);

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  int selectedYear = selectedDate.year;
  int selectedMonth = selectedDate.month;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsiveData.largeRadius),
        ),
        child: Container(
          padding: EdgeInsets.all(responsiveData.scaleHeight(24)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(responsiveData.largeRadius),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Month',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: Responsive.fontSize(context, 20),
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(24)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveData.scaleWidth(16),
                  vertical: responsiveData.scaleHeight(8),
                ),
                decoration: BoxDecoration(
                  color: primaryColor2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: primaryColor2),
                      onPressed: selectedYear > first.year ? () {
                        selectedYear--;
                        (context as Element).markNeedsBuild();
                      } : null,
                    ),
                    Text(
                      selectedYear.toString(),
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: Responsive.fontSize(context, 18),
                        color: primaryColor2,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, color: primaryColor2),
                      onPressed: selectedYear < last.year ? () {
                        selectedYear++;
                        (context as Element).markNeedsBuild();
                      } : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(20)),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: responsiveData.scaleHeight(8),
                crossAxisSpacing: responsiveData.scaleWidth(8),
                children: List.generate(12, (index) {
                  final month = index + 1;
                  final isSelected = month == selectedMonth;
                  final isDisabled =
                      (selectedYear == first.year && month < first.month) ||
                          (selectedYear == last.year && month > last.month);

                  return GestureDetector(
                    onTap: isDisabled ? null : () {
                      selectedMonth = month;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor2 : Colors.transparent,
                        borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                        border: Border.all(
                          color: isSelected ? primaryColor2 : Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          months[index].substring(0, 3),
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: isSelected
                                ? Colors.white
                                : isDisabled
                                ? Colors.grey
                                : Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: Responsive.fontSize(context, 14),
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
  final responsiveData = ResponsiveInherited.of(context);

  int selectedYear = initialDate.year;

  final DateTime? picked = await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsiveData.largeRadius),
        ),
        child: Container(
          padding: EdgeInsets.all(responsiveData.scaleHeight(24)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(responsiveData.largeRadius),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Year',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: Responsive.fontSize(context, 20),
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(16)),
              Container(
                height: responsiveData.scaleHeight(300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: primaryColor2,
                      onPrimary: Colors.white,
                    ),
                  ),
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
              ),
            ],
          ),
        ),
      );
    },
  );

  return picked;
}

Future<DateTime?> selectDay(BuildContext context, DateTime currentDate) async {
  final responsiveData = ResponsiveInherited.of(context);
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor2,
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
          ).copyWith(
            primary: primaryColor2,
            onPrimary: Colors.white,
            surface: isDarkMode ? Colors.grey[900] : Colors.white,
            onSurface: isDarkMode ? Colors.white : Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: primaryColor2,
              textStyle: TextStyle(
                fontSize: Responsive.fontSize(context, 14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(responsiveData.largeRadius),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  return picked;
}