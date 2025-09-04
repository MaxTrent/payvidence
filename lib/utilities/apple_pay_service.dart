import 'dart:convert';
import 'dart:io';
import 'package:pay/pay.dart';

class ApplePayService {
  static const String _merchantId = 'merchant.com.payvidence';
  static Pay? _payInstance;

  static PaymentConfiguration get applePayConfig {
    final config = {
      "provider": "apple_pay",
      "data": {
        "merchantIdentifier": _merchantId,
        "displayName": "Payvidence",
        "merchantCapabilities": ["3DS", "debit", "credit"],
        "supportedNetworks": ["visa", "mastercard", "amex"],
        "countryCode": "NG",
        "currencyCode": "NGN"
      }
    };
    return PaymentConfiguration.fromJsonString(jsonEncode(config));
  }

  static Pay get _pay {
    _payInstance ??= Pay({PayProvider.apple_pay: applePayConfig});
    return _payInstance!;
  }

  static bool get isIOSDevice => Platform.isIOS;

  static Future<bool> canMakePayments() async {
    if (!isIOSDevice) return false;
    
    try {
      return await _pay.userCanPay(PayProvider.apple_pay);
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> processPayment({
    required List<PaymentItem> paymentItems,
    required Function(String) onPaymentToken,
  }) async {
    if (!isIOSDevice) {
      throw Exception('Apple Pay is not supported on this device');
    }

    final result = await _pay.showPaymentSelector(
      PayProvider.apple_pay,
      paymentItems,
    );
    
    final paymentToken = result['paymentData']?['data'] ?? result.toString();
    onPaymentToken(paymentToken);
    
    return result;
  }


  static List<PaymentItem> createPaymentItems({
    required String amount,
    required String label,
    String? subtotal,
    String? tax,
  }) {
    final items = <PaymentItem>[];
    
    if (subtotal != null) {
      items.add(PaymentItem(label: 'Subtotal', amount: subtotal));
    }
    if (tax != null) {
      items.add(PaymentItem(label: 'Tax', amount: tax));
    }
    
    items.add(PaymentItem(
      label: label,
      amount: amount,
      status: PaymentItemStatus.final_price,
    ));
    
    return items;
  }
}