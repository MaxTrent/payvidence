import 'package:auto_route/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/loading_indicator.dart';
import 'package:payvidence/utilities/toast_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage(name: 'PaymentWebViewRoute')
class PaymentWebViewPage extends StatefulHookConsumerWidget {
  final String paymentLink;
  final String callbackUrl;
  final String cancelUrl;

  const PaymentWebViewPage({
    super.key,
    @QueryParam('paymentLink') this.paymentLink = '',
    this.callbackUrl = 'https://hello.pstk.xyz/callback', // Adjust based on your setup
    this.cancelUrl = 'https://your-cancel-url.com',       // Adjust based on your setup
  });

  @override
  ConsumerState<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends ConsumerState<PaymentWebViewPage> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.paystack.co',
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Authorization': 'Bearer sk_test_xxx', // Replace with your Paystack secret key
      'Content-Type': 'application/json',
    },
  ));

  Future<void> verifyTransaction(String reference) async {
    try {
      final response = await _dio.get('/transaction/verify/$reference');
      final data = response.data;

      if (data['status'] == true && data['data']['status'] == 'success') {
        ToastService.showSnackBar('Payment completed successfully!');
        Navigator.pop(context);
      } else {
        ToastService.showErrorSnackBar('Payment verification failed.');
      }
    } on DioException catch (e) {
      ToastService.showErrorSnackBar('Error verifying payment: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);
    final isVerifying = useState(false);

   final reference = Uri.parse(widget.paymentLink).pathSegments.last;

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

              if (url == widget.callbackUrl) {
                isVerifying.value = true;
                verifyTransaction(reference).then((_) {
                  isVerifying.value = false;
                });
                return NavigationDecision.prevent;
              }

              if (url == 'https://standard.paystack.co/close') {
                Navigator.pop(context);
                return NavigationDecision.prevent;
              }

              if (url == widget.cancelUrl) {
                Navigator.pop(context);
                ToastService.showSnackBar('Payment cancelled.');
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
            onWebResourceError: (error) {
              isLoading.value = false;
              ToastService.showErrorSnackBar('Error: ${error.description}');
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.paymentLink)),
      [widget.paymentLink],
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading.value) const LoadingIndicator(),
            if (isVerifying.value)
              const Center(child: LoadingIndicator()),
          ],
        ),
      ),
    );
  }
}