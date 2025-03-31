import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/utilities/base_notifier.dart';
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

    fetchCurrentProfilePicture();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchCurrentProfilePicture() async {
    try {
      _setLoading(true);
      final response = await apiServices.getAccount();
      if (response.success && response.data != null) {
        _currentProfilePictureUrl =
            response.data!['data']['profile_picture_url'] as String?;
        print("Fetched profile picture URL: $_currentProfilePictureUrl");
        if (_currentProfilePictureUrl == null ||
            _currentProfilePictureUrl!.isEmpty) {
          print("Profile picture URL is null or empty, using default");
        }
      } else {
        _currentProfilePictureUrl = null;
        print(
            "Failed to fetch profile picture: ${response.error?.message ?? 'Unknown error'}");
      }
    } catch (e) {
      _currentProfilePictureUrl = null; // Reset on exception
      print("Error fetching current profile picture: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        notifyListeners();
        print("Image selected: ${_selectedImage?.path}");
      }
    } catch (e) {
      print("Error picking image: $e");
      handleError(message: "Failed to pick image: $e");
    }
  }

  Future<void> uploadImage({required Function() navigateOnSuccess}) async {
    if (_selectedImage == null) {
      handleError(message: "No image selected");
      return;
    }

    _setLoading(true);
    try {
      final response = await apiServices.updateProfilePicture(_selectedImage!);

      if (response.success) {
        _currentProfilePictureUrl =
            response.data!['profile_picture_url'] as String?;
        _selectedImage = null;
        showSuccess(message: "Profile picture updated");
        notifyListeners();
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        _selectedImage = null; // Reset the selected image
        handleError(message: errorMessage);
        notifyListeners(); // Update UI to show "Choose image" again
      }
    } catch (e) {
      _selectedImage = null; // Reset on exception
      handleError(message: "Something went wrong: $e");
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }
}
