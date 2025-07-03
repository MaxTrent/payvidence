import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/loading_indicator.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/change_profile_picture/change_profile_picture_vm.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import '../../gen/assets.gen.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive_wrapper.dart';

@RoutePage(name: 'ChangeProfilePictureRoute')
class ChangeProfilePicture extends HookConsumerWidget {
  const ChangeProfilePicture({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(changeProfilePictureViewModelProvider);
    final isImageSelected = useState(viewModel.selectedImage != null);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    useEffect(() {
      void listener() {
        isImageSelected.value = viewModel.selectedImage != null;
      }

      viewModel.addListener(listener);
      return () => viewModel.removeListener(listener);
    }, [viewModel]);

    useEffect(() {
      // Refresh profile picture when screen loads
      viewModel.refreshProfilePicture();
      // Clear cached image to force refresh
      if (viewModel.currentProfilePictureUrl != null) {
        CachedNetworkImage.evictFromCache(viewModel.currentProfilePictureUrl!);
      }
      return null;
    }, []);

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: responsiveData.scaleHeight(16)),
                Text(
                  'Change profile picture',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: responsiveData.scaleHeight(8)),
                Text(
                  'You can update your picture here.',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: responsiveData.scaleHeight(32)),
                Center(
                  child: CircleAvatar(
                    radius: responsiveData.scaleHeight(90),
                    backgroundColor: Colors.purple,
                    child: ClipOval(
                      child: viewModel.selectedImage != null
                          ? Image.file(
                        viewModel.selectedImage!,
                        fit: BoxFit.cover,
                        width: responsiveData.scaleWidth(200),
                        height: responsiveData.scaleHeight(200),
                      )
                          : viewModel.currentProfilePictureUrl != null &&
                          viewModel.currentProfilePictureUrl!.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: viewModel.currentProfilePictureUrl!,
                        fit: BoxFit.cover,
                        width: responsiveData.scaleWidth(200),
                        height: responsiveData.scaleHeight(200),
                        placeholder: (context, url) => LoadingIndicator(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: responsiveData.scaleWidth(200),
                          height: responsiveData.scaleHeight(200),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode ? Colors.grey[800] : const Color(0xFFE8E8E8),
                          ),
                          child: Icon(
                            Icons.person,
                            size: responsiveData.scaleHeight(80),
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      )
                          : Container(
                        width: responsiveData.scaleWidth(200),
                        height: responsiveData.scaleHeight(200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? Colors.grey[800] : const Color(0xFFE8E8E8),
                        ),
                        child: Icon(
                          Icons.person,
                          size: responsiveData.scaleHeight(80),
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsiveData.scaleHeight(32)),
                AppButton(
                  isProcessing: viewModel.isLoading,
                  isDisabled: viewModel.isLoading,
                  buttonText: viewModel.selectedImage == null
                      ? 'Take photo'
                      : 'Upload photo',
                  onPressed: () {
                    if (viewModel.selectedImage == null) {
                      viewModel.pickImage();
                    } else {
                      viewModel.uploadImage(
                        navigateOnSuccess: () {
                          // Clear all cached images to force refresh
                          CachedNetworkImage.evictFromCache(viewModel.currentProfilePictureUrl ?? '');
                          // Add a small delay to ensure cache is cleared
                          Future.delayed(const Duration(milliseconds: 100), () {
                            locator<PayvidenceAppRouter>().back();
                          });
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}