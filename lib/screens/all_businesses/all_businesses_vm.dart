import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/business_model.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final allBusinessesViewModel = ChangeNotifierProvider<AllBusinessesViewModel>(
      (ref) => AllBusinessesViewModel(ref),
);

class AllBusinessesViewModel extends BaseChangeNotifier {
  final Ref ref;

  AllBusinessesViewModel(this.ref);

  List<Business> _allBusinesses = [];
  bool _isLoading = false;

  List<Business> get allBusinesses => _allBusinesses;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchAllBusinesses() async {
    try {
      _setLoading(true);

      print("ViewModel: Fetching all businesses");
      final response = await apiServices.getBusiness();
      print("ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        final businessData = response.data?["data"] as List<dynamic>?;
        if (businessData != null) {
          _allBusinesses = businessData.map((data) => Business.fromJson(data as Map<String, dynamic>)).toList();
          print("ViewModel: All businesses updated - $_allBusinesses");
        } else {
          print("ViewModel: No business data found in response");
          handleError(message: "Failed to fetch businesses.");
          _allBusinesses = [];
        }
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        print("ViewModel: API failed - $errorMessage");
        handleError(message: errorMessage);
        _allBusinesses = [];
      }
    } catch (e) {
      print("ViewModel: Exception - $e");
      handleError(message: "Something went wrong. Please try again.");
      _allBusinesses = [];
    } finally {
      _setLoading(false);
    }
  }
}