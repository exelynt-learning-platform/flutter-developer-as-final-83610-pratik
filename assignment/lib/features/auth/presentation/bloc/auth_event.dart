import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequestedEvent extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  const RegisterRequestedEvent({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class GoogleSignInRequestedEvent extends AuthEvent {
  const GoogleSignInRequestedEvent();
}

class ForgotPasswordRequestedEvent extends AuthEvent {
  final String email;

  const ForgotPasswordRequestedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class LogoutRequestedEvent extends AuthEvent {
  const LogoutRequestedEvent();
}

class AuthUserChangedInternalEvent extends AuthEvent {
  final UserEntity? user;

  const AuthUserChangedInternalEvent(this.user);

  @override
  List<Object?> get props => [user];
}
