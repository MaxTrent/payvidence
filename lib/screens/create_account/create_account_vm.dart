import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountViewModel{
  final WidgetRef ref;
  CreateAccountViewModel(this.ref);

  static final firstNameControllerProvider = Provider((ref)=> TextEditingController());
  static final lastNameController = Provider((ref)=> TextEditingController());

  TextEditingController get firstNameController => ref.watch(firstNameControllerProvider);


}