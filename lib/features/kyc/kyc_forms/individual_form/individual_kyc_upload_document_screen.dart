import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// --- Custom Imports ---
import '../../../../app/core/exceptions/network_exceptions.dart';
import '../../../../app/core/providers/notification_service_provider.dart';
import '../../../../app/core/router/app_router.dart';
import '../../../../ui/widgets/app_button.dart';
import '../../../../utils/constants/values.dart';

@RoutePage()
class IndividualKycDocumentUploadScreen extends ConsumerStatefulWidget {
  const IndividualKycDocumentUploadScreen({super.key});

  @override
  ConsumerState<IndividualKycDocumentUploadScreen> createState() => _IndividualKycDocumentUploadScreenState();
}

class _IndividualKycDocumentUploadScreenState extends ConsumerState<IndividualKycDocumentUploadScreen> {
  // --- State ---
  bool _isLoading = false;
  File? _photoLivenessCheck;
  File? _meansOfIdentification;
  File? _signature;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDocument(DocumentType type) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          switch (type) {
            case DocumentType.photoLiveness:
              _photoLivenessCheck = File(image.path);
              break;
            case DocumentType.identification:
              _meansOfIdentification = File(image.path);
              break;
            case DocumentType.signature:
              _signature = File(image.path);
              break;
          }
        });
      }
    } catch (e) {
      ref.read(notificationServiceProvider).showError('Failed to pick document. Please try again.');
    }
  }

  Future<void> _takePhoto(DocumentType type) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          switch (type) {
            case DocumentType.photoLiveness:
              _photoLivenessCheck = File(photo.path);
              break;
            case DocumentType.identification:
              _meansOfIdentification = File(photo.path);
              break;
            case DocumentType.signature:
              _signature = File(photo.path);
              break;
          }
        });
      }
    } catch (e) {
      ref.read(notificationServiceProvider).showError('Failed to take photo. Please try again.');
    }
  }

  void _showUploadOptions(DocumentType type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(Sizes.PADDING_24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primaryColor),
              title: Text('Take Photo', style: AppTextStyles.cabinRegular14DarkBlue),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(type);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
              title: Text('Choose from Gallery', style: AppTextStyles.cabinRegular14DarkBlue),
              onTap: () {
                Navigator.pop(context);
                _pickDocument(type);
              },
            ),
            const SpaceH16(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: AppTextStyles.cabinRegular14Primary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmitPressed() async {
    if (_photoLivenessCheck == null) {
      ref.read(notificationServiceProvider).showError('Please upload photo for liveness check.');
      return;
    }
    if (_meansOfIdentification == null) {
      ref.read(notificationServiceProvider).showError('Please upload means of identification.');
      return;
    }
    if (_signature == null) {
      ref.read(notificationServiceProvider).showError('Please upload your signature.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement your document upload logic here
      // Upload _photoLivenessCheck, _meansOfIdentification, _signature to server

      await Future.delayed(const Duration(seconds: 2)); // Simulating upload

      if (mounted) {
        ref.read(notificationServiceProvider).showSuccess('Documents uploaded successfully!');
        // context.router.push(const NextRoute());
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
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SpaceW4(),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceH24(),
              Text('KYC Document Upload', style: AppTextStyles.cabinBold24DarkBlue),
              const SpaceH24(),

              // Photo - Liveness Check
              _DocumentUploadCard(
                icon: Icons.insert_drive_file_outlined,
                title: 'Photo',
                subtitle: _photoLivenessCheck != null ? 'Document uploaded' : 'Liveness Check',
                isUploaded: _photoLivenessCheck != null,
                onTap: () => _showUploadOptions(DocumentType.photoLiveness),
              ),
              const SpaceH16(),

              // Means of Identification
              _DocumentUploadCard(
                icon: Icons.insert_drive_file_outlined,
                title: 'Means of Identification',
                subtitle: _meansOfIdentification != null ? 'Document uploaded' : 'Upload document',
                isUploaded: _meansOfIdentification != null,
                onTap: () => _showUploadOptions(DocumentType.identification),
              ),
              const SpaceH16(),

              // Signature
              _DocumentUploadCard(
                icon: Icons.insert_drive_file_outlined,
                title: 'Signature',
                subtitle: _signature != null ? 'Document uploaded' : 'Upload document',
                isUploaded: _signature != null,
                onTap: () => _showUploadOptions(DocumentType.signature),
              ),
              const SpaceH32(),

              // Submit Button
              AppButton(
                text: 'Submit',
                onPressed: _onSubmitPressed,
                isLoading: _isLoading,
              ),
              const SpaceH48(),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Document Type Enum ---
enum DocumentType {
  photoLiveness,
  identification,
  signature,
}

// --- Document Upload Card Widget ---
class _DocumentUploadCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isUploaded;
  final VoidCallback onTap;

  const _DocumentUploadCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isUploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(Sizes.PADDING_16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.lightGray,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.darkBlue,
              size: Sizes.ICON_SIZE_24,
            ),
            const SpaceW12(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.interSemiBold14DarkBlue,
                  ),
                  const SpaceH4(),
                  Text(
                    subtitle,
                    style: AppTextStyles.cabinRegular14MutedGray,
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUploaded ? AppColors.successGreen : AppColors.lightGray,
                  width: 2,
                ),
                color: isUploaded ? AppColors.successGreen : Colors.transparent,
              ),
              child: isUploaded
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: Sizes.ICON_SIZE_18,
              )
                  : const Icon(
                Icons.add,
                color: AppColors.mutedGray,
                size: Sizes.ICON_SIZE_18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}