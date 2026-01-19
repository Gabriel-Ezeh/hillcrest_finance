import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hillcrest_finance/app/core/exceptions/network_exceptions.dart';
import 'package:hillcrest_finance/app/core/providers/networking_provider.dart';
import 'package:hillcrest_finance/app/core/providers/user_local_storage_provider.dart';
import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';
import 'auth_state.dart';

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(
      isAuthenticated: false,
      accessToken: null,
      isLoading: false,
    );
  }

  Future<void> checkInitialStatus() async {
    try {
      final storage = ref.read(userLocalStorageProvider);
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        state = state.copyWith(isAuthenticated: false);
        return;
      }

      // Attempt to refresh the token
      final newTokenResponse = await ref.read(authRepositoryProvider).refreshAccessToken(refreshToken);

      // If successful, update storage and state
      await storage.saveTokens(
        accessToken: newTokenResponse.accessToken,
        refreshToken: newTokenResponse.refreshToken ?? refreshToken,
      );

      state = state.copyWith(
        isAuthenticated: true,
        accessToken: newTokenResponse.accessToken,
      );
    } on NetworkException catch (e) {
      // Token refresh failed - clear stored tokens and require re-login
      print("[AUTH] Token refresh failed: ${e.message}");
      await ref.read(userLocalStorageProvider).clearTokens();
      state = state.copyWith(isAuthenticated: false);
    } catch (e) {
      print("[AUTH] Unexpected error during initialization: $e");
      await ref.read(userLocalStorageProvider).clearTokens();
      state = state.copyWith(isAuthenticated: false);
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
