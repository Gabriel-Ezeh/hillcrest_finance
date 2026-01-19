import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';

class AuthState {
  final bool isAuthenticated;
  final String? accessToken;
  final bool isLoading;
  final TokenResponse? token;

  const AuthState({
    required this.isAuthenticated,
    this.accessToken,
    required this.isLoading,
    this.token,
  });

  factory AuthState.initial() => const AuthState(
    isAuthenticated: false,
    accessToken: null,
    isLoading: false,
    token: null,
  );

  AuthState copyWith({
    bool? isAuthenticated,
    String? accessToken,
    bool? isLoading,
    TokenResponse? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
    );
  }
}
