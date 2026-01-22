import 'package:hive_flutter/hive_flutter.dart';

class UserLocalStorage {
  final Box _box;

  UserLocalStorage(this._box);

  static const String _kHasSeenOnboarding = 'hasSeenOnboarding';
  static const String _kLastUsedUsername = 'lastUsedUsername';
  static const String _kHasCustomerNo = 'hasCustomerNo'; // ADDED

  // --- Onboarding Status ---
  bool get hasSeenOnboarding {
    return _box.get(_kHasSeenOnboarding, defaultValue: false) as bool;
  }

  Future<void> markOnboardingAsSeen() async {
    await _box.put(_kHasSeenOnboarding, true);
  }

  // --- Last Used Username ---
  String? get lastUsedUsername {
    return _box.get(_kLastUsedUsername) as String?;
  }

  Future<void> saveUsername(String username) async {
    await _box.put(_kLastUsedUsername, username);
  }

  // --- Customer Number Status --- // ADDED SECTION
  bool get hasCustomerNo {
    return _box.get(_kHasCustomerNo, defaultValue: false) as bool;
  }

  Future<void> setHasCustomerNo(bool hasNo) async {
    await _box.put(_kHasCustomerNo, hasNo);
  }

  // --- Deprecated/Old Methods ---

  Future<void> saveCredentials(String username, String email) async {
    await _box.put(_kLastUsedUsername, username);
  }

  Future<void> clearCredentials() async {
    await _box.delete(_kLastUsedUsername);
  }

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
