abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginCallbackReceived extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
