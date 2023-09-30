part of 'add_to_cart_bloc.dart';

abstract class AddToCartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartQuantityItemEvent extends AddToCartEvent {
  final int quantity;
  CartQuantityItemEvent(this.quantity);
}

class AddCartQuantityItemEvent extends AddToCartEvent {
  final List<Map<String, dynamic>>? addToCartsListItems;
  AddCartQuantityItemEvent(this.addToCartsListItems);
}

class CancelledCartQuantityItemEvent extends AddToCartEvent {
  final List<Map<String, dynamic>>? addToCartsListItem;
  final int id;
  CancelledCartQuantityItemEvent(this.addToCartsListItem, this.id);
}
