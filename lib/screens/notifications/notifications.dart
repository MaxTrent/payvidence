import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/model/notification_model.dart';
import '../../gen/assets.gen.dart';
import 'notifications_vm.dart';

@RoutePage(name: 'NotificationsRoute')
class Notifications extends HookConsumerWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(notificationsViewModel);

    useEffect(() {
      if (viewModel.notifications.isEmpty && !viewModel.isLoading) {
        viewModel.fetchNotifications();
      }
      return null;
    }, []);

    Future<void> onRefresh() async {
        await viewModel.fetchNotifications();
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 28.h),
            Expanded(
              child: viewModel.isLoading
                  ? ListView.builder(
                itemCount: 3, // Show 3 shimmer placeholders
                itemBuilder: (context, index) {
                  return _buildShimmerPlaceholder(context);
                },
              )
                  : viewModel.notifications.isEmpty
                  ? PullToRefresh(
                onRefresh: onRefresh,
                    child: ListView(
                      children: [
                        Center(
                                        child: Text(
                        'No notifications available',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 16.sp),
                                        ),
                                      ),
                      ],
                    ),
                  )
                  : PullToRefresh(
                onRefresh: onRefresh,
                    child: ListView.builder(
                                    itemCount: viewModel.notifications.length,
                                    itemBuilder: (context, index) {
                    final notification = viewModel.notifications[index];
                    return NotificationTile(notification: notification);
                                    },
                                  ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Row(
        children: [
          CustomShimmer(
            height: 62.h,
            width: 58.w,
            // borderRadius: BorderRadius.circular(31.h), // Circular shape
          ),
          SizedBox(width: 16.w), // Matches ListTile's default leading-to-title spacing
          Expanded(
            child: CustomShimmer(
              height: 16.h,
              width: double.infinity,
            ),
          ),
          SizedBox(width: 16.w), // Matches ListTile's default title-to-trailing spacing
          CustomShimmer(
            height: 14.h,
            width: 50.w, // Approximate width of the time text (e.g., "12:00PM")
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour % 12;
    hour = hour == 0 ? 12 : hour;
    return '$hour:${dateTime.minute.toString().padLeft(2, '0')}${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: const Color(0xffd9d9d966),
      contentPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 18.h),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      leading: Container(
        height: 62.h,
        width: 58.w,
        decoration: const BoxDecoration(
          color: primaryColor4,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(14.h),
          child: SvgPicture.asset(Assets.svg.notification),
        ),
      ),
      title: Text(
        notification.details,
        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16.sp),
      ),
      trailing: Text(
        _formatTime(notification.createdAt),
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(fontSize: 14.sp, color: const Color(0xff8B8B8B)),
      ),
    );
  }
}