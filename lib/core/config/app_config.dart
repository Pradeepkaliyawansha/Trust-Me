/// Environment configuration injected at build time:
///   flutter run --dart-define-from-file=config/dev.json
class AppConfig {
  const AppConfig._();

  static const String env =
      String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api/v1', // Android emulator -> host
  );
  static const bool enableLogging =
      String.fromEnvironment('ENABLE_LOGGING', defaultValue: 'false') ==
          'true';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static bool get isProd => env == 'prod';
}
