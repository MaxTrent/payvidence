import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/product_model.dart';

final getCurrentProductProvider =
    NotifierProvider<GetCurrentProductNotifier, Product?>(() {
  return GetCurrentProductNotifier();
});

class GetCurrentProductNotifier extends Notifier<Product?> {
  @override
  Product? build() {
    //final userModel = getUser();
    return null;
  }

  void setCurrentProduct(Product product) {
    state = product;
  }
// Add methods to mutate the state
}
