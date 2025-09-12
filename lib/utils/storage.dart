import 'package:web/web.dart' as web;

class Storage {
  static const _tokenKey = 'access_token';

  static String? readToken() {
    return web.window.localStorage.getItem(_tokenKey);
  }

  static void writeToken(String token) {
    web.window.localStorage.setItem(_tokenKey, token);
  }

  static void removeToken() {
    web.window.localStorage.removeItem(_tokenKey);
  }
}
