import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hillcrest_finance/features/authentication/presentation/screens/splash_screen.dart';
import 'package:hillcrest_finance/features/authentication/presentation/screens/welcome_onboarding_screen.dart';
import 'package:hillcrest_finance/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:hillcrest_finance/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:hillcrest_finance/features/authentication/presentation/screens/verification_screens/email_verification_screen.dart';
import 'package:hillcrest_finance/features/authentication/presentation/screens/verification_screens/phone_verification_screen.dart';
import 'package:hillcrest_finance/features/dashboard/presentation/screens/dashboard_screen.dart';

// This will be generated
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // Splash screen as initial route
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
      path: '/',
    ),

    // Welcome/Onboarding screen
    AutoRoute(
      page: WelcomeOnboardingRoute.page,
      path: '/onboarding',
    ),

    // Sign In screen
    AutoRoute(
      page: SignInRoute.page,
      path: '/sign-in',
    ),

    // Sign Up screen
    AutoRoute(
      page: SignUpRoute.page,
      path: '/sign-up',
    ),

    // Email Verification screen 🚀
    AutoRoute(
      page: EmailVerificationRoute.page,
      path: '/verify-email',
    ),

    // Phone Verification screen 🚀
    AutoRoute(
      page: PhoneVerificationRoute.page,
      path: '/verify-phone',
    ),

    // Dashboard screen
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
    ),
  ];
}