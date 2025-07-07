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
  bool _hasLoadedTransactions = false;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  Transaction? get selectedTransaction => _selectedTransaction;
  bool get hasLoadedTransactions => _hasLoadedTransactions;

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
    if (_isLoading) return; // Prevent multiple simultaneous calls
    
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
          final newTransactions = transactionData
              .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
              .toList();
          
          // Remove duplicates based on transaction ID
          final uniqueTransactions = <String, Transaction>{};
          for (final transaction in newTransactions) {
            if (transaction.id != null) {
              uniqueTransactions[transaction.id!] = transaction;
            }
          }
          
          transactions = uniqueTransactions.values.toList()
            ..sort((a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
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
        // handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception - $e");
      handleError(message: "Something went wrong. Please try again.");
    } finally {
      _isLoading = false;
      _hasLoadedTransactions = true;
      notifyListeners();
    }
  }

  void refreshTransactionsIfNeeded(String businessId) {
    // Only refresh if we have existing data to avoid unnecessary calls
    if (_transactions.isNotEmpty) {
      fetchTransactions(businessId);
    }
  }

  void forceRefreshTransactions(String businessId) {
    _hasLoadedTransactions = false;
    fetchTransactions(businessId);
  }
}
