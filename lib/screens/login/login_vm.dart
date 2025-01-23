import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel{
  final WidgetRef ref;
  LoginViewModel(this.ref);

  static final textEditingControllerProvider = Provider.family
      .autoDispose<TextEditingController, String>((ref, fieldName) {
    return TextEditingController();
  });


  TextEditingController textEditingController(value) =>
      ref.watch(textEditingControllerProvider(value));

}