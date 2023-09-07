import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/models/product_model.dart';
import 'package:hive/repositories/product_repository.dart';
import 'package:hive/repositories/search_repository.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState.initial()) {
    on<GetMarkersEvent>((event, emit) async {
      //emit(ProductsLoadingState(status: Status.LOADING));
      emit(state.copyWith(status: SearchStatus.LOADING));
      try {
        final markers = await SearchRepository.getNearbyPlaces(event.name!);
        emit(state.copyWith(marker: markers, status: SearchStatus.COMPLETED));
        //emit(ProductsLoadedState(products: products,status: Status.COMPLETED));
      } catch (e) {
        //emit(ProductsErrorState(error: e.toString(),status: Status.ERROR));
        emit(state.copyWith(error: e.toString(), status: SearchStatus.ERROR));
      }
    });
    on<GetMarkerUserEvent>((event, emit) async {
      emit(state.copyWith(status: SearchStatus.LOADING));
      try {
        final userMarker = await SearchRepository.userMarker();
        emit(
            state.copyWith(marker: userMarker, status: SearchStatus.COMPLETED));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: SearchStatus.ERROR));
      }
    });
  }
}
