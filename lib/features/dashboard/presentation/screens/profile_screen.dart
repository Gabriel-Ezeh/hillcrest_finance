import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hillcrest_finance/app/core/router/app_router.dart';
import 'package:hillcrest_finance/features/authentication/presentation/providers/auth_state_provider.dart';

import 'package:hillcrest_finance/utils/constants/values.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24, vertical: 16),
              child: Text(
                StringConst.profile,
                style: AppTextStyles.cabinBold24DarkBlue,
              ),
            ),

            const SpaceH16(),

            // --- 2. Menu List ---
            _buildMenuItem(
              icon: Icons.person_outline_rounded,
              title: StringConst.myAccount,
              onTap: () {
                // Navigate to account details if needed
              },
            ),

            _buildMenuItem(
              icon: Icons.logout_rounded,
              title: StringConst.logout,
              isDestructive: true,
              onTap: () {
                // 1. Tell our provider the user is now logged out.
                ref.read(authStateProvider.notifier).logout();

                // 2. Navigate back to the sign-in screen, clearing the history.
                context.router.replaceAll([const SignInRoute()]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppColors.darkBlue;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: AppTextStyles.cabinBold24DarkBlue.copyWith(color: color),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color.withOpacity(0.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24, vertical: 4),
    );
  }
}