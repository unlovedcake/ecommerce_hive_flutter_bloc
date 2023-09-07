import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/repositories/product_repository.dart';
import 'package:meta/meta.dart';

part './favorites_event.dart';
part './favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesState.initial()) {
    on<AddFavoritesProductEvent>((event, emit) async {
      //emit(ProductsFavoriteLoadingState());
      emit(state.copyWith(status: FavoriteStatus.LOADING));
      try {
        await ProductRepository.addFavorites(event.id);
        //emit(ProductFavoritesAddedState());
        emit(state.copyWith(status: FavoriteStatus.COMPLETED));
      } catch (e) {
        emit(state.copyWith(status: FavoriteStatus.ERROR));
        // emit(ProductsFavoriteErrorState(e.toString()));
      }
    });

    on<UpdateFavoritesProductEvent>((event, emit) async {
      //emit(ProductsFavoriteLoadingState());
      emit(state.copyWith(status: FavoriteStatus.LOADING));
      try {
        await ProductRepository.updateIsHeartField(event.id);
        //emit(ProductFavoritesUpdatedState());
        emit(state.copyWith(status: FavoriteStatus.COMPLETED));
      } catch (e) {
        emit(state.copyWith(status: FavoriteStatus.ERROR));
        //emit(ProductsFavoriteErrorState(e.toString()));
      }
    });

    on<GetProductsFavoritesEvent>((event, emit) async {
      //emit(ProductsFavoriteLoadingState());
      emit(state.copyWith(status: FavoriteStatus.LOADING));
      try {
        final docIdFavorites =
            await ProductRepository.fetchFavoriteDocumentIds();
        //emit(ProductsFavoriteLoadedState(documentIdFavorites: docIdFavorites));
        emit(state.copyWith(
            documentFavoriteIds: docIdFavorites,
            status: FavoriteStatus.COMPLETED));
      } catch (e) {
        //emit(ProductsFavoriteErrorState(e.toString()));
        emit(state.copyWith(status: FavoriteStatus.ERROR));
      }
    });
  }
}
