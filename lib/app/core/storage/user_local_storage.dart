import 'package:hive_flutter/hive_flutter.dart';

/// A service class for managing user-related data in local storage (Hive).
///
/// This class encapsulates all the logic for reading and writing user preferences,
/// providing a clean and testable API for the rest of the application.
class UserLocalStorage {
  final Box _box;

  UserLocalStorage(this._box);

  // --- Storage Keys ---
  static const String _kHasSeenOnboarding = 'hasSeenOnboarding';
  static const String _kLastUsedUsername = 'lastUsedUsername';

  // --- Onboarding Status ---

  /// Checks if the user has completed the onboarding flow.
  bool get hasSeenOnboarding {
    return _box.get(_kHasSeenOnboarding, defaultValue: false) as bool;
  }

  /// Marks the onboarding flow as completed.
  Future<void> markOnboardingAsSeen() async {
    await _box.put(_kHasSeenOnboarding, true);
  }

  // --- Last Used Username ---

  /// Gets the last successfully used username.
  String? get lastUsedUsername {
    return _box.get(_kLastUsedUsername) as String?;
  }

  /// Saves the username after a successful login.
  Future<void> saveUsername(String username) async {
    await _box.put(_kLastUsedUsername, username);
  }

  // --- Future features can be added below ---
  // Example: Theme Preference
  // String get themePreference => _box.get('theme', defaultValue: 'system');
  // Future<void> saveThemePreference(String theme) async => await _box.put('theme', theme);
}
