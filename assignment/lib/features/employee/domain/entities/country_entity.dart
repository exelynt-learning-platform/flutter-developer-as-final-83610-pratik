import 'package:equatable/equatable.dart';

/// Clean domain entity representing a Country with flag.
class CountryEntity extends Equatable {
  final String id;
  final String country;
  final String flag;
  final String createdAt;

  const CountryEntity({
    required this.id,
    required this.country,
    required this.flag,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, country, flag, createdAt];
}
