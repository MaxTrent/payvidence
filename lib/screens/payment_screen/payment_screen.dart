import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/loading_indicator.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/my_subscription/my_subscription_vm.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import 'package:payvidence/utilities/toast_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'PaymentWebViewRoute')
class PaymentWebViewPage extends StatefulHookConsumerWidget {
  final String paymentLink;
  final String callbackUrl;
  final String cancelAction;

  const PaymentWebViewPage({
    super.key,
    @QueryParam('paymentLink') this.paymentLink = '',
    @QueryParam('callbackUrl') this.callbackUrl = '',
    @QueryParam('cancelAction') this.cancelAction = '',
  });

  @override
  ConsumerState<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends ConsumerState<PaymentWebViewPage> {
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;

    print('PaymentWebViewPage: paymentLink=${widget.paymentLink}, callbackUrl=${widget.callbackUrl}, cancelAction=${widget.cancelAction}, isDarkMode=$isDarkMode');

    final controller = useMemoized(
          () => WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent('Flutter;Webview')
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              isLoading.value = true;
              print('Page started: $url');
            },
            onPageFinished: (url) {
              isLoading.value = false;
              print('Page finished: $url');
            },
            onNavigationRequest: (request) {
              final url = request.url;
              print('Navigation request: $url');

              final normalizedUrl = url.split('?')[0].replaceAll(RegExp(r'/$'), '').toLowerCase();
              final normalizedCallbackUrl = widget.callbackUrl.isNotEmpty
                  ? widget.callbackUrl.split('?')[0].replaceAll(RegExp(r'/$'), '').toLowerCase()
                  : '';
              final normalizedCancelAction = widget.cancelAction.isNotEmpty
                  ? widget.cancelAction.split('?')[0].replaceAll(RegExp(r'/$'), '').toLowerCase()
                  : '';

              if (normalizedCallbackUrl.isNotEmpty && normalizedUrl == normalizedCallbackUrl) {
                print('Intercepted callback: $url');
                ToastService.showSnackBar('Payment completed!');
                // Refresh subscription and navigate to MySubscription
                ref.read(mySubscriptionViewModel).fetchSubscriptions().then((_) {
                  Navigator.pop(context);
                  locator<PayvidenceAppRouter>().replaceNamed(PayvidenceRoutes.mySubscription);
                });
                return NavigationDecision.prevent;
              }

              if (url == 'https://standard.paystack.co/close') {
                print('Intercepted close: $url');
                Navigator.pop(context);
                return NavigationDecision.prevent;
              }

              if (normalizedCancelAction.isNotEmpty && normalizedUrl == normalizedCancelAction) {
                print('Intercepted cancel: $url');
                Navigator.pop(context);
                ToastService.showSnackBar('Payment cancelled.');
                return NavigationDecision.prevent;
              }

              if (url.contains('checkout.paystack.com')) {
                print('Allowing payment page: $url');
                return NavigationDecision.navigate;
              }

              print('Allowing navigation: $url');
              return NavigationDecision.navigate;
            },
            onWebResourceError: (error) {
              isLoading.value = false;
              print('WebView error: ${error.description}');
              ToastService.showErrorSnackBar('Error: ${error.description}');
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.paymentLink.isNotEmpty ? widget.paymentLink : 'about:blank')),
      [widget.paymentLink],
    );

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading.value)
              LoadingIndicator(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}