import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialAuthWidget extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;
  final bool isLoading;

  const SocialAuthWidget({
    Key? key,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign-In Button
        _buildSocialButton(
          onTap: isLoading ? null : onGoogleSignIn,
          icon: 'g_translate',
          label: 'Continuar con Google',
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          textColor: AppTheme.lightTheme.colorScheme.onSurface,
          borderColor: AppTheme.lightTheme.dividerColor,
        ),

        SizedBox(height: 2.h),

        // Apple Sign-In Button
        _buildSocialButton(
          onTap: isLoading ? null : onAppleSignIn,
          icon: 'apple',
          label: 'Continuar con Apple',
          backgroundColor: AppTheme.lightTheme.colorScheme.onSurface,
          textColor: AppTheme.lightTheme.colorScheme.surface,
          borderColor: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onTap,
    required String icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: textColor,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
