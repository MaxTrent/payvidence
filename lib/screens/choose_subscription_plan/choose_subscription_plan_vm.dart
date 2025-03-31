import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../model/plan_model.dart'; // Update path if needed

final chooseSubscriptionPlanViewModel =
    ChangeNotifierProvider((ref) => ChooseSubscriptionPlanViewModel(ref));

class ChooseSubscriptionPlanViewModel extends BaseChangeNotifier {
  final Ref ref;
  ChooseSubscriptionPlanViewModel(this.ref);

  List<Plan> _plans = [];
  bool _isLoading = false;
  Plan? _selectedPlan;

  List<Plan> get plans => _plans;
  bool get isLoading => _isLoading;
  Plan? get selectedPlan => _selectedPlan;

  set plans(List<Plan> value) {
    _plans = value;
    notifyListeners();
    print("ViewModel: plans set to $_plans");
  }

  set selectedPlan(Plan? value) {
    _selectedPlan = value;
    notifyListeners();
    print("ViewModel: selectedPlan set to $_selectedPlan");
  }

  Future<void> fetchPlans() async {
    try {
      _isLoading = true;
      notifyListeners();

      print("ViewModel: Fetching plans");
      final response = await apiServices.getPlans();
      print(
          "ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        final planData = response.data!["data"];
        if (planData is List) {
          plans = planData
              .map((item) => Plan.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          print("ViewModel: Unexpected data format - $planData");
          handleError(message: "Unexpected data format");
          return;
        }
        print("ViewModel: Plans updated - $plans");
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        print("ViewModel: API failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception - $e");
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPlanDetails(String planId) async {
    try {
      _isLoading = true;
      notifyListeners();
      print("ViewModel: Fetching plan details for planId: $planId");
      final response = await apiServices.getOnePlan(planId);
      print(
          "ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        final planData = response.data!["data"];
        selectedPlan = Plan.fromJson(planData as Map<String, dynamic>);
        print("ViewModel: Plan details updated - $selectedPlan");
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        print("ViewModel: API failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception - $e");
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
