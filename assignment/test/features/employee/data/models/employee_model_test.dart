import 'package:assignment/features/employee/data/models/employee_model.dart';
import 'package:assignment/features/employee/domain/entities/employee_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tEmployeeModel = EmployeeModel(
    id: '12',
    name: 'Prapti',
    email: 'prapti@gmail.com',
    mobile: '9985744152',
    country: 'india',
    state: 'MAHARASHTRA',
    district: 'Solapur',
    avatar: 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/98.jpg',
    createdAt: '2026-09-11T17:22:12.472Z',
  );

  test('EmployeeModel is a subclass of EmployeeEntity', () {
    expect(tEmployeeModel, isA<EmployeeEntity>());
  });

  group('fromJson', () {
    test('should return a valid model from full mockapi JSON map', () {
      final jsonMap = {
        'id': '12',
        'name': 'Prapti',
        'email': 'prapti@gmail.com',
        'emailId': 'Katlyn_McDermott9@gmail.com',
        'mobile': '9985744152',
        'country': 'india',
        'state': 'MAHARASHTRA',
        'district': 'Solapur',
        'avatar':
            'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/98.jpg',
        'createdAt': '2026-09-11T17:22:12.472Z',
      };

      final result = EmployeeModel.fromJson(jsonMap);

      expect(result.id, '12');
      expect(result.name, 'Prapti');
      expect(result.email, 'prapti@gmail.com');
      expect(result.mobile, '9985744152');
      expect(result.country, 'india');
      expect(result.state, 'MAHARASHTRA');
      expect(result.district, 'Solapur');
      expect(result.createdAt, '2026-09-11T17:22:12.472Z');
    });

    test('should fallback to emailId when email is absent', () {
      final jsonMap = {
        'id': '15',
        'name': 'Shiva Shakti',
        'emailId': 'Alvis40@hotmail.com',
        'mobile': '9822963908',
        'country': 'india',
        'state': 'Gujarat',
        'district': 'PN',
        'avatar': '',
        'createdAt': '2026-09-12T05:55:22.763Z',
      };

      final result = EmployeeModel.fromJson(jsonMap);

      expect(result.email, 'Alvis40@hotmail.com');
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tEmployeeModel.toJson();

      expect(result['id'], '12');
      expect(result['name'], 'Prapti');
      expect(result['email'], 'prapti@gmail.com');
      expect(result['emailId'], 'prapti@gmail.com');
      expect(result['mobile'], '9985744152');
      expect(result['country'], 'india');
      expect(result['state'], 'MAHARASHTRA');
      expect(result['district'], 'Solapur');
    });
  });

  group('fromEntity and toEntity', () {
    test('should convert accurately to and from EmployeeEntity', () {
      final fromEntity = EmployeeModel.fromEntity(tEmployeeModel);
      expect(fromEntity, tEmployeeModel);

      final toEntity = tEmployeeModel.toEntity();
      expect(toEntity, isA<EmployeeEntity>());
      expect(toEntity.id, tEmployeeModel.id);
    });
  });
}
