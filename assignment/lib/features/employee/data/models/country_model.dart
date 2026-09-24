import '../../domain/entities/country_entity.dart';

/// Data model for Country matching the mockapi.io JSON contract.
class CountryModel extends CountryEntity {
  const CountryModel({
    required super.id,
    required super.country,
    required super.flag,
    required super.createdAt,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      flag: json['flag']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'flag': flag,
      'createdAt': createdAt,
    };
  }

  factory CountryModel.fromEntity(CountryEntity entity) {
    return CountryModel(
      id: entity.id,
      country: entity.country,
      flag: entity.flag,
      createdAt: entity.createdAt,
    );
  }

  CountryEntity toEntity() => this;
}
