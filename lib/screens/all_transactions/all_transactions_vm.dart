import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/transactions_model.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final allTransactionsViewModelProvider =
    ChangeNotifierProvider((ref) => AllTransactionsViewModel(ref));

class AllTransactionsViewModel extends BaseChangeNotifier {
  final Ref ref;
  AllTransactionsViewModel(this.ref);

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  Transaction? _selectedTransaction;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  Transaction? get selectedTransaction => _selectedTransaction;

  set transactions(List<Transaction> value) {
    _transactions = value;
    notifyListeners();
    print("ViewModel: plans set to $_transactions");
  }

  set selectedTransactions(Transaction? value) {
    _selectedTransaction = value;
    notifyListeners();
    print("ViewModel: selectedPlan set to $_selectedTransaction");
  }

  Future<void> fetchTransactions(String businessId) async {
    try {
      _isLoading = true;
      notifyListeners();

      print("ViewModel: Fetching plans");
      final response = await apiServices.getAllTransactions(businessId);
      print(
          "ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        final transactionData = response.data!["data"];
        if (transactionData is List) {
          transactions = transactionData
              .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          print("ViewModel: Unexpected data format - $transactionData");
          handleError(message: "Unexpected data format");
          return;
        }
        print("ViewModel: Plans updated - $transactions");
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        print("ViewModel: API failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception - $e");
      handleError(message: "Something went wrong. Please try again.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
