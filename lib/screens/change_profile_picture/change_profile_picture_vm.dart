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


  ChangeProfilePictureViewModel(this.ref)
      : super() {
    final updateVM = ref.read(updatePersonalDetailsViewModelProvider);
    _currentProfilePictureUrl = updateVM.userInfo?.account.profilePictureUrl;
    print("Initial profile picture URL from UpdatePersonalDetailsVM: $_currentProfilePictureUrl");
  }


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchCurrentProfilePicture() async {
    try {
      final response = await apiServices.getAccount();
      if (response.success) {
        _currentProfilePictureUrl = response.data!['data']['profile_picture_url'];
        print("Current profile picture URL: $_currentProfilePictureUrl");
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching current profile picture: $e");
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

  Future<void> uploadImage({
    required Function() navigateOnSuccess,
  }) async {
    if (_selectedImage == null) {
      handleError(message: "No image selected");
      return;
    }

    _setLoading(true);
    try {
      final response = await apiServices.updateProfilePicture(_selectedImage!);

      if (response.success) {
        _currentProfilePictureUrl =
        response.data!['profile_picture_url'];
        _selectedImage = null;
        showSuccess(
            message: "Profile picture updated");
        notifyListeners();
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      handleError(message: "Something went wrong: $e");
    } finally {
      _setLoading(false);
    }
  }
}
