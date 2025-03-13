import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final mySubscriptionViewModel = ChangeNotifierProvider((ref)=> MySubscriptionViewModel(ref));

class MySubscriptionViewModel extends BaseChangeNotifier{
  final Ref ref;
  MySubscriptionViewModel(this.ref);


}