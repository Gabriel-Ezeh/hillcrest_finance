part of 'values.dart';

class StringConst {
  // First Onboarding Screen
  static const String firstOnboardingTitle = 'Grow Your Wealth with\nConfidence';
  static const String firstOnboardingDescription =
      'Access trusted investment solutions designed\naround your goals. Start your journey to financial\nfreedom today.';

  // Second Onboarding Screen
  static const String secondOnboardingTitle = 'Your Financial Partner for \nLife';
  static const String secondOnboardingDescription =
      'From savings to structured investments, Hillcrest\nhelps you reach your goals with ease and confidence.';

  // Third Onboarding Screen
  static const String thirdOnboardingTitle = 'Invest Smart, Grow Steady';
  static const String thirdOnboardingDescription =
      'With Hillcrest, you can save, invest, and track your\ngrowth — all in one place. Let’s build your future together.';

  // Welcome & Onboarding
  static const String welcome = 'Welcome!';
  static const String getStarted = 'Get Started';
  static const String getStartedSubtitle = 'Create your account to access \npersonalized services.';

  // --- Authentication - Sign In ---
  // Updated signInPrompt to signInSubtitle
  static const String signInSubtitle = 'Sign in to access your personal dashboard.';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'e.g chineduokafor@gmail.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String continueButton = 'Continue';
  static const String noAccountPrompt = 'Do not have an account? ';
  static const String createOne = 'Create one';
  static const String existingCustomerPrompt = 'Already a customer? ';
  static const String setUpOnlineProfile = 'Set up online profile';
  static const String login = 'Login';
  // New: Back to Sign In link text
  static const String backToSignIn = 'Back to Sign In';
  static const String myAccount = 'My Account';
  static const String logout = 'Logout';
  static const String profile = 'Profile';





  // --- Password Reset ---
  static const String passwordResetTitle = 'Password Reset';
  static const String passwordResetInstruction = 'Enter the email address associated to your HillCrest account';
  static const String enterCodeTitle = 'Enter Code';
  static const String codeSentMessage = 'A 6-Digit code has been sent to chineduok***@gmail.com. Enter code.';
  static const String resendCodePrompt = 'Didn’t receive any code? ';
  static const String resendAction = 'Resend';
  static const String createNewPassword = 'Create new Password';
  static const String passwordRequirements = 'Must be different from the old password and have at least 8 characters.';
  static const String passwordChangeSuccessTitle = 'Password Change Successful';
  static const String passwordChangeSuccessMessage = 'Your password has been successfully changed.';

  // --- Registration - Create Account ---
  static const String firstNameLabel = 'First Name';
  static const String firstNameHint = 'Chinedu';
  static const String lastNameLabel = 'Last Name';
  static const String lastNameHint = 'Okafor';
  static const String usernameLabel = 'Username';
  static const String usernameHint = 'chineduokafor';
  static const String phoneNumberLabel = 'Phone number';
  static const String countryCodeHint = '+234';
  static const String phoneNumberHint = '915 4567 562';
  static const String accountTypeLabel = 'Account Type';
  static const String accountTypeHint = 'Select your account type';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Enter your Password';
  static const String termsAgreement = 'I agree to the Terms & Conditions and Privacy Policy';
  static const String alreadyHaveAccountPrompt = 'Already have an account? ';
  static const String signIn = 'Sign in';

  // --- Verification - Email & Phone ---
  static const String emailVerificationSuccessTitle = 'Verification Successful';
  static const String emailVerificationSuccessMessage =
      'Your Email has been verified successfully. Kindly proceed to verifying your phone number';
  static const String verifyPhoneTitle = 'Verify Phone Number';
  static const String phoneCodeSentMessage = 'A 6-Digit code has been sent to your phone number. Enter code.';
  static const String phoneVerificationCompleteTitle = 'Verification Completed';
  static const String phoneVerificationCompleteMessage =
      'Your phone number has been verified successfully. Kindly proceed to your dashboard';
  static const String goToDashboard = 'Go to Dashboard';
  // New: OTP Email Subject/Template
  static const String otpEmailSubject = 'OTP Verification';
  static const String otpEmailMessageTemplate =
      'Good day,\n\nThis is your One-time password for your online profile creation with HillCrest Finance.\n\nPin: ';

