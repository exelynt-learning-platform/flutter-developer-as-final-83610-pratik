class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1';

  static const String countryEndpoint = '/country';
  static const String employeeEndpoint = '/employee';

  static String employeeByIdEndpoint(String id) => '/employee/$id';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
