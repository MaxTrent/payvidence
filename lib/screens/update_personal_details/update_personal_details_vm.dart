import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../model/user_model.dart';

final updatePersonalDetailsViewModelProvider =
ChangeNotifierProvider((ref) => UpdatePersonalDetailsViewModel(ref));

class UpdatePersonalDetailsViewModel extends BaseChangeNotifier {
  final Ref ref;

  UpdatePersonalDetailsViewModel(this.ref);

  User? _user;
  bool _isLoading = false;
  bool _isEditing = false;

  User? get userInfo => _user;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;

  set userInfo(User? user) {
    _user = user;
    notifyListeners();
    print("ViewModel: userInfo set to $_user");
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
    print("ViewModel: Editing mode toggled to $_isEditing");
  }

  Future<void> fetchUserInformation() async {
    try {
      _isLoading = true;
      notifyListeners();

      print("ViewModel: Fetching user information");
      final response = await apiServices.getAccount();
      print(
          "ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        final userData = response.data!["data"];
        userInfo = User(
          account: Account.fromJson(userData as Map<String, dynamic>),
          token: null,
        );
        print("ViewModel: User info updated - ${userInfo?.account}");
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

  Future<void> updateUserInfo({
    String? newFirstName,
    String? newLastName,
    String? newPhoneNumber,
    bool? transactionalAlerts,
    bool? promotionalUpdates,
    bool? securityAlerts,
    required Function() navigateOnSuccess,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      print("ViewModel: Updating user with newFirstName: $newFirstName");
      final response = await apiServices.updateUserInfo(firstName: newFirstName, lastName: newLastName, phoneNumber: newPhoneNumber);
      print(
          "ViewModel: Update response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        if (response.data != null && response.data!.containsKey("data")) {
          _user = User(
            account: Account.fromJson(
                response.data!["data"] as Map<String, dynamic>),
            token: _user?.token,
          );
        } else {
          _user = _user?.copyWith(
            account: _user!.account.copyWith(firstName: newFirstName),
          ) ??
              User(
                account: Account(
                  firstName: newFirstName ?? '',
                  lastName: newLastName,
                  phoneNumber: newPhoneNumber,
                  transactionalAlerts: transactionalAlerts,
                  promotionalUpdates: promotionalUpdates,
                  securityAlerts: securityAlerts
                ),
                token: null,
              );
        }
        _isEditing = false;
        showSuccess(message: 'User details updated!');
        notifyListeners();
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "Failed to update user!";
        print("ViewModel: Update failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception during update - $e");
      handleError(
          message: "An unexpected error occurred while updating the user.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}