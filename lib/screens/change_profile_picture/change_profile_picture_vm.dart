import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../model/user_model.dart';
import '../update_personal_details/update_personal_details_vm.dart';

final changeProfilePictureViewModelProvider =
ChangeNotifierProvider((ref) => ChangeProfilePictureViewModel(ref));

class ChangeProfilePictureViewModel extends BaseChangeNotifier {
  final Ref ref;

  File? _selectedImage;
  String? _currentProfilePictureUrl;
  bool _isLoading = false;

  File? get selectedImage => _selectedImage;
  String? get currentProfilePictureUrl => _currentProfilePictureUrl;
  bool get isLoading => _isLoading;

  ChangeProfilePictureViewModel(this.ref) : super() {
    final updateVM = ref.read(updatePersonalDetailsViewModelProvider);
    _currentProfilePictureUrl = updateVM.userInfo?.account.profilePictureUrl;
    print(
        "Initial profile picture URL from UpdatePersonalDetailsVM: $_currentProfilePictureUrl");
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        notifyListeners();
        print("Photo captured: ${_selectedImage?.path}");
      } else {
        print("No photo captured (user cancelled)");
      }
    } catch (e) {
      print("Error capturing photo: $e");
      handleError(message: "Failed to capture photo: $e");
    }
  }

  Future<void> uploadImage({required Function() navigateOnSuccess}) async {
    if (_selectedImage == null) {
      handleError(message: "No photo selected");
      return;
    }

    _setLoading(true);
    try {
      final response = await apiServices.updateProfilePicture(_selectedImage!);

      if (response.success) {
        _currentProfilePictureUrl =
        response.data!['profile_picture_url'] as String?;
        _selectedImage = null;

        // Update UpdatePersonalDetailsViewModel
        final updateVM = ref.read(updatePersonalDetailsViewModelProvider);
        if (updateVM.userInfo != null) {
          updateVM.userInfo = updateVM.userInfo!.copyWith(
            account: updateVM.userInfo!.account.copyWith(
              profilePictureUrl: _currentProfilePictureUrl,
            ),
          );
        } else {
          // If userInfo is null, create a minimal User object
          updateVM.userInfo = User(
            account: Account(
              profilePictureUrl: _currentProfilePictureUrl,
              firstName: '',
              lastName: '',
              email: '',
              phoneNumber: '',
              transactionalAlerts: false,
              promotionalUpdates: false,
              securityAlerts: false,
            ),
            token: null,
          );
        }

        // Update SessionManager
        await locator<SessionManager>().save(
          key: SessionConstants.profilePictureUrl,
          value: _currentProfilePictureUrl ?? '',
        );

        showSuccess(message: "Profile picture updated");
        notifyListeners();
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        _selectedImage = null;
        handleError(message: errorMessage);
        notifyListeners();
      }
    } catch (e) {
      _selectedImage = null;
      handleError(message: "Something went wrong: $e");
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }
}