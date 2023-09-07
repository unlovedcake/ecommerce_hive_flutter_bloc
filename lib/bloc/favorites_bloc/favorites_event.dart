part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateFavoritesProductEvent extends FavoritesEvent {
  final String id;
  UpdateFavoritesProductEvent(this.id);
}

class GetProductsFavoritesEvent extends FavoritesEvent {}

class AddFavoritesProductEvent extends FavoritesEvent {
  final String id;
  AddFavoritesProductEvent(this.id);
}
