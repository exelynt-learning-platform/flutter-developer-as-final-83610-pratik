import 'package:assignment/features/employee/data/models/country_model.dart';
import 'package:assignment/features/employee/domain/entities/country_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tCountryModel = CountryModel(
    id: '1',
    country: 'Aruba',
    flag: 'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/303.jpg',
    createdAt: '2024-07-19T05:14:59.127Z',
  );

  test('CountryModel is a subclass of CountryEntity', () {
    expect(tCountryModel, isA<CountryEntity>());
  });

  group('fromJson', () {
    test('should return a valid model from mockapi country JSON', () {
      final jsonMap = {
        'id': '1',
        'country': 'Aruba',
        'flag': 'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/303.jpg',
        'createdAt': '2024-07-19T05:14:59.127Z',
      };

      final result = CountryModel.fromJson(jsonMap);

      expect(result.id, '1');
      expect(result.country, 'Aruba');
      expect(result.flag, isNotEmpty);
      expect(result.createdAt, '2024-07-19T05:14:59.127Z');
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tCountryModel.toJson();

      expect(result['id'], '1');
      expect(result['country'], 'Aruba');
      expect(result['flag'], isNotEmpty);
      expect(result['createdAt'], '2024-07-19T05:14:59.127Z');
    });
  });

  group('fromEntity and toEntity', () {
    test('should convert accurately between Model and Entity', () {
      final fromEntity = CountryModel.fromEntity(tCountryModel);
      expect(fromEntity, tCountryModel);

      final toEntity = tCountryModel.toEntity();
      expect(toEntity, isA<CountryEntity>());
      expect(toEntity.country, 'Aruba');
    });
  });
}
