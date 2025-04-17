import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/providers/client_providers/get_all_client_provider.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
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

    return Scaffold(
      appBar: AppBar(
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
                  padding: EdgeInsets.only(right: 20.w),
                  child: GestureDetector(
                    onTap: () async {
                      await locator<PayvidenceAppRouter>()
                          .navigate(AddClientRoute(businessId: businessId));
                      ref.read(getAllClientsProvider.notifier).fetchClients();
                    },
                    child: Text(
                      '+ Add New',
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 14.sp,
                        color: primaryColor2,
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32.h),
            AppTextField(
              prefixIcon: Padding(
                padding: EdgeInsets.all(16.h),
                child: SvgPicture.asset(Assets.svg.search,  colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),),
              ),
              hintText: 'Search for client',
              controller: searchController,
              radius: 80,
              filled: true,
              fillColor: isDarkMode ? Colors.black : appGrey5 ,
            ),
            SizedBox(height: 20.h),
            allClients.when(
              data: (data) {
                // Filter clients
                final filteredClients = searchQuery.value.isEmpty
                    ? data
                    : data
                    .where((client) => client.name
                    ?.toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ?? false)
                    .toList();

                if (filteredClients.isEmpty) {
                  return Expanded(
                    child: PullToRefresh(
                      onRefresh: onRefresh,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            searchQuery.value.isEmpty
                                ? 'No clients available!'
                                : 'No clients found!',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            searchQuery.value.isEmpty
                                ? 'All added clients will appear here.'
                                : 'Try a different search term.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp),
                          ),
                          if (searchQuery.value.isEmpty) ...[
                            SizedBox(height: 48.h),
                            AppButton(
                              buttonText: 'Add client',
                              onPressed: () async {
                                await locator<PayvidenceAppRouter>().navigate(
                                    AddClientRoute(businessId: businessId));
                                ref
                                    .read(getAllClientsProvider.notifier)
                                    .fetchClients();
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: PullToRefresh(
                    onRefresh: onRefresh,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
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
                                height: 56.h,
                                width: 56.h,
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
                                      fontSize: 20.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      filteredClients[index].name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          Assets.svg.location,
                                          colorFilter: ColorFilter.mode(
                                            isDarkMode ? Colors.white : Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Expanded(
                                          child: Text(
                                            filteredClients[index].address ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(fontSize: 14.sp),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        Text(
                                          filteredClients[index].phoneNumber ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(fontSize: 14.sp),
                                        ),
                                        SizedBox(width: 8.w),
                                        GestureDetector(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                              text: filteredClients[index]
                                                  .phoneNumber ??
                                                  '',
                                            ));
                                            ToastService.showSnackBar(
                                                'Copied to clipboard');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Copied to clipboard',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  ),
                                                ),
                                                backgroundColor: primaryColor2,
                                              ),
                                            );
                                          },
                                          child:
                                          SvgPicture.asset(Assets.svg.copy),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (ctx, idx) => SizedBox(height: 24.h),
                      itemCount: filteredClients.length,
                    ),
                  ),
                );
              },
              error: (error, _) => Expanded(
                child: PullToRefresh(
                  onRefresh: onRefresh,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('An error has occurred'),
                    ],
                  ),
                ),
              ),
              loading: () => Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (ctx,idx)=>12.verticalSpace,
                  itemCount: 5,
                  itemBuilder: (_, index) => CustomShimmer(height: 60.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}