part of 'favorites_bloc.dart';

enum FavoriteStatus { INITIAL, LOADING, COMPLETED, ERROR }

@immutable
class FavoritesState extends Equatable {
  final FavoriteStatus status;
  final String? error;
  final List<String>? documentFavoriteId;

  const FavoritesState(
      {required this.status, this.error, this.documentFavoriteId});

  factory FavoritesState.initial() {
    return const FavoritesState(status: FavoriteStatus.INITIAL);
  }

  FavoritesState copyWith({
    required FavoriteStatus status,
    String? error,
    List<String>? documentFavoriteIds,
  }) {
    return FavoritesState(
        status: status, error: error, documentFavoriteId: documentFavoriteIds);
  }

  @override
  List<Object?> get props => [status, error, documentFavoriteId];
}

// @immutable
// abstract class FavoritesState extends Equatable {}

// class ProductsFavoriteInitialState extends FavoritesState {
//   @override
//   List<Object?> get props => [];
// }

// class ProductsFavoriteLoadingState extends FavoritesState {
//   @override
//   List<Object?> get props => [];
// }

// class ProductsFavoriteLoadedState extends FavoritesState {
//   final List<String>? documentIdFavorites;

//   ProductsFavoriteLoadedState({this.documentIdFavorites})
//       : assert(documentIdFavorites != null);

//   @override
//   List<Object> get props => [documentIdFavorites!];
// }

// class ProductFavoritesAddedState extends FavoritesState {
//   @override
//   List<Object?> get props => [];
// }

// class ProductFavoritesUpdatedState extends FavoritesState {
//   @override
//   List<Object?> get props => [];
// }

// class ProductsFavoriteErrorState extends FavoritesState {
//   final String error;

//   ProductsFavoriteErrorState(this.error);
//   @override
//   List<Object?> get props => [error];
// }
