import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hillcrest_finance/app/core/router/app_router.dart';
import 'package:hillcrest_finance/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:hillcrest_finance/ui/widgets/app_button.dart';

@RoutePage()
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HillCrest Dashboard'),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back to the Dashboard!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "This screen is the landing page for an authenticated user.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: AppButton(
                text: 'Log Out',
                onPressed: () {
                  // 1. Tell our provider the user is now logged out.
                  ref.read(authStateProvider.notifier).logout();

                  // 2. Navigate back to the sign-in screen, clearing the history.
                  context.router.replaceAll([const SignInRoute()]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
