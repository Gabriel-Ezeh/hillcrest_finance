import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';



class AuthState {
  final bool isAuthenticated;
  final String? accessToken;
  final bool isLoading;
  final TokenResponse? token;
  final bool? hasCustomerNo;
  final String? accountType; // ADDED

  const AuthState({
    required this.isAuthenticated,
    this.accessToken,
    required this.isLoading,
    this.token,
    this.hasCustomerNo,
    this.accountType, // ADDED
  });

  factory AuthState.initial() => const AuthState(
    isAuthenticated: false,
    accessToken: null,
    isLoading: false,
    token: null,
    hasCustomerNo: null,
    accountType: null, // ADDED
  );

  AuthState copyWith({
    bool? isAuthenticated,
    String? accessToken,
    bool? isLoading,
    TokenResponse? token,
    bool? hasCustomerNo,
    String? accountType, // ADDED
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      hasCustomerNo: hasCustomerNo ?? this.hasCustomerNo,
      accountType: accountType ?? this.accountType, // ADDED
    );
  }
}