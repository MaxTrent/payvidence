import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/category_model.dart';

import '../../model/business_model.dart';

final getCurrentCategoryProvider =
NotifierProvider<GetCurrentCategoryNotifier, CategoryModel?>(() {
  return GetCurrentCategoryNotifier();
});

class GetCurrentCategoryNotifier extends Notifier<CategoryModel?> {
  @override
  CategoryModel? build() {
    //final userModel = getUser();
    return null;
  }
  void setCurrentCategory(CategoryModel category){
    state = category;
  }
// Add methods to mutate the state
}