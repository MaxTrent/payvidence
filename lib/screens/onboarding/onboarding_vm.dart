import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final onboardingScreenViewModelProvider =
ChangeNotifierProvider<OnboardingScreenViewModel>((ref) {
  return OnboardingScreenViewModel(ref);
});

class OnboardingScreenViewModel extends ChangeNotifier {
  final Ref ref;
  OnboardingScreenViewModel(this.ref);

  static final currentPageProvider = StateProvider((ref) => 0);

  int get currentPageIndex => ref.watch(currentPageProvider);

  void changeIndex(index){
    ref.read(currentPageProvider.notifier).state = index;
  }

}