  // --- Profile Setup ---
  static const String setProfileTitle = 'Set Profile';
  // Updated instruction to subtitle
  static const String setProfileSubtitle =
      'Set up your online profile with HillCrest account by providing the details';
  static const String accountNumberLabel = 'Account Number';
  static const String accountNumberHint = 'Enter account no';
  static const String profileEmailLabel = 'Email Address';
  static const String profileEmailHint = 'e.g chineduokafor@gmail.com';
  static const String createProfileButton = 'Create Profile';
  static const String profilePasswordRequirements =
      'Must be different from the old password and have at least 8 characters.';
  static const String profileCreatedTitle = 'Profile Created';
  static const String profileCreatedMessage =
      'Your online profile has been successfully created, kindly proceed to your dashboard';

  // --- New: Logic/Error Messages (from signup_active.dart logic) ---
  static const String accountExistsTitle = 'Account Exists';
  static const String accountExistsMessage = 'An account with this email already exists. Please reset your password.';
  static const String resetPasswordButton = 'Reset Password';
  static const String cancelButton = 'Cancel';
  static const String detailsMismatchError = 'Email or Phone Number does not match our records.';
  static const String customerDetailsNotFoundError = 'Customer details not found.';
  static const String genericFetchError = 'Something went wrong. Please try again.';

  // Add these to your existing StringConst class
  static const String verifyMail = "Verify Mail";
  static const String verifyMailSubtitle = "A 6-Digit code has been sent to ";
  static const String enterCode = ". Enter code.";
  static const String resendPrompt = "Didn’t receive any code? ";
  static const String resendLink = "Resend";
  // Add these to your StringConst class
  static const String registrationSuccess = "Registration Successful";
  static const String registrationSuccessSub = "Your email has been successfully verified. Please proceed to verify your phone number.";

  // Add these to your existing StringConst class
  static const String verifyPhone = "Verify Phone Number";
  static const String verifyPhoneSubtitle = "A 6-Digit code has been sent to ";
  static const String phoneRegistrationSuccess = "Verification Complete";
  static const String phoneRegistrationSuccessSub = "Your phone number has been successfully verified. Let's set up your profile.";
  // --- New: Personal Information Page ---
  static const String personalDetailsAppBarTitle = 'Personal Details';
  static const String personalInfoTitle = 'Personal Information';
  static const String personalInfoSubtitle =
      'Create an account by providing the details needed below.';
  static const String middleNameOptionalHint = 'Middle Name (Optional)';
  static const String dobPlaceholder = 'Date of Birth (DD/MM/YYYY)';
  static const String genderHint = 'Select your Gender';
  static const String kycDocumentUploadTitle = 'KYC Document Upload';
  static const String kycDocumentUploadSubtitle=
      'Upload a valid means of identification to proceed with your account setup.';

  static const String home = 'Home';
  static const String welcomeUser = 'Welcome,';
  static const String editProfile = 'Edit Profile';
  static const String totalBalance = 'Total Balance';
  static const String send = 'Send';
  static const String topUp = 'Top Up';
  static const String viewAll = 'View All';
  static const String airtime = 'Airtime';
  static const String data = 'Data';
  static const String bills = 'Bills';
  static const String more = 'More';
  static const String recentTransactions = 'Recent Transactions';
  static const String quickActions = 'Quick Actions';

  // Add these to your StringConst class (after the existing strings)

// --- Onboarding Completion Modal ---
  static const String welcomeOnboard = 'Welcome on board!';
  static const String finishSettingUpProfile = 'Finish setting up your profile.';
  static const String provideDetailsPrompt = 'Provide the following details to get the most of our services';
  static const String signUpCompleted = 'Sign up completed';
  static const String personalInformation = 'Personal information';
  static const String kycDocumentUpload = 'KYC Document Upload';
  static const String continueOnboarding = 'Continue Onboarding';

}