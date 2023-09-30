part of 'add_to_cart_bloc.dart';

enum AddToCartStatus { INITIAL, LOADING, COMPLETED, CANCELLED, ERROR }

@immutable
class AddToCartState extends Equatable {
  final AddToCartStatus status;
  final String? error;
  int? quantityItem;
  List<Map<String, dynamic>>? addToCartsListItem = [];

  AddToCartState(
      {required this.status,
      this.error,
      this.quantityItem,
      this.addToCartsListItem});

  factory AddToCartState.initial() {
    return AddToCartState(status: AddToCartStatus.INITIAL);
  }

  AddToCartState copyWith({
    required AddToCartStatus status,
    String? error,
    int? quantityItems,
    List<Map<String, dynamic>>? addToCartsListItems,
  }) {
    return AddToCartState(
        status: status,
        error: error,
        quantityItem: quantityItems,
        addToCartsListItem: addToCartsListItems);
  }

  @override
  List<Object?> get props => [status, error, quantityItem, addToCartsListItem];
}
