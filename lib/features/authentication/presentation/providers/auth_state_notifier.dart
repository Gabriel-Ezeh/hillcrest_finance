import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hillcrest_finance/app/core/exceptions/network_exceptions.dart';
import 'package:hillcrest_finance/app/core/providers/networking_provider.dart';
import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';
import 'auth_state.dart';

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState.initial();
  }

  Future<void> checkInitialStatus() async {
    setLoading(true);
    try {
      final authRepo = ref.read(authRepositoryProvider) as dynamic;
      final isSignedIn = await authRepo.isSignedIn();
      if (isSignedIn) {
        final refreshed = await authRepo.refreshToken();
        if (refreshed != null) {
          _onLoginSuccess(refreshed);
        } else {
          state = AuthState.initial();
        }
      } else {
        state = AuthState.initial();
      }
    } catch (e) {
      state = AuthState.initial();
    } finally {
      setLoading(false);
    }
  }

  Future<void> login(String username, String password) async {
    setLoading(true);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final tokenResponse = await authRepo.login(username, password);
      _onLoginSuccess(tokenResponse);
    } on NetworkException {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void _onLoginSuccess(TokenResponse tokenResponse) {
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      token: tokenResponse,
    );
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<void> logout() async {
    try {
      await (ref.read(authRepositoryProvider) as dynamic).logout();
    } catch (_) {
      // Ignore errors, just clear local state
    }
    state = AuthState.initial();
  }


}
