import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../data/network/api_response.dart';

final addClientViewModelProvider =
ChangeNotifierProvider((ref) => AddClientViewModel(ref));

class AddClientViewModel extends BaseChangeNotifier {
  final Ref ref;

  AddClientViewModel(this.ref);

  bool _isLoading = false;
  ApiResult? _lastResponse; // Add property to store the last response

  bool get isLoading => _isLoading;
  ApiResult? get lastResponse => _lastResponse; // Add getter

  Future<void> addClient({
    required String name,
    String? address,
    String? phoneNumber,
    required String businessId,
    required Function() navigateOnSuccess,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      print(
          "ViewModel: Adding client with name: $name, address: $address, phoneNumber: $phoneNumber, businessId: $businessId");
      final response =
      await apiServices.addClient(name, address, phoneNumber, businessId);
      _lastResponse = response; // Store the response
      print(
          "ViewModel: Add client response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        print("ViewModel: Client added successfully");
        showSuccess(message: 'Client Added');
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "Failed to add client!";
        print("ViewModel: Add client failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception during add client - $e");
      handleError(
          message: "An unexpected error occurred while adding the client.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}