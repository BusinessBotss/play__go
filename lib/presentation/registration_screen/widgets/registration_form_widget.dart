import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode fullNameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmPasswordFocus;
  final String? fullNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onConfirmPasswordChanged;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;
  final String passwordStrength;
  final Color passwordStrengthColor;

  const RegistrationFormWidget({
    Key? key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fullNameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
    required this.passwordStrength,
    required this.passwordStrengthColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          _buildInputField(
            controller: fullNameController,
            focusNode: fullNameFocus,
            nextFocusNode: emailFocus,
            label: 'Nombre Completo',
            hintText: 'Introduce tu nombre completo',
            prefixIcon: 'person',
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            onChanged: onFullNameChanged,
            errorText: fullNameError,
          ),

          SizedBox(height: 2.h),

          // Email Field
          _buildInputField(
            controller: emailController,
            focusNode: emailFocus,
            nextFocusNode: passwordFocus,
            label: 'Email',
            hintText: 'ejemplo@email.com',
            prefixIcon: 'email',
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
            errorText: emailError,
          ),

          SizedBox(height: 2.h),

          // Password Field
          _buildPasswordField(
            controller: passwordController,
            focusNode: passwordFocus,
            nextFocusNode: confirmPasswordFocus,
            label: 'Contraseña',
            hintText: 'Mínimo 8 caracteres',
            obscureText: obscurePassword,
            onChanged: onPasswordChanged,
            onVisibilityToggle: onPasswordVisibilityToggle,
            errorText: passwordError,
            showStrengthIndicator: true,
          ),

          SizedBox(height: 2.h),

          // Confirm Password Field
          _buildPasswordField(
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocus,
            label: 'Confirmar Contraseña',
            hintText: 'Repite tu contraseña',
            obscureText: obscureConfirmPassword,
            onChanged: onConfirmPasswordChanged,
            onVisibilityToggle: onConfirmPasswordVisibilityToggle,
            errorText: confirmPasswordError,
            showStrengthIndicator: false,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hintText,
    required String prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    required Function(String) onChanged,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (String value) {
            if (nextFocusNode != null) {
              focusNode.nextFocus();
            } else {
              focusNode.unfocus();
            }
          },
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: prefixIcon,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            errorText: errorText,
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hintText,
    required bool obscureText,
    required Function(String) onChanged,
    required VoidCallback onVisibilityToggle,
    String? errorText,
    required bool showStrengthIndicator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 1.h),

        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (String value) {
            if (nextFocusNode != null) {
              focusNode.nextFocus();
            } else {
              focusNode.unfocus();
            }
          },
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: onVisibilityToggle,
              icon: CustomIconWidget(
                iconName: obscureText ? 'visibility' : 'visibility_off',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            errorText: errorText,
            errorMaxLines: 2,
          ),
        ),

        // Password Strength Indicator
        if (showStrengthIndicator && passwordStrength.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Row(
            children: [
              Text(
                'Seguridad: ',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                passwordStrength,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: passwordStrengthColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
