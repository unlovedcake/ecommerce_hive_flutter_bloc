import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './internet_event.dart';
part './internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity? connectivity;

  StreamSubscription? connectivityStreamSubscription;
  InternetBloc({this.connectivity}) : super(InternetState.initial()) {
    StreamSubscription<ConnectivityResult> monitorInternetConnection() {
      return connectivityStreamSubscription =
          connectivity!.onConnectivityChanged.listen((connectivityResult) {
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(status: InternetStatus.DISCONNECTED));
          print('_disconnected');
        } else if (connectivityResult == ConnectivityResult.wifi) {
          emit(state.copyWith(status: InternetStatus.CONNECTED));
          print('_connected wifi');
        } else {
          emit(state.copyWith(status: InternetStatus.CONNECTED));
          print('_connected mobile');
        }
      });
    }

    on<InternetConnectedEvent>((event, emit) async {
      emit(state.copyWith(status: InternetStatus.LOADING));

      monitorInternetConnection();
    });
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription!.cancel();
    return super.close();
  }
}
