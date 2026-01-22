import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hillcrest_finance/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:hillcrest_finance/features/dashboard/presentation/screens/onboarding_completion_modal.dart';
import 'package:hillcrest_finance/features/kyc/kyc_forms/individual_form/individual_personal_information_screen.dart';
import 'package:hillcrest_finance/utils/constants/values.dart';

@RoutePage()
class DashboardScreen extends ConsumerStatefulWidget { // MODIFIED: Converted to stateful
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to safely show a dialog after the screen has finished building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOnboardingStatusAndShowModal();
    });
  }

  // In dashboard_screen.dart

  void _checkOnboardingStatusAndShowModal() {
    if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) {
      return;
    }

    final authState = ref.read(authStateProvider);

    if (authState.isAuthenticated && authState.hasCustomerNo != true) {
      final accountType = authState.accountType ?? 'Individual'; // Default fallback

      showOnboardingCompletionModal(
        context,
        accountType: accountType, // Pass the account type
        onContinue: () {
          Navigator.of(context).pop();
          _navigateToKYCFlow(accountType);
        },
      );
    }
  }

  void _navigateToKYCFlow(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'individual':
      // Navigate to personal info form
        context.router.pushNamed('/kyc/personal-info');
        break;
      // case 'corporate':
      // // Navigate to corporate info form
      //   context.router.push(const CorporateInfoRoute());
      //   break;
      // case 'sme':
      // // Navigate to SME info form
      //   context.router.push(const SMEInfoRoute());
      //   break;
      default:
        print('Unknown account type: $accountType');
        // Fallback to individual
        context.router.pushNamed('/kyc/personal-info');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This listener ensures that if the user's status is updated by the background
    // check while they are on the dashboard, the modal will still appear.
    ref.listen(authStateProvider.select((state) => state.hasCustomerNo), (previous, next) {
      // FIXED: Check for both false AND null
      if (ref.read(authStateProvider).isAuthenticated && next != true) {
        _checkOnboardingStatusAndShowModal();
      }
    });



    // --- YOUR EXISTING UI CODE STARTS HERE (UNCHANGED) ---
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Top Navigation Bar ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConst.home,
                      style: AppTextStyles.cabinBold24DarkBlue,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.logout), // Example Logout
                          onPressed: () => ref.read(authStateProvider.notifier).logout(),
                        ),
                        const SpaceW16(),
                        const CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage(ImagePath.userPlaceholder),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // --- 2. Welcome Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${StringConst.welcomeUser}John,",
                      style: AppTextStyles.cabinBold24DarkBlue.copyWith(fontSize: 22),
                    ),
                    const SpaceH4(),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        StringConst.editProfile,
                        style: AppTextStyles.cabinRegular14Primary.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SpaceH24(),

              // --- 3. Total Balance Card (Refactored with Custom Painter) ---
              _buildBalanceCard(),

              const SpaceH32(),

              // --- 4. Quick Actions ---
              _buildSectionHeader(StringConst.quickActions),
              const SpaceH16(),
              _buildQuickActions(),

              const SpaceH32(),

              // --- 5. Recent Transactions ---
              _buildSectionHeader(StringConst.recentTransactions, showSeeAll: true),
              _buildTransactionList(),

              const SpaceH24(),
            ],
          ),
        ),
      ),
    );
  }

  // --- YOUR EXISTING UI HELPER WIDGETS (UNCHANGED) ---

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24),
      height: 190,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(Sizes.RADIUS_16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.RADIUS_16),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: CardPatternPainter(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.PADDING_24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConst.totalBalance,
                    style: AppTextStyles.cabinRegular14White.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SpaceH8(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₦ 1,250,000.00",
                        style: AppTextStyles.cabinRegular14White.copyWith(fontSize: 28),
                      ),
                      const Icon(Icons.visibility_off_outlined, color: Colors.white, size: 20),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _buildCardButton(StringConst.send, Icons.send_rounded),
                      const SpaceW12(),
                      _buildCardButton(StringConst.topUp, Icons.add_box_outlined),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Sizes.RADIUS_8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SpaceW8(),
          Text(label, style: AppTextStyles.cabinRegular14White),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showSeeAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.cabinBold24DarkBlue),
          if (showSeeAll)
            Text(StringConst.viewAll, style: AppTextStyles.cabinRegular14Primary),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'name': StringConst.airtime, 'icon': Icons.phone_android, 'color': Colors.orange},
      {'name': StringConst.data, 'icon': Icons.wifi_tethering, 'color': Colors.blue},
      {'name': StringConst.bills, 'icon': Icons.lightbulb_outline, 'color': Colors.amber},
      {'name': StringConst.more, 'icon': Icons.more_horiz, 'color': Colors.grey},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((item) {
          return Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: (item['color'] as Color).withOpacity(0.1),
                child: Icon(item['icon'] as IconData, color: item['color'] as Color),
              ),
              const SpaceH8(),
              Text(item['name'] as String, style: AppTextStyles.cabinRegular14MutedGray),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24, vertical: 8),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(Sizes.RADIUS_12),
            border: Border.all(color: AppColors.lightGray.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.lightGray,
                child: Icon(Icons.swap_horiz, color: AppColors.darkBlue),
              ),
              const SpaceW12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Transfer to Sarah", style: AppTextStyles.cabinBold24DarkBlue),
                    Text("Today, 10:45 AM", style: AppTextStyles.cabinRegular14MutedGray),
                  ],
                ),
              ),
              Text("-₦2,500.00", style: AppTextStyles.cabinBold24DarkBlue.copyWith(color: Colors.red)),
            ],
          ),
        );
      },
    );
  }
}

class CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(size.width * 0.4, 0);
    path1.quadraticBezierTo(size.width * 0.6, size.height * 0.4, size.width, size.height * 0.2);
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.5, size.height);
    path2.quadraticBezierTo(size.width * 0.8, size.height * 0.3, size.width * 1.2, size.height * 0.7);
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint);

    final path3 = Path();
    path3.moveTo(0, size.height * 0.7);
    path3.quadraticBezierTo(size.width * 0.3, size.height * 0.9, size.width * 0.2, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
