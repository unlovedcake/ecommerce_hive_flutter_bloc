part of 'search_bloc.dart';

// ignore: constant_identifier_names
enum SearchStatus { INITIAL, LOADING, COMPLETED, ERROR }

class SearchState extends Equatable {
  final SearchStatus status;
  final String? error;
  final List<Marker>? markers;

  const SearchState({required this.status, this.error, this.markers});

  factory SearchState.initial() {
    return const SearchState(status: SearchStatus.INITIAL);
  }

  SearchState copyWith(
      {required SearchStatus status, String? error, List<Marker>? marker}) {
    return SearchState(status: status, error: error, markers: marker);
  }

  @override
  List<Object?> get props => [status, error, markers];
}

// @immutable
// abstract class SearchState extends Equatable {}

// class MarkersInitialState extends SearchState {
//   @override
//   List<Object?> get props => [];
// }

// class MarkersLoadingState extends SearchState {
//   @override
//   List<Object?> get props => [];
// }

// class MarkersLoadedState extends SearchState {
//   final List<Marker>? Markers;

//   MarkersLoadedState({this.Markers}) : assert(Markers != null);

//   @override
//   List<Object> get props => [Markers!];
// }

// class MarkerFavoritesAddedState extends SearchState {
//   @override
//   List<Object?> get props => [];
// }

// class MarkersErrorState extends SearchState {
//   final String error;

//   MarkersErrorState(this.error);
//   @override
//   List<Object?> get props => [error];
// }
