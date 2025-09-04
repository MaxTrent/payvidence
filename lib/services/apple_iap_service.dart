import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class AppleIAPService {
  static final AppleIAPService _instance = AppleIAPService._internal();
  factory AppleIAPService() => _instance;
  AppleIAPService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  // CRITICAL: These must exactly match App Store Connect product IDs
  // Free plan doesn't need got IAP (no purchase required)
  static const Set<String> _productIds = {
    'business_monthly',   // Replace with actual ID
    'premium_monthly',    // Replace with actual ID
    'corporate_monthly',  // Replace with actual ID
  };

  Future<void> initialize() async {
    if (!Platform.isIOS) return;
    
    final InAppPurchaseStoreKitPlatformAddition iosAddition =
        _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    await iosAddition.setDelegate(PaymentQueueDelegate());

    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => print('Purchase stream error: $error'),
    );
  }

  Future<List<ProductDetails>> getProducts() async {
    if (!Platform.isIOS) return [];
    
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception('In-app purchases not available');
    }

    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds);
    if (response.notFoundIDs.isNotEmpty) {
      print('Products not found: ${response.notFoundIDs}');
    }
    
    return response.productDetails;
  }

  Future<void> purchaseProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // Handle pending purchase
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _handleSuccessfulPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _handleFailedPurchase(purchaseDetails);
          break;
        case PurchaseStatus.canceled:
          // Handle canceled purchase
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    // TODO: Add server-side verification for production
    // For now, trust the client-side purchase
    print('Purchase successful: ${purchaseDetails.productID}');
    
    // Update local subscription status
    // You should still save this to your backend/database
  }

  void _handleFailedPurchase(PurchaseDetails purchaseDetails) {
    print('Purchase failed: ${purchaseDetails.error}');
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  void dispose() {
    _subscription.cancel();
  }
}

class PaymentQueueDelegate extends SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}