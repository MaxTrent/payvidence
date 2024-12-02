import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageViewModel{
  final WidgetRef ref;
  HomePageViewModel(this.ref);

  // int _selectedIndex = 0;

  static final _selectedIndexProvider = StateProvider((ref)=>0);
  int get selectedIndex => ref.watch(_selectedIndexProvider);

  void onItemTapped(int index) {
      ref.read(_selectedIndexProvider.notifier).state = index;
  }

}