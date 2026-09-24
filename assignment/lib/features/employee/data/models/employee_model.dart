import '../../domain/entities/employee_entity.dart';

/// Data model for Employee representing the mockapi.io JSON contract.
class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.name,
    required super.email,
    required super.mobile,
    required super.country,
    required super.state,
    required super.district,
    required super.avatar,
    required super.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? json['emailId']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'emailId': email,
      'mobile': mobile,
      'country': country,
      'state': state,
      'district': district,
      'avatar': avatar,
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    if (createdAt.isNotEmpty) {
      map['createdAt'] = createdAt;
    }
    return map;
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      mobile: entity.mobile,
      country: entity.country,
      state: entity.state,
      district: entity.district,
      avatar: entity.avatar,
      createdAt: entity.createdAt,
    );
  }

  EmployeeEntity toEntity() => this;
}
