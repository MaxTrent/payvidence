import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';


final profileViewModelProvider = ChangeNotifierProvider((ref)=> ProfileViewModel(ref));
class ProfileViewModel extends BaseChangeNotifier{
 late Ref ref;

 ProfileViewModel(this.ref);

}