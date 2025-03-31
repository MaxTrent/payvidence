import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/add_brand/add_brand.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import 'add_client_viewmodel.dart';

@RoutePage(name: 'AddClientRoute')
class AddClient extends HookConsumerWidget {
  final String businessId;

  const AddClient({super.key, @QueryParam('businessId') this.businessId = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(addClientViewModelProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final nameController = useTextEditingController();
    final addressController = useTextEditingController();
    final phoneNumberController = useTextEditingController();
    // final businessId = locator<SessionManager>().get(SessionConstants.businessId) as String?;

    final areFieldsEmpty = useState(true);

    bool checkFieldsEmpty() {
      return nameController.text.isEmpty ||
          addressController.text.isEmpty ||
          phoneNumberController.text.isEmpty;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        areFieldsEmpty.value = checkFieldsEmpty();
        print("Fields empty: ${areFieldsEmpty.value}");
      }

      nameController.addListener(updateFieldsEmptyStatus);
      addressController.addListener(updateFieldsEmptyStatus);
      phoneNumberController.addListener(updateFieldsEmptyStatus);

      return () {
        nameController.removeListener(updateFieldsEmptyStatus);
        addressController.removeListener(updateFieldsEmptyStatus);
        phoneNumberController.removeListener(updateFieldsEmptyStatus);
      };
    }, []);

    print('b.Id = $businessId');

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    'Add new client',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Fill in the details below to add your client.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Client name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 8.h),
                  AppTextField(
                    hintText: 'Client name',
                    controller: nameController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Client name is required';
                      }
                      if (val.length < 2) {
                        return 'Name must be at least 2 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Client phone number',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 8.h),
                  AppTextField(
                    hintText: 'Client phone number',
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!val.isValidPhone) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Client address',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 8.h),
                  AppTextField(
                    hintText: 'Client address',
                    controller: addressController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Address is required';
                      }
                      if (val.length < 5) {
                        return 'Address must be at least 5 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        buttonText: 'Add client',
                        isDisabled: areFieldsEmpty.value,
                        isProcessing: viewModel.isLoading,
                        onPressed: () {
                          if (formKey.currentState!.validate() && businessId != null) {
                            FocusScope.of(context).unfocus();
                            viewModel.addClient(
                              name: nameController.text,
                              address: addressController.text,
                              phoneNumber: phoneNumberController.text,
                              businessId: businessId,
                              navigateOnSuccess: () {
                                locator<PayvidenceAppRouter>().push( ClientSuccessRoute(name: nameController.text));
                              },
                            );
                          } else {
                            print("Business ID is null, cannot add client");
                          }
                        },
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}