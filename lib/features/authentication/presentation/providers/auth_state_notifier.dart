import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hillcrest_finance/app/core/exceptions/network_exceptions.dart';
import 'package:hillcrest_finance/app/core/providers/networking_provider.dart';
import 'package:hillcrest_finance/app/core/providers/user_local_storage_provider.dart';
import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';
import 'auth_state.dart';

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Use the factory constructor for a clean initial state.
    return AuthState.initial();
  }

  // checkInitialStatus remains unchanged as per the request.
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

      // On successful login, pass username to the handler
      await _onLoginSuccess(tokenResponse, username);

    } on NetworkException {
      setLoading(false);
      rethrow;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  // In auth_state_notifier.dart

  Future<void> _onLoginSuccess(TokenResponse tokenResponse, String username) async {
    final localStorage = ref.read(userLocalStorageProvider);

    // Fetch both customerNo status AND accountType in one call
    Map<String, dynamic> onboardingStatus;
    try {
      onboardingStatus = await ref.read(authRepositoryProvider).getUserOnboardingStatus(username);
      // Update cache
      await localStorage.setHasCustomerNo(onboardingStatus['hasCustomerNo'] as bool);
      // You might want to cache accountType too if needed
    } catch (e) {
      print("[AUTH] Failed to check onboarding status: $e");
      // Fallback to cached values
      onboardingStatus = {
        'hasCustomerNo': localStorage.hasCustomerNo ?? false,
        'accountType': null,
      };
    }

    // Update state with fresh data
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      token: tokenResponse,
      hasCustomerNo: onboardingStatus['hasCustomerNo'] as bool,
      accountType: onboardingStatus['accountType'] as String?, // ADDED
    );
  }

  /// Optional: Keep for periodic background checks if needed
  Future<void> _refreshCustomerNoStatus(bool cachedStatus, String username) async {
    try {
      final freshStatus = await ref.read(authRepositoryProvider).checkForCustomerNo(username);

      if (cachedStatus != freshStatus) {
        await ref.read(userLocalStorageProvider).setHasCustomerNo(freshStatus);
        state = state.copyWith(hasCustomerNo: freshStatus);
      }
    } catch (e) {
      print("[AUTH] Background customer number check failed: $e");
    }
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {
      // Ignore errors on logout
    }
    // Clear local data and reset state
    await ref.read(userLocalStorageProvider).setHasCustomerNo(false);
    state = AuthState.initial();
  }
}
