import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hillcrest_finance/app/core/router/app_router.dart';
import 'package:hillcrest_finance/ui/widgets/bottom_navbar.dart';

@RoutePage()
class MainWrapperScreen extends StatelessWidget {
  const MainWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        DashboardRoute(),
        DashboardRoute(), // Placeholder for Wallet
        DashboardRoute(), // Placeholder for Invest
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return AppBottomNav(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
        );
      },
    );
  }
}