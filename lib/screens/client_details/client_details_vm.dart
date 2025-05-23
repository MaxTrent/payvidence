import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final clientDetailsViewModelViewModelProvider =
ChangeNotifierProvider((ref) => ClientDetailsViewModel(ref));

class ClientDetailsViewModel extends BaseChangeNotifier {
  final Ref ref;

  ClientDetailsViewModel(this.ref);

  ClientModel? _client;
  bool _isLoading = false;
  bool _isEditing = false;

  ClientModel? get clientInfo => _client;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
    print("ViewModel: Editing mode toggled to $_isEditing");
  }

  set clientInfo(ClientModel? client) {
    _client = client;
    notifyListeners();
    print("ViewModel: clientInfo set to $_client");
  }

  Future<void> fetchClientDetails(String businessId, String clientId) async {
    try {
      _isLoading = true;
      notifyListeners();

      print("ViewModel: Fetching client information");
      final response = await apiServices.getClientInfo(businessId, clientId);
      print(
          "ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        final clientData = response.data!["data"];
        clientInfo = ClientModel.fromJson(clientData as Map<String, dynamic>);
        print("ViewModel: Client info updated - $clientInfo");
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        print("ViewModel: API failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception - $e");
      handleError(message: "Something went wrong. Please try again.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeClient({
    required String businessId,
    required String clientId,
    required Function() navigateOnSuccess,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      print(
          "ViewModel: Removing client with businessId: $businessId, clientId: $clientId");
      final response = await apiServices.deleteClient(businessId, clientId);
      print(
          "ViewModel: Delete response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        print("ViewModel: Client removed successfully");
        _client = null;
        showSuccess(message: 'Client Removed');
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "Failed to remove client!";
        print("ViewModel: Delete failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception during remove - $e");
      handleError(
          message: "An unexpected error occurred while removing the client.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateClient({
    required String businessId,
    required String clientId,
    required String newName,
    required Function() navigateOnSuccess,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if _client is null
      if (_client == null) {
        print("ViewModel: Error - Client data not loaded before update");
        handleError(
            message: "Client data not loaded. Please try again later.");
        return;
      }

      print(
          "ViewModel: Updating client with businessId: $businessId, clientId: $clientId, newName: $newName");
      final response =
      await apiServices.updateClient(businessId, clientId, newName);
      print(
          "ViewModel: Update response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        // Update clientInfo with the new data from the response (if provided) or manually
        if (response.data != null && response.data!.containsKey("data")) {
          _client = ClientModel.fromJson(
              response.data!["data"] as Map<String, dynamic>);
        } else {
          // Since _client is guaranteed to be non-null, update manually
          _client = _client!.copyWith(name: newName);
        }
        _isEditing = false;
        showSuccess(message: 'Client details updated!');
        notifyListeners(); // Trigger UI update
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "Failed to update client!";
        print("ViewModel: Update failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception during update - $e");
      handleError(
          message: "An unexpected error occurred while updating the client.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}