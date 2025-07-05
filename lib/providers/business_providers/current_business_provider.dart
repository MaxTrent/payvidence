import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/providers/brand_providers/current_brand_provider.dart';
import 'package:payvidence/providers/brand_providers/get_all_brand_provider.dart';
import 'package:payvidence/providers/category_providers/current_category_provider.dart';
import 'package:payvidence/providers/category_providers/get_all_category_provider.dart';
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/providers/product_providers/product_fillter_provider.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import 'package:payvidence/providers/sales_providers/sales_data_provider.dart';
import 'package:payvidence/providers/sales_providers/sales_fillter_provider.dart';

import '../../model/business_model.dart';

final getCurrentBusinessProvider =
    NotifierProvider<GetCurrentBusinessNotifier, Business?>(() {
  return GetCurrentBusinessNotifier();
});

class GetCurrentBusinessNotifier extends Notifier<Business?> {
  @override
  Business? build() {
    //final userModel = getUser();
    return null;
  }

  void setCurrentBusiness(Business business) {
    if (state != business) {
      state = business;
      //reset all providers on business switched
      ref.invalidate(getCurrentProductProvider);
      ref.invalidate(getCurrentBrandProvider);
      ref.invalidate(getCurrentCategoryProvider);
      ref.invalidate(getAllCategoryProvider);
      ref.invalidate(getAllBrandProvider);
      ref.invalidate(productFilterProvider);
      ref.invalidate(salesDataProvider);
      ref.invalidate(getAllReceiptProvider);
      ref.invalidate(getAllInvoiceProvider);
      ref.invalidate(salesFilterProvider);
      
      // Refresh all data providers for new business instead of invalidating
      if (business.id != null) {
        Future.microtask(() {
          try {
            ref.read(getAllProductProvider.notifier).refreshProducts(business.id!);
            ref.read(getAllCategoryProvider.notifier).refreshCategories(business.id!);
            ref.read(getAllBrandProvider.notifier).refreshBrands(business.id!);
            ref.read(getAllReceiptProvider.notifier).refreshReceipts(business.id!);
            ref.read(getAllInvoiceProvider.notifier).refreshInvoices(business.id!);
            ref.read(salesDataProvider.notifier).refreshSales(business.id!);
          } catch (e) {
            print('Error refreshing data: $e');
          }
        });
      }
    }
  }

  void resetCurrentBusiness(Business business) {
    if (state != business) {
      state = business;
    }
  }
// Add methods to mutate the state
}
