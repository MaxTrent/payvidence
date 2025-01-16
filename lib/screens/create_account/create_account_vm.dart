import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountViewModel{
  final WidgetRef ref;
  CreateAccountViewModel(this.ref);



  // final _formKey = GlobalKey<FormState>();
  // final _firstNameController = TextEditingController();
  // final _lastNameController = TextEditingController();
  // static final emailController = TextEditingController();
  // final _phoneNumberController = TextEditingController();
  // final _passwordController = TextEditingController();
  
  static final obscureTextProvider = StateProvider.family<bool, String>((ref, value)=> false);

  static final textEditingControllerProvider = Provider.family.autoDispose<TextEditingController, String>((ref, fieldName) {
    return TextEditingController();
  });
  
  bool obscureText(value) => ref.watch(obscureTextProvider(value));

  TextEditingController textEditingController(value) => ref.watch(textEditingControllerProvider(value));



  void switchVisibility(String value){
    ref.read(obscureTextProvider(value).notifier).state =  !ref.read(obscureTextProvider(value).notifier).state;
  }


}