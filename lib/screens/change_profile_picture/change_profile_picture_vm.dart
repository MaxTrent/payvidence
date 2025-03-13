import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final changeProfilePictureViewModelProvider = ChangeNotifierProvider((ref) => ChangeProfilePictureViewModel(ref));

class ChangeProfilePictureViewModel extends BaseChangeNotifier {
  final Ref ref;

  ChangeProfilePictureViewModel(this.ref);

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
        _selectedImage = null; // Clear after success
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