import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final addClientViewModelProvider =
    ChangeNotifierProvider((ref) => AddClientViewModel(ref));

class AddClientViewModel extends BaseChangeNotifier {
  final Ref ref;

  AddClientViewModel(this.ref);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addClient({
    required String name,
    required String address,
    required String phoneNumber,
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
