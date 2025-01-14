abstract class BaseState {
  final bool isLoading;
  final String? error;

  BaseState({required this.isLoading, this.error});
}