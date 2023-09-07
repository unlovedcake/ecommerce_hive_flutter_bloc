part of 'internet_bloc.dart';

abstract class InternetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InternetConnectedEvent extends InternetEvent {
  @override
  List<Object> get props => [];
}

class InternetDisconnectedEvent extends InternetEvent {}
