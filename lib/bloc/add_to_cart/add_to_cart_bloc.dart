import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/repositories/product_repository.dart';
import 'package:meta/meta.dart';

part './add_to_cart_event.dart';
part './add_to_cart_state.dart';

class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  AddToCartBloc() : super(AddToCartState.initial()) {
    on<CartQuantityItemEvent>((event, emit) async {
      //emit(ProductsFavoriteLoadingState());
      emit(state.copyWith(status: AddToCartStatus.LOADING));
      try {
        emit(state.copyWith(
            status: AddToCartStatus.COMPLETED, quantityItems: event.quantity));
      } catch (e) {
        emit(state.copyWith(status: AddToCartStatus.ERROR));
      }
    });

    on<AddCartQuantityItemEvent>((event, emit) async {
      emit(state.copyWith(status: AddToCartStatus.LOADING));
      try {
        emit(state.copyWith(
            status: AddToCartStatus.COMPLETED,
            addToCartsListItems: event.addToCartsListItems));
      } catch (e) {
        emit(state.copyWith(status: AddToCartStatus.ERROR));
      }
    });

    on<CancelledCartQuantityItemEvent>((event, emit) async {
      emit(state.copyWith(status: AddToCartStatus.LOADING));
      try {
        event.addToCartsListItem!.removeWhere(
            (item) => item["id"] == state.addToCartsListItem![event.id]['id']);
        emit(state.copyWith(
            status: AddToCartStatus.COMPLETED,
            addToCartsListItems: event.addToCartsListItem));
      } catch (e) {
        emit(state.copyWith(status: AddToCartStatus.ERROR));
      }
    });
  }
}
