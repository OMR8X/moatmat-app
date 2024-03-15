part of 'auth_cubit_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthOnBoarding extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthStartAuth extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSignIn extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSignUP extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthDone extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthError extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthResetPassword extends AuthState {
  @override
  List<Object> get props => [];
}
