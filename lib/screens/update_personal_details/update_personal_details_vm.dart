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

  User? get userInfo => _user;
  bool get isLoading => _isLoading;

  set userInfo(User? user) {
    _user = user;
    notifyListeners();
    print("ViewModel: userInfo set to $_user");
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
}
