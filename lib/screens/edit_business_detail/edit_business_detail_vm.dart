// import 'dart:developer' as developer;
// import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:payvidence/model/business_model.dart';
// import 'package:payvidence/utilities/base_notifier.dart';
//
// final editBusinessDetailViewModel = ChangeNotifierProvider(
//       (ref) => EditBusinessDetailViewModel(ref),
// );
//
// class EditBusinessDetailViewModel extends BaseChangeNotifier {
//   final Ref ref;
//
//   EditBusinessDetailViewModel(this.ref);
//
//   Business? _business;
//   File? _selectedLogoImage;
//   File? _selectedSignatureImage;
//   bool _isLoading = false;
//   String? _currentLogo;
//   String? _currentSignature;
//
//   Business? get businessInfo => _business;
//   File? get selectedLogoImage => _selectedLogoImage;
//   File? get selectedSignatureImage => _selectedSignatureImage;
//   bool get isLoading => _isLoading;
//   String? get currentLogo => _currentLogo;
//   String? get currentSignature => _currentSignature;
//
//   set businessInfo(Business? business) {
//     _business = business;
//     _currentLogo = business?.logoUrl;
//     _currentSignature = business?.issuerSignatureUrl;
//     notifyListeners();
//     print("ViewModel: businessInfo set to $_business");
//   }
//
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> fetchBusinessInformation(String businessId) async {
//
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       print("ViewModel: Fetching business information for businessId: $businessId");
//       final response = await apiServices.getBusinessDetails(businessId!);
//       print(
//           "ViewModel: API response - success: ${response.success}, data: ${response.data}");
//
//       if (response.success) {
//         final businessData = response.data!["data"] as Map<String, dynamic>;
//         businessInfo = Business.fromJson(businessData);
//         print("ViewModel: Business info updated - $businessInfo");
//       } else {
//         var errorMessage = response.error?.errors?.first.message ??
//             response.error?.message ??
//             "An error occurred!";
//         print("ViewModel: API failed - $errorMessage");
//         handleError(message: errorMessage);
//       }
//     } catch (e) {
//       print("ViewModel: Exception - $e");
//       handleError(message: "Something went wrong. Please try again.");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> pickLogoImage() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         _selectedLogoImage = File(pickedFile.path);
//         notifyListeners();
//         print("Logo image selected: ${_selectedLogoImage?.path}");
//       }
//     } catch (e) {
//       print("Error picking logo image: $e");
//       handleError(message: "Failed to pick logo image: $e");
//     }
//   }
//
//   Future<void> pickSignatureImage() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         _selectedSignatureImage = File(pickedFile.path);
//         notifyListeners();
//         print("Signature image selected: ${_selectedSignatureImage?.path}");
//       }
//     } catch (e) {
//       print("Error picking signature image: $e");
//       handleError(message: "Failed to pick signature image: $e");
//     }
//   }
//
//   Future<void> updateBusinessInfo(
//       String businessId, {
//         String? name,
//         String? address,
//         String? phone,
//         File? logo,
//         String? issuer,
//         String? issuerRole,
//         File? signature,
//         required Function() navigateOnSuccess,
//       }) async {
//     _setLoading(true);
//     try {
//       final response = await apiServices.updateBusiness(
//         businessId,
//         name: name,
//         address: address,
//         phone: phone,
//         issuer: issuer,
//         issuerRole: issuerRole,
//         logo: logo,
//         issuerSignature: signature,
//       );
//
//       if (response.success) {
//         final updatedData = response.data!["data"] as Map<String, dynamic>;
//         businessInfo = Business.fromJson(updatedData);
//         _selectedLogoImage = null;
//         _selectedSignatureImage = null;
//         showSuccess(message: "Business details updated successfully");
//         notifyListeners();
//         navigateOnSuccess();
//       } else {
//         var errorMessage = response.error?.errors?.first.message ??
//             response.error?.message ??
//             "An error occurred!";
//         _selectedLogoImage = null;
//         _selectedSignatureImage = null;
//         handleError(message: errorMessage);
//         notifyListeners();
//       }
//     } catch (e, stackTrace) {
//       _selectedLogoImage = null;
//       _selectedSignatureImage = null;
//       developer.log(
//           'Login error',
//           error: e.toString(),
//           stackTrace: stackTrace,
//           name: 'LoginViewModel'
//       );
//       print(e);
//       handleError(message: "Something went wrong");
//       notifyListeners();
//     } finally {
//       _setLoading(false);
//     }
//   }
// }