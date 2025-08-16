import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/gen/assets.gen.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DeleteAccountBottomSheet extends HookWidget {
  final Function(String password, VoidCallback resetLoading) onConfirm;
  
  const DeleteAccountBottomSheet({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    final passwordController = useTextEditingController();
    final passwordNotifier = useState('');
    final isLoading = useState(false);
    final obscureText = useState(true);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    
    useEffect(() {
      void updatePassword() {
        passwordNotifier.value = passwordController.text;
      }
      passwordController.addListener(updatePassword);
      return () => passwordController.removeListener(updatePassword);
    }, []);
    
    return Container(
      padding: EdgeInsets.all(responsiveData.paddingHorizontal),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(responsiveData.largeRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: responsiveData.scaleWidth(40),
              height: responsiveData.scaleHeight(4),
              decoration: BoxDecoration(
                color: Colors.grey[300] ?? Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: responsiveData.scaleHeight(24)),
          Text(
            'Delete Account',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: responsiveData.scaleHeight(8)),
          Text(
            'This action cannot be undone. Please enter your password to confirm.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.grey[600] ?? Colors.grey,
            ),
          ),
          SizedBox(height: responsiveData.scaleHeight(24)),
          AppTextField(
            controller: passwordController,
            hintText: 'Enter your password',
            obscureText: obscureText.value,
            enabled: !isLoading.value,
            suffixIcon: Padding(
              padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
              child: GestureDetector(
                onTap: () => obscureText.value = !obscureText.value,
                child: SvgPicture.asset(
                  Assets.svg.password,
                  height: responsiveData.scaleHeight(24),
                  width: responsiveData.scaleWidth(24),
                  colorFilter: ColorFilter.mode(
                    isDarkMode ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: responsiveData.scaleHeight(24)),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonText: 'Cancel',
                  onPressed: isLoading.value ? null : () => Navigator.pop(context),
                  backgroundColor: Colors.grey[300] ?? Colors.grey,
                  textColor: Colors.black,
                ),
              ),
              SizedBox(width: responsiveData.scaleWidth(12)),
              Expanded(
                child: AppButton(
                  buttonText: 'Delete Account',
                  isProcessing: isLoading.value,
                  onPressed: passwordNotifier.value.isEmpty || isLoading.value
                      ? null
                      : () async {
                          isLoading.value = true;
                          onConfirm(passwordNotifier.value, () {
                            isLoading.value = false;
                          });
                        },
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: responsiveData.scaleHeight(16)),
        ],
      ),
    );
  }
}