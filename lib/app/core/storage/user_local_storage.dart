import 'package:hive_flutter/hive_flutter.dart';

class UserLocalStorage {
  final Box _box;

  UserLocalStorage(this._box);

  static const String _kHasSeenOnboarding = 'hasSeenOnboarding';
  static const String _kLastUsedUsername = 'lastUsedUsername';

  bool get hasSeenOnboarding {
    return _box.get(_kHasSeenOnboarding, defaultValue: false) as bool;
  }

  Future<void> markOnboardingAsSeen() async {
    await _box.put(_kHasSeenOnboarding, true);
  }

  String? get lastUsedUsername {
    return _box.get(_kLastUsedUsername) as String?;
  }

  Future<void> saveUsername(String username) async {
    await _box.put(_kLastUsedUsername, username);
  }

  Future<void> saveCredentials(String username, String email) async {
    await _box.put(_kLastUsedUsername, username);
    // You might want to save the email as well, for example:
    // await _box.put('lastUsedEmail', email);
  }

  Future<void> clearCredentials() async {
    await _box.delete(_kLastUsedUsername);
  }

// lib/app/core/providers/user_local_storage_provider.dart

  Future<void> clearTokens() async {
    final box = await Hive.openBox('authData');
    await box.delete('accessToken');
    await box.delete('refreshToken');
  }

  Future<String?> getRefreshToken() async {
    return _box.get('refreshToken') as String?;
  }

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _box.put('accessToken', accessToken);
    await _box.put('refreshToken', refreshToken);
  }


}
