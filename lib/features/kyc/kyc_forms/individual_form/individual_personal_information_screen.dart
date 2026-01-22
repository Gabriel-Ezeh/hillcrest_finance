import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

// --- Custom Imports ---
import '../../../../app/core/exceptions/network_exceptions.dart';
import '../../../../app/core/providers/networking_provider.dart';
import '../../../../app/core/providers/notification_service_provider.dart';
import '../../../../app/core/router/app_router.dart';
import '../../../../ui/widgets/app_button.dart';
import '../../../../ui/widgets/forms/app_textfields.dart';
import '../../../../utils/constants/values.dart';

@RoutePage()
class IndividualPersonalInformationScreen extends ConsumerStatefulWidget {
  const IndividualPersonalInformationScreen({super.key});

  @override
  ConsumerState<IndividualPersonalInformationScreen> createState() => _IndividualPersonalInformationScreenState();
}

class _IndividualPersonalInformationScreenState extends ConsumerState<IndividualPersonalInformationScreen> {
  // --- Controllers ---
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --- State ---
  bool _isLoading = false;
  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedCountry;
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed'];
  final List<String> _countries = ['Nigeria', 'Ghana', 'Kenya', 'South Africa', 'Other'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bvnController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedGender == null) {
      ref.read(notificationServiceProvider).showError('Please select a gender.');
      return;
    }
    if (_selectedMaritalStatus == null) {
      ref.read(notificationServiceProvider).showError('Please select marital status.');
      return;
    }
    if (_selectedCountry == null) {
      ref.read(notificationServiceProvider).showError('Please select a country.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement your personal information save logic here
      // Save the form data to your backend or local storage

      // Navigate to KYC document upload page
      if (mounted) {
        context.router.pushNamed('/kyc/upload-documents');
      }
    } on NetworkException catch (e) {
      ref.read(notificationServiceProvider).showError(e.message);
    } catch (e) {
      ref.read(notificationServiceProvider).showError('An unexpected error occurred.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.darkBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkBlue),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SpaceW4(),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SpaceH24(),
                Text('Personal Information', style: AppTextStyles.cabinBold24DarkBlue),
                const SpaceH24(),

                // First Name
                AppTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hintText: 'First Name',
                  type: AppTextFieldType.text,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.mutedGray, size: Sizes.ICON_SIZE_20),
                ),
                const SpaceH16(),

                // Middle Name
                AppTextField(
                  controller: _middleNameController,
                  label: 'Middle Name',
                  hintText: 'Middle Name',
                  type: AppTextFieldType.text,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.mutedGray, size: Sizes.ICON_SIZE_20),

                ),
                const SpaceH16(),

                // Last Name
                AppTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  hintText: 'Last Name',
                  type: AppTextFieldType.text,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.mutedGray, size: Sizes.ICON_SIZE_20),
                ),
                const SpaceH16(),

                // Gender
                AppTextField(
                  label: 'Gender',
                  hintText: 'Choose',
                  type: AppTextFieldType.dropdown,
                  dropdownItems: _genders,
                  onDropdownChanged: (value) => setState(() => _selectedGender = value),
                  initialDropdownValue: _selectedGender,
                ),
                const SpaceH16(),

                // Date of Birth
                AppTextField(
                  controller: _dateOfBirthController,
                  label: 'Date of Birth',
                  hintText: 'dd/MM/yyyy',
                  type: AppTextFieldType.text,
                  prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.mutedGray, size: Sizes.ICON_SIZE_18),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SpaceH16(),

                // Marital Status
                AppTextField(
                  label: 'Marital Status',
                  hintText: 'Choose',
                  type: AppTextFieldType.dropdown,
                  dropdownItems: _maritalStatuses,
                  onDropdownChanged: (value) => setState(() => _selectedMaritalStatus = value),
                  initialDropdownValue: _selectedMaritalStatus,
                ),
                const SpaceH16(),

                // Phone Number
                AppTextField(
                  controller: _phoneController,
                  label: 'Phone number',
                  hintText: '915 4567 562',
                  type: AppTextFieldType.phone,
                  prefix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('+234', style: AppTextStyles.interRegular14DarkBlue),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.mutedGray, size: Sizes.ICON_SIZE_18),
                      const SpaceW8(),
                      Container(width: 1, height: Sizes.ICON_SIZE_20, color: AppColors.lightGray),
                      const SpaceW8(),
                    ],
                  ),
                ),
                const SpaceH16(),

                // Email Address
                AppTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hintText: 'chineduokafor@gmail.com',
                  type: AppTextFieldType.email,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.mutedGray, size: Sizes.ICON_SIZE_20),
                ),
                const SpaceH16(),

                // BVN
                AppTextField(
                  controller: _bvnController,
                  label: 'BVN',
                  hintText: 'BVN',
                  type: AppTextFieldType.text,
                  keyboardType: TextInputType.number,
                ),
                const SpaceH16(),

                // Address
                AppTextField(
                  controller: _addressController,
                  label: 'Address',
                  hintText: 'Address',
                  type: AppTextFieldType.text,
                ),
                const SpaceH16(),

                // City
                AppTextField(
                  controller: _cityController,
                  label: 'City',
                  hintText: 'City',
                  type: AppTextFieldType.text,
                ),
                const SpaceH16(),

                // State
                AppTextField(
                  controller: _stateController,
                  label: 'State',
                  hintText: 'State',
                  type: AppTextFieldType.text,
                ),
                const SpaceH16(),

                // Country
                AppTextField(
                  label: 'Country',
                  hintText: 'Choose',
                  type: AppTextFieldType.dropdown,
                  dropdownItems: _countries,
                  onDropdownChanged: (value) => setState(() => _selectedCountry = value),
                  initialDropdownValue: _selectedCountry,
                ),
                const SpaceH32(),

                // Continue Button
                AppButton(
                  text: 'Continue',
                  onPressed: _onContinuePressed,
                  isLoading: _isLoading,
                ),
                const SpaceH48(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}