import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  final String? loadingMessage;
  const AuthLoadingState([this.loadingMessage]);

  @override
  List<Object?> get props => [loadingMessage];
}

class AuthenticatedState extends AuthState {
  final UserEntity user;

  const AuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class AuthFailureState extends AuthState {
  final String errorMessage;
  final Failure? failure;

  const AuthFailureState(this.errorMessage, {this.failure});

  @override
  List<Object?> get props => [errorMessage, failure];
}

class PasswordResetSentState extends AuthState {
  final String email;

  const PasswordResetSentState(this.email);

  @override
  List<Object?> get props => [email];
}
