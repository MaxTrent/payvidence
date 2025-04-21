import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../model/user_model.dart';
import '../../shared_dependency/shared_dependency.dart';

final updatePersonalDetailsViewModelProvider =
ChangeNotifierProvider((ref) => UpdatePersonalDetailsViewModel(ref));

class UpdatePersonalDetailsViewModel extends BaseChangeNotifier {
  final Ref ref;

  UpdatePersonalDetailsViewModel(this.ref);

  User? _user;
  bool _isLoading = false;
  bool _isEditing = false;
  bool _isUpdating = false;

  User? get userInfo => _user;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  bool get isUpdating => _isUpdating;

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
        // Save to SessionManager to keep local data fresh
        await locator<SessionManager>().save(
          key: SessionConstants.userFirstName,
          value: userInfo?.account.firstName ?? '',
        );
        await locator<SessionManager>().save(
          key: SessionConstants.userLastName,
          value: userInfo?.account.lastName ?? '',
        );
        await locator<SessionManager>().save(
          key: SessionConstants.userEmail,
          value: userInfo?.account.email ?? '',
        );
        await locator<SessionManager>().save(
          key: SessionConstants.userPhone,
          value: userInfo?.account.phoneNumber ?? '',
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
    bool? showToast,
    required Function() navigateOnSuccess,
  }) async {
    try {
      _isLoading = true;
      _isUpdating = true;
      notifyListeners();

      print("ViewModel: Updating user with transactionalAlerts: $transactionalAlerts, promotionalUpdates: $promotionalUpdates, securityAlerts: $securityAlerts");
      final response = await apiServices.updateUserInfo(
        firstName: newFirstName,
        lastName: newLastName,
        phoneNumber: newPhoneNumber,
        transactionalAlerts: transactionalAlerts,
        promotionalUpdates: promotionalUpdates,
        securityAlerts: securityAlerts,
      );
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
            account: _user!.account.copyWith(
              firstName: newFirstName,
              lastName: newLastName,
              phoneNumber: newPhoneNumber,
              transactionalAlerts: transactionalAlerts ?? _user!.account.transactionalAlerts,
              promotionalUpdates: promotionalUpdates ?? _user!.account.promotionalUpdates,
              securityAlerts: securityAlerts ?? _user!.account.securityAlerts,
            ),
          ) ??
              User(
                account: Account(
                  firstName: newFirstName ?? '',
                  lastName: newLastName,
                  phoneNumber: newPhoneNumber,
                  transactionalAlerts: transactionalAlerts ?? false,
                  promotionalUpdates: promotionalUpdates ?? false,
                  securityAlerts: securityAlerts ?? false,
                ),
                token: null,
              );
        }
        // Save updated info to SessionManager
        await locator<SessionManager>().save(
          key: SessionConstants.userFirstName,
          value: _user?.account.firstName ?? '',
        );
        await locator<SessionManager>().save(
          key: SessionConstants.userLastName,
          value: _user?.account.lastName ?? '',
        );
        await locator<SessionManager>().save(
          key: SessionConstants.userEmail,
          value: _user?.account.email ?? '',
        );
        await locator<SessionManager>().save(
          key: SessionConstants.userPhone,
          value: _user?.account.phoneNumber ?? '',
        );
        _isEditing = false;
        if (showToast == true) {
          showSuccess(message: 'User Info updated!');
        }
        notifyListeners();
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "Failed to update settings!";
        print("ViewModel: Update failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception during update - $e");
      handleError(message: "An unexpected error occurred while updating settings.");
    } finally {
      _isLoading = false;
      _isUpdating = false;
      notifyListeners();
    }
  }
}