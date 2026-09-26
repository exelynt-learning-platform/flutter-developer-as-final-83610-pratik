abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.message == message &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;

  @override
  String toString() =>
      '$runtimeType(message: $message, statusCode: $statusCode)';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class AuthFailure extends Failure {
  final String? code;

  const AuthFailure({required super.message, this.code});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthFailure &&
        other.message == message &&
        other.code == code;
  }

  @override
  int get hashCode => super.hashCode ^ code.hashCode;
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    super.message = 'Incorrect password',
    super.code = 'wrong-password',
  });
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({
    super.message = 'Email not registered',
    super.code = 'user-not-found',
  });
}
