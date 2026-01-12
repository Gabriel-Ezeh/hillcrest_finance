import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state_notifier.dart';
import 'auth_state.dart';

final authStateProvider =
NotifierProvider<AuthStateNotifier, AuthState>(
  AuthStateNotifier.new,
);
