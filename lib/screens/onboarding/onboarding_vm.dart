import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreenViewModel {
  final WidgetRef ref;
  OnboardingScreenViewModel(this.ref);

  static final currentPageProvider = StateProvider((ref) => 0);

  int get currentPageIndex => ref.watch(currentPageProvider);

  void changeIndex(index){
    ref.read(currentPageProvider.notifier).state = index;
  }

}