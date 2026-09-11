/// Every error the data layer can throw.
class AppException implements Exception {
  const AppException(this.message, {this.type = AppErrorType.unknown});

  final String message;
  final AppErrorType type;

  @override
  String toString() => message;

  factory AppException.noInternet() => const AppException(
    'No internet connection. Please check your network.',
    type: AppErrorType.noInternet,
  );

  factory AppException.timeout() => const AppException(
    'The request timed out. Please try again.',
    type: AppErrorType.timeout,
  );

  factory AppException.invalidResponse() => const AppException(
    'Received an unexpected response from the server.',
    type: AppErrorType.invalidResponse,
  );

  factory AppException.unauthorized() => const AppException(
    'Invalid email or password.',
    type: AppErrorType.unauthorized,
  );

  factory AppException.server(String message) =>
      AppException(message, type: AppErrorType.server);
}

enum AppErrorType {
  noInternet,
  timeout,
  invalidResponse,
  unauthorized,
  server,
  unknown,
}
