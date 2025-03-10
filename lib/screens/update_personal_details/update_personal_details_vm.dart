import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

import '../../model/user_model.dart';

final updatePersonalDetailsViewModelProvider = ChangeNotifierProvider((ref)=>UpdatePersonalDetailsViewModel(ref));
class UpdatePersonalDetailsViewModel extends BaseChangeNotifier{
  final Ref ref;

  UpdatePersonalDetailsViewModel(this.ref);

  User? _user;

  User? get userInfo => _user;

  set userInfo(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUserInformation() async {
    try {

      final response = await apiServices.getAccount();

      if (response.success) {

        userInfo = User.fromJson(response.data!["data"]);

        notifyListeners();
      } else {

        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}