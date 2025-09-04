import 'dart:io';
import 'apple_pay_service.dart';
import '../shared_dependency/shared_dependency.dart';
import '../data/api_services.dart';

class SubscriptionPaymentService {
  static Future<List<Map<String, dynamic>>> getSubscriptionPlans() async {
    final result = await locator<ApiServices>().getPlans();
    if (result.success) {
      return List<Map<String, dynamic>>.from(result.data?['data'] ?? []);
    }
    throw Exception('Failed to fetch subscription plans');
  }

  static Future<void> processSubscriptionPayment({
    required String planId,
    required String amount,
    required String planName,
  }) async {
    if (Platform.isIOS) {
      await _processApplePaySubscription(planId, amount, planName);
    } else {
      await _processAndroidPayment(planId, amount, planName);
    }
  }

  static Future<void> _processApplePaySubscription(String planId, String amount, String planName) async {
    final canPay = await ApplePayService.canMakePayments();
    if (!canPay) {
      throw Exception('Apple Pay is not available on this device');
    }

    final paymentItems = ApplePayService.createPaymentItems(
      amount: amount,
      label: planName,
    );

    await ApplePayService.processPayment(
      paymentItems: paymentItems,
      onPaymentToken: (token) async {
        await _subscribeWithPayment(planId, token, 'apple_pay');
      },
    );
  }

  static Future<void> _processAndroidPayment(String planId, String amount, String planName) async {
    throw UnimplementedError('Android payment not implemented yet');
  }

  static Future<void> _subscribeWithPayment(String planId, String paymentToken, String paymentMethod) async {
    final result = await locator<ApiServices>().createSubscription(planId);
    if (!result.success) {
      throw Exception(result.error?.message ?? 'Subscription failed');
    }
  }
}