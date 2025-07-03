import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/providers/client_providers/get_all_client_provider.dart';
import 'package:payvidence/utilities/toast_service.dart';
import 'package:payvidence/utilities/animations.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'ClientsRoute')
class Clients extends HookConsumerWidget {
  final bool? forSelection;
  final String businessId;

  Clients({
    super.key,
    this.forSelection = false,
    @QueryParam('businessId') this.businessId = '',
  });

  static const List<Color> avatarColors = [
    Colors.lightGreen,
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.teal,
    Colors.redAccent,
    Colors.amber,
    Colors.cyan,
  ];

  Color getClientColor(dynamic client) {
    final hash = client.id?.hashCode ?? client.name?.hashCode ?? 0;
    return avatarColors[hash.abs() % avatarColors.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allClients = ref.watch(getAllClientsProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final copiedIndex = useState<int?>(null);
    final responsiveData = ResponsiveInherited.of(context);

    // Debounced search listener
    useEffect(() {
      Timer? timer;
      void listener() {
        timer?.cancel();
        timer = Timer(const Duration(milliseconds: 300), () {
          searchQuery.value = searchController.text.trim();
        });
      }

      searchController.addListener(listener);
      return () {
        timer?.cancel();
        searchController.removeListener(listener);
      };
    }, [searchController]);

    Future<void> onRefresh() async {
      searchController.clear();
      searchQuery.value = '';
      await ref.refresh(getAllClientsProvider.future);
    }

    return ResponsiveWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: Text(
            'Clients',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(),
          ),
          actions: [
            allClients.when(
              data: (data) {
                if (data.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: responsiveData.paddingHorizontal),
                    child: GestureDetector(
                      onTap: () async {
                        await locator<PayvidenceAppRouter>()
                            .navigate(AddClientRoute(businessId: businessId));
                        ref.read(getAllClientsProvider.notifier).fetchClients();
                      },
                      child: Semantics(
                        label: 'Add new client',
                        child: Text(
                          '+ Add New',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: Responsive.fontSize(context, 14),
                            color: primaryColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (error, _) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: responsiveData.scaleHeight(32)),
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: AppTextField(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
                    child: SvgPicture.asset(
                      Assets.svg.search,
                      colorFilter: ColorFilter.mode(
                          isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
                      width: responsiveData.scaleWidth(24),
                      height: responsiveData.scaleHeight(24),
                    ),
                  ),
                  hintText: 'Search for client',
                  controller: searchController,
                  radius: responsiveData.largeRadius,
                  filled: isDarkMode ? false : true,
                  appBorderColor: isDarkMode ? Colors.white:Colors.transparent,
                  fillColor: isDarkMode ? Colors.black : appGrey5,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(20)),
              Expanded(
                child: allClients.when(
                  data: (data) {
                    // Filter clients
                    final filteredClients = searchQuery.value.isEmpty
                        ? data
                        : data
                        .where((client) => client.name
                        ?.toLowerCase()
                        .contains(searchQuery.value.toLowerCase()) ??
                        false)
                        .toList();
                
                    if (filteredClients.isEmpty) {
                      return PullToRefresh(
                        onRefresh: onRefresh,
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  SvgPicture.asset(Assets.svg.emptyClient),
                                  SizedBox(height: responsiveData.scaleHeight(40)),
                                  Text(
                                    searchQuery.value.isEmpty
                                        ? 'No client yet!'
                                        : 'No clients found!',
                                    style: Theme.of(context).textTheme.displayLarge,
                                  ),
                                  SizedBox(height: responsiveData.scaleHeight(10)),
                                  Text(
                                    searchQuery.value.isEmpty
                                        ? 'You can add your clients to your business. All clients will show here.'
                                        : 'Try a different search term.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                  ),
                                  const Spacer(),
                                  if (searchQuery.value.isEmpty) ...[
                                    Padding(
                                      padding: EdgeInsets.all(responsiveData.scaleHeight(20)),
                                      child: AppButton(
                                        buttonText: 'Add client',
                                        onPressed: () async {
                                          await locator<PayvidenceAppRouter>().navigate(
                                              AddClientRoute(businessId: businessId));
                                          ref
                                              .read(getAllClientsProvider.notifier)
                                              .fetchClients();
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                
                    return PullToRefresh(
                      onRefresh: onRefresh,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SlideInWidget(
                            begin: const Offset(0, 0.3),
                            delay: Duration(milliseconds: 100 + (index * 50)),
                            child: GestureDetector(
                              onTap: () async {
                                if (forSelection == true) {
                                  Navigator.of(context).pop(filteredClients[index]);
                                } else {
                                  if (filteredClients[index].id != null) {
                                    await locator<PayvidenceAppRouter>().push(
                                      ClientDetailsRoute(
                                        businessId: businessId,
                                        clientId: filteredClients[index].id!,
                                      ),
                                    );
                                    ref
                                        .read(getAllClientsProvider.notifier)
                                        .fetchClients();
                                  }
                                }
                              },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: responsiveData.scaleHeight(56),
                                  width: responsiveData.scaleHeight(56),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: getClientColor(filteredClients[index]),
                                  ),
                                  child: Center(
                                    child: Text(
                                      filteredClients[index].name?.substring(0, 2) ??
                                          'NA',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                        fontSize: Responsive.fontSize(context, 20),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: responsiveData.scaleWidth(12)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        filteredClients[index].name ?? '',
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                          fontSize: Responsive.fontSize(context, 14),
                                        ),
                                      ),
                                      SizedBox(height: responsiveData.scaleHeight(8)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            Assets.svg.location,
                                            colorFilter: ColorFilter.mode(
                                              isDarkMode ? Colors.white : Colors.black,
                                              BlendMode.srcIn,
                                            ),
                                            width: responsiveData.scaleWidth(16),
                                            height: responsiveData.scaleHeight(16),
                                          ),
                                          SizedBox(width: responsiveData.scaleWidth(6)),
                                          Expanded(
                                            child: Text(
                                              filteredClients[index].address ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: responsiveData.scaleHeight(12)),
                                      Row(
                                        children: [
                                          Text(
                                            filteredClients[index].phoneNumber ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                          ),
                                          SizedBox(width: responsiveData.scaleWidth(8)),
                                          GestureDetector(
                                            onTap: () async {
                                              await Clipboard.setData(ClipboardData(
                                                text: filteredClients[index].phoneNumber ?? '',
                                              ));
                                              copiedIndex.value = index;
                                              ToastService.showSnackBar('Copied to clipboard');
                                              
                                              // Reset the visual feedback after 1 second
                                              Timer(const Duration(seconds: 1), () {
                                                copiedIndex.value = null;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: copiedIndex.value == index 
                                                    ? primaryColor2.withOpacity(0.2) 
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: SvgPicture.asset(
                                                copiedIndex.value == index 
                                                    ? Assets.svg.check 
                                                    : Assets.svg.copy,
                                                width: responsiveData.scaleWidth(16),
                                                height: responsiveData.scaleHeight(16),
                                                colorFilter: ColorFilter.mode(
                                                  copiedIndex.value == index 
                                                      ? primaryColor2 
                                                      : (isDarkMode ? Colors.white : Colors.black),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        },
                        separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.verticalSpace(24)),
                        itemCount: filteredClients.length,
                      ),
                    );
                  },
                  error: (error, _) => PullToRefresh(
                    onRefresh: onRefresh,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('An error occurred: $error'),
                        SizedBox(height: responsiveData.scaleHeight(16)),
                        AppButton(
                          buttonText: 'Retry',
                          onPressed: () async {
                            await onRefresh();
                          },
                        ),
                      ],
                    ),
                  ),
                  loading: () => ListView.separated(
                    shrinkWrap: true,
                    itemCount: 5,
                    separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.verticalSpace(24)),
                    itemBuilder: (_, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: responsiveData.scaleHeight(56),
                          width: responsiveData.scaleHeight(56),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: CustomShimmer(
                            height: responsiveData.scaleHeight(56),
                            width: responsiveData.scaleHeight(56),
                          ),
                        ),
                        SizedBox(width: responsiveData.scaleWidth(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomShimmer(
                                height: responsiveData.scaleHeight(16),
                                width: responsiveData.scaleWidth(120),
                              ),
                              SizedBox(height: responsiveData.scaleHeight(8)),
                              CustomShimmer(
                                height: responsiveData.scaleHeight(14),
                                width: responsiveData.scaleWidth(200),
                              ),
                              SizedBox(height: responsiveData.scaleHeight(12)),
                              CustomShimmer(
                                height: responsiveData.scaleHeight(14),
                                width: responsiveData.scaleWidth(100),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}