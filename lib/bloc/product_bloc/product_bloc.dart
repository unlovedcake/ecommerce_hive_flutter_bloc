import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/models/product_model.dart';
import 'package:hive/repositories/product_repository.dart';

part './product_event.dart';
part './product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductState.initial()) {
    on<GetProductsFeaturedEvent>((event, emit) async {
      emit(state.copyWith(status: Status.LOADING));
      try {
        final products = await ProductRepository.getAllFeaturedProducts();
        emit(state.copyWith(
            product: products, status: Status.FEATUREDPRODUCTSCOMPLETED));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: Status.ERROR));
      }
    });

    on<GetProductsJolliBeeEvent>((event, emit) async {
      emit(state.copyWith(status: Status.LOADING));
      try {
        final products =
            await ProductRepository.fetchProductsJolliBee(event.category!);
        emit(state.copyWith(
            product: products, status: Status.JOLLIBEECOMPLETED));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: Status.ERROR));
      }
    });

    on<GetProductsChowkingEvent>((event, emit) async {
      emit(state.copyWith(status: Status.LOADING));
      try {
        final products =
            await ProductRepository.fetchProductsChowKing(event.category!);
        emit(state.copyWith(
            product: products, status: Status.CHOWKINGCOMPLETED));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: Status.ERROR));
      }
    });

    on<GetProductsMcDonaldEvent>((event, emit) async {
      emit(state.copyWith(status: Status.LOADING));
      try {
        final products =
            await ProductRepository.fetchProductsMcDonald(event.category!);
        emit(state.copyWith(
            product: products, status: Status.MCDONALDCOMPLETED));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: Status.ERROR));
      }
    });
  }
}
