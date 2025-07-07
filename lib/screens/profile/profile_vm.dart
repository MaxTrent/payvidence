import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../shared_dependency/shared_dependency.dart';

final profileViewModelProvider =
    ChangeNotifierProvider((ref) => ProfileViewModel(ref));

class ProfileViewModel extends BaseChangeNotifier {
  late Ref ref;

  ProfileViewModel(this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> logout({
    required Function() navigateOnSuccess,
  }) async {
    _setLoading(true);
    try {
      final response = await apiServices.logout();

      if (response.success) {
        await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: false);
        _setLoading(false);
        navigateOnSuccess();
      } else {
        // Even if server logout fails, logout locally
        await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: false);
        _setLoading(false);
        navigateOnSuccess();
      }
    } catch (e) {
      // Even if network fails, logout locally
      await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: false);
      _setLoading(false);
      navigateOnSuccess();
    }
  }
}
