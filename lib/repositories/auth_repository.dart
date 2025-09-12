import 'package:web/web.dart' as web;
import '../utils/storage.dart';

class AuthRepository {
  final String backendBase;

  AuthRepository({required this.backendBase});

  String get loginUrl => '$backendBase/auth/login';

  String? captureTokenFromUrlAndPersist() {
    final params = Uri.parse(web.window.location.href).queryParameters;
    final token = params['token'];
    if (token != null && token.isNotEmpty) {
      Storage.writeToken(token);

      // Remove ?token=... from URL
      final cleanUri = Uri(
        scheme: web.window.location.protocol.replaceAll(':', ''),
        host: web.window.location.hostname,
        port: int.tryParse(web.window.location.port),
        path: web.window.location.pathname,
      );
      web.window.history.replaceState(null, '', cleanUri.toString());
      return token;
    }
    return null;
  }

  String? currentToken() => Storage.readToken();

  void logout() => Storage.removeToken();
}
