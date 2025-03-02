import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

import '../../model/business_model.dart';

final homePageViewModel = ChangeNotifierProvider((ref)=> HomePageViewModel(ref));

class HomePageViewModel extends BaseChangeNotifier{
  final Ref ref;
  HomePageViewModel(this.ref);

  Business? _business;
  Business? get businessInfo => _business;
  set businessInfo(Business? business) {
    _business = business;
    notifyListeners();
  }

  Future<void> getBusiness() async {
  try {

    final response = await apiServices.getBusiness();

    if (response.success) {
      if(response.data!["data"][0]){
        businessInfo = Business.fromJson(response.data!["data"][0]);
        notifyListeners();
      }
    } else {

      var errorMessage = response.error?.errors?.first.message ??
          response.error?.message ??
          "An error occurred!";
      handleError(message: errorMessage);
    }
  } catch (e) {
  }
}

}