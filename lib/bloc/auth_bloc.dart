import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc({required this.repo}) : super(AuthState.unknown()) {
    on<AppStarted>(_onAppStarted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    print('=== AUTH DEBUG: App started ===');
    final captured = repo.captureTokenFromUrlAndPersist();
    print('Captured token from URL: $captured');
    final token = captured ?? repo.currentToken();
    print('Final token to use: $token');
    
    if (token != null) {
      print('Emitting authenticated state');
      emit(AuthState.authenticated(token));
    } else {
      print('Emitting unauthenticated state');
      emit(AuthState.unauthenticated());
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    repo.logout();
    emit(AuthState.unauthenticated());
  }
}
