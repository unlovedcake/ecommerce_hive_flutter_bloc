import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/repositories/auth_repository.dart';

import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(UnAuthenticated()) {
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await AuthRepository.signIn(
            email: event.email, password: event.password);
        //     .then((_) {
        //   emit(Authenticated());
        //   print('okey');
        // }).catchError((e) {
        //   print('okeys');
        //   print(e.toString());
        //   if (e.toString().contains('interrupted connection')) {
        //     emit(AuthErrorSignIn('No Internet Access'));
        //   } else {
        //     emit(AuthErrorSignIn(e.toString()));
        //   }
        // });
      } catch (e) {
        emit(AuthErrorSignIn(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await AuthRepository.signUp(
            name: event.name, email: event.email, password: event.password);
        emit(AuthenticatedSignUp());
      } catch (e) {
        emit(AuthErrorSignUp(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await AuthRepository.signInWithGoogle();
        emit(Authenticated());
      } catch (e) {
        emit(AuthErrorSignIn(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await AuthRepository.signOut();
      emit(UnAuthenticated());
    });
  }
}
