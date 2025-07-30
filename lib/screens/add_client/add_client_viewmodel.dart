import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../data/network/api_response.dart';

// Main provider for AddClientViewModel
final addClientViewModelProvider =
ChangeNotifierProvider((ref) => AddClientViewModel(ref));

// Providers to expose specific state
final addClientLoadingProvider = Provider<bool>((ref) {
  return ref.watch(addClientViewModelProvider).isLoading;
});

final addClientLastResponseProvider = Provider<ApiResult?>((ref) {
  return ref.watch(addClientViewModelProvider).lastResponse;
});

class AddClientViewModel extends BaseChangeNotifier {
  final Ref ref;

  AddClientViewModel(this.ref);

  bool _isLoading = false;
  ApiResult? _lastResponse;

  bool get isLoading => _isLoading;
  ApiResult? get lastResponse => _lastResponse;
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
      print('addClient: Starting API call for name: $name, businessId: $businessId');
      final response = await apiServices.addClient(name, address, phoneNumber, businessId);
      _lastResponse = response;
      print('addClient: API response - success: ${response.success}, data: ${response.data}, error: ${response.error}');

      if (response.success) {
        print('addClient: Success path triggered');
        showSuccess(message: 'Client Added');
        navigateOnSuccess();
      } else {
        print('addClient: Failure path triggered, error: ${response.error}');
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "Failed to add client!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      print('addClient: Exception occurred - $e');
      handleError(message: "An unexpected error occurred while adding the client.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}