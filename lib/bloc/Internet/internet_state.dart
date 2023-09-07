part of 'internet_bloc.dart';

enum InternetStatus { INITIAL, LOADING, CONNECTED, DISCONNECTED }

@immutable
class InternetState extends Equatable {
  final InternetStatus status;
  final String? error;
  final ConnectivityResult? connectivityResult;

  const InternetState(
      {required this.status, this.error, this.connectivityResult});

  factory InternetState.initial() {
    return const InternetState(status: InternetStatus.INITIAL);
  }

  InternetState copyWith({
    required InternetStatus status,
    String? error,
    ConnectivityResult? connectivityResults,
  }) {
    return InternetState(
        status: status, error: error, connectivityResult: connectivityResults);
  }

  @override
  List<Object?> get props => [status, error, connectivityResult];
}
