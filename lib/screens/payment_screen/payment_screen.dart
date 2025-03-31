import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/loading_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';


@RoutePage(name: 'PaymentWebViewRoute')
class PaymentWebViewPage extends StatefulHookConsumerWidget {
  final String paymentLink;

  const PaymentWebViewPage({super.key, @QueryParam('paymentLink') this.paymentLink = ''});

  @override
  ConsumerState<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends ConsumerState<PaymentWebViewPage> {
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);


    final controller = useMemoized(
          () => WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              isLoading.value = true;
            },
            onPageFinished: (url) {
              isLoading.value = false;
              print("Page finished: $url");
              // Navigator.pop(context);
              if (url.contains('success') || url.contains('callback')) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment completed!')),
                );
              }
            },
            onWebResourceError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${error.description}')),
              );
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.paymentLink)),
      [widget.paymentLink],
    );


    useEffect(() {
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading.value) const LoadingIndicator(),
        ],
      ),
    );
  }
}