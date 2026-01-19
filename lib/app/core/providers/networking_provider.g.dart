// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'networking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secureStorage)
const secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  const SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'273dc403a965c1f24962aaf4d40776611a26f8b8';

@ProviderFor(authDio)
const authDioProvider = AuthDioProvider._();

final class AuthDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  const AuthDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return authDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$authDioHash() => r'916a242c81f6d51d2d4df21834cd8312c25eddb7';

@ProviderFor(onboardingDio)
const onboardingDioProvider = OnboardingDioProvider._();

final class OnboardingDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  const OnboardingDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingDioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return onboardingDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$onboardingDioHash() => r'f0247065dc49d9d83fa77b1d835527388393854d';

@ProviderFor(dio)
const dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  const DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'99ebb14f166663d0cbb9b4cb775ec9f686af4ab6';

@ProviderFor(authApiClient)
const authApiClientProvider = AuthApiClientProvider._();

final class AuthApiClientProvider
    extends $FunctionalProvider<AuthApiClient, AuthApiClient, AuthApiClient>
    with $Provider<AuthApiClient> {
  const AuthApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authApiClientHash();

  @$internal
  @override
  $ProviderElement<AuthApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthApiClient create(Ref ref) {
    return authApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthApiClient>(value),
    );
  }
}

String _$authApiClientHash() => r'dd67198831dfef73ff711d2d6c6b24eb745a73c1';

@ProviderFor(onboardingApiClient)
const onboardingApiClientProvider = OnboardingApiClientProvider._();

final class OnboardingApiClientProvider
    extends
        $FunctionalProvider<
          OnboardingApiClient,
          OnboardingApiClient,
          OnboardingApiClient
        >
    with $Provider<OnboardingApiClient> {
  const OnboardingApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingApiClientHash();

  @$internal
  @override
  $ProviderElement<OnboardingApiClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OnboardingApiClient create(Ref ref) {
    return onboardingApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingApiClient>(value),
    );
  }
}

String _$onboardingApiClientHash() =>
    r'c45899a5e16b5564f601f1d7d4fb258cd5a19526';

@ProviderFor(otpApiClient)
const otpApiClientProvider = OtpApiClientProvider._();

final class OtpApiClientProvider
    extends $FunctionalProvider<OtpApiClient, OtpApiClient, OtpApiClient>
    with $Provider<OtpApiClient> {
  const OtpApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpApiClientHash();

  @$internal
  @override
  $ProviderElement<OtpApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OtpApiClient create(Ref ref) {
    return otpApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtpApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtpApiClient>(value),
    );
  }
}

String _$otpApiClientHash() => r'294fc22ffef053f7322398d106137eb1788522a4';

@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  const AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'b2cf2a682e4cbf5b79250bf3d5d3a390558791b4';
