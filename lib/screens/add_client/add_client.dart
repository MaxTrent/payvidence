import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive_wrapper.dart';
import 'add_client_viewmodel.dart';

@RoutePage(name: 'AddClientRoute')
class AddClient extends HookConsumerWidget {
  final String businessId;

  const AddClient({super.key, @QueryParam('businessId') this.businessId = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(addClientViewModelProvider);
    final responsiveData = ResponsiveInherited.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final nameController = useTextEditingController();
    final addressController = useTextEditingController();
    final phoneNumberController = useTextEditingController();

    final areFieldsEmpty = useState(true);

    bool checkFieldsEmpty() {
      return nameController.text.trim().length < 2;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        final isEmpty = checkFieldsEmpty();
        if (areFieldsEmpty.value != isEmpty) {
          areFieldsEmpty.value = isEmpty;
        }
        print("Fields empty: ${areFieldsEmpty.value}");
      }

      nameController.addListener(updateFieldsEmptyStatus);

      return () {
        nameController.removeListener(updateFieldsEmptyStatus);
      };
    }, []);

    print('b.Id = $businessId');

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus,
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: SafeArea(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    SizedBox(height: responsiveData.scaleHeight(16)),
                    Text(
                      'Add new client',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(8)),
                    Text(
                      'Fill in the details below to add your client.',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(32)),
                    Text(
                      'Client name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(8)),
                    AppTextField(
                      hintText: 'Client name',
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
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
                    SizedBox(height: responsiveData.scaleHeight(20)),
                    Text(
                      'Client phone number',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(8)),
                    AppTextField(
                      hintText: 'Client phone number',
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (val) {
                        if (val != null && val.isNotEmpty && !val.trim().isValidPhone) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsiveData.scaleHeight(20)),
                    Text(
                      'Client address',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(8)),
                    AppTextField(
                      hintText: 'Client address',
                      controller: addressController,
                      validator: (val) {
                        if (val != null && val.isNotEmpty && val.length < 5) {
                          return 'Address must be at least 5 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: responsiveData.scaleHeight(32)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppButton(
                          buttonText: 'Add client',
                          isDisabled: areFieldsEmpty.value,
                          isProcessing: viewModel.isLoading,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              viewModel.addClient(
                                name: nameController.text,
                                address: addressController.text,
                                phoneNumber: phoneNumberController.text,
                                businessId: businessId,
                                navigateOnSuccess: () {
                                  locator<PayvidenceAppRouter>().push(
                                      ClientSuccessRoute(
                                          name: nameController.text));
                                },
                              );
                            } else {
                              print("Business ID is null, cannot add client");
                            }
                          },
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}