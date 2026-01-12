import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final TokenResponse? token;

  const AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.token,
  });

  factory AuthState.initial() => const AuthState(
    isAuthenticated: false,
    isLoading: false,
    token: null,
  );

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    TokenResponse? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
    );
  }
}
