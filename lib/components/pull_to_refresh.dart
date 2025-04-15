import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:payvidence/utilities/toast_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'loading_indicator.dart';

class PullToRefresh extends HookWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final bool enablePullUp;

  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.enablePullUp = false,
  });

  @override
  Widget build(BuildContext context) {
    final refreshController = useMemoized(() => RefreshController(initialRefresh: false));

    useEffect(() {
      return () => refreshController.dispose();
    }, []);

    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: enablePullUp,
      header: CustomHeader(
        builder: (BuildContext context, RefreshStatus? mode) {
          if (mode == RefreshStatus.refreshing) {
            return const LoadingIndicator();
          }
          return const SizedBox.shrink();
        },
      ),
      onRefresh: () async {
        try {
          await onRefresh();
          refreshController.refreshCompleted();
        } catch (e) {
          refreshController.refreshFailed();
          print('Refresh error: $e');

          if (context.mounted) {
            ToastService.showErrorSnackBar('Refresh failed');
          }
        }
      },
      child: child,
    );
  }
}