import 'package:bloc/bloc.dart';
import 'package:ecoville_bloc/data/services/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../authentication_bloc/authentication_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<Login>((event, emit) async {
      try {
        emit(LoginLoading());
        final user = await AuthRepository()
            .loginUser(email: event.email, password: event.password);
        if (user) {
          AuthenticationBloc().add(LoggedIn());
          emit(LoginSuccess());
        } else {
          emit(const LoginFailure(message: 'Login Failed'));
        }
      } catch (e) {
        emit(LoginFailure(message: e.toString()));
      }
    });

    on<Register>((event, emit) async {
      try {
        emit(RegisterLoading());
        final user = await AuthRepository().registerUser(
            email: event.email, password: event.password, name: event.name);
        if (user) {
          AuthenticationBloc().add(LoggedIn());
          emit(RegisterSuccess());
        } else {
          emit(const RegisterFailure(message: 'Register Failed'));
        }
      } catch (e) {
        emit(RegisterFailure(message: e.toString()));
      }
    });

    on<Logout>((event, emit) async {
      try {
        emit(LogoutLoading());
        final user = await AuthRepository().logoutUser();
        if (user) {
          AuthenticationBloc().add(LoggedOut());
          emit(LogoutSuccess());
        } else {
          emit(const LogoutFailure(message: 'Logout Failed'));
        }
      } catch (e) {
        emit(LogoutFailure(message: e.toString()));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      try {
        emit(ResetPasswordLoading());
        final user = await AuthRepository().resetPassword(email: event.email);
        if (user) {
          emit(ResetPasswordSuccess());
        } else {
          emit(const ResetPasswordFailure(message: 'Reset Password Failed'));
        }
      } catch (e) {
        emit(ResetPasswordFailure(message: e.toString()));
      }
    });

    on<ChangePassword>((event, emit) async {
      try {
        emit(ResetPasswordLoading());
        final user = await AuthRepository().changePassword(
          email: event.email,
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
        );
        if (user) {
          emit(ResetPasswordSuccess());
        } else {
          emit(const ResetPasswordFailure(message: 'Update Password Failed'));
        }
      } catch (e) {
        emit(ResetPasswordFailure(message: e.toString()));
      }
    });

    on<DeleteAccount>((event, emit) async {
      try {
        emit(DeleteAccountLoading());
        final user = await AuthRepository()
            .deleteUser(email: event.email, password: event.password);
        if (user) {
          emit(DeleteAccountSuccess());
        } else {
          emit(const DeleteAccountFailure(message: 'Delete Account Failed'));
        }
      } catch (e) {
        emit(DeleteAccountFailure(message: e.toString()));
      }
    });

    on<GoogleAuthentication>((event, emit) async {
      try {
        emit(GoogleLoginLoading());
        final user = await AuthRepository().signInWithGoogle();

        if (user) {
          AuthenticationBloc().add(LoggedIn());
          emit(GoogleLoginSuccess());
        } else {
          emit(const GoogleLoginFailure(message: 'Google Login Failed'));
        }
      } catch (e) {
        emit(GoogleLoginFailure(message: e.toString()));
      }
    });
  }
}
