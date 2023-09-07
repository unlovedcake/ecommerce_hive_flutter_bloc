part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMarkersEvent extends SearchEvent {
  final String? name;
  GetMarkersEvent(this.name);
}

class GetMarkerUserEvent extends SearchEvent {
  GetMarkerUserEvent();
}
