class AuthState {
  final bool isAuthenticated;
  final String? token;

  AuthState({required this.isAuthenticated, this.token});

  factory AuthState.unknown() => AuthState(isAuthenticated: false);

  factory AuthState.authenticated(String token) =>
      AuthState(isAuthenticated: true, token: token);

  factory AuthState.unauthenticated() => AuthState(isAuthenticated: false);
}
