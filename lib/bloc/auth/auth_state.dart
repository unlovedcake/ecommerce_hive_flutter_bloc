part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class Loading extends AuthState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class Authenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthenticatedSignUp extends AuthState {
  @override
  List<Object?> get props => [];
}

// This is the initial state of the bloc. When the user is not authenticated the state is changed to Unauthenticated.
class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

// If any error occurs the state is changed to AuthErrorSignIn.
class AuthErrorSignIn extends AuthState {
  final String error;

  AuthErrorSignIn(this.error);
  @override
  List<Object?> get props => [error];
}

// If any error occurs the state is changed to AuthErrorSignIn.
class AuthErrorSignUp extends AuthState {
  final String error;

  AuthErrorSignUp(this.error);
  @override
  List<Object?> get props => [error];
}
