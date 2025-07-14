import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/biometric_setup_widget.dart';
import './widgets/mfa_setup_widget.dart';
import './widgets/recovery_codes_widget.dart';
import './widgets/security_progress_widget.dart';
import './widgets/security_questions_widget.dart';
import 'widgets/biometric_setup_widget.dart';
import 'widgets/mfa_setup_widget.dart';
import 'widgets/recovery_codes_widget.dart';
import 'widgets/security_progress_widget.dart';
import 'widgets/security_questions_widget.dart';

class EnhancedAuthenticationSetup extends StatefulWidget {
  const EnhancedAuthenticationSetup({Key? key}) : super(key: key);

  @override
  State<EnhancedAuthenticationSetup> createState() =>
      _EnhancedAuthenticationSetupState();
}

class _EnhancedAuthenticationSetupState
    extends State<EnhancedAuthenticationSetup> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Setup progress tracking
  bool _isMfaSetup = false;
  bool _isBiometricSetup = false;
  bool _isRecoveryCodesGenerated = false;
  bool _isSecurityQuestionsSetup = false;
  bool _smsVerificationEnabled = false;
  bool _emailVerificationEnabled = false;

  // MFA setup data
  String _totpSecret = '';
  String _qrCodeData = '';
  List<String> _recoveryCodes = [];
  String _selectedSecurityQuestion = '';
  String _securityAnswer = '';

  // Form controllers
  final _securityAnswerController = TextEditingController();
  final _totpCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Biometric availability
  bool _biometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _initializeBiometrics();
    _generateTotpSecret();
  }

  @override
  void dispose() {
    _securityAnswerController.dispose();
    _totpCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _initializeBiometrics() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();

      setState(() {
        _biometricAvailable = isAvailable;
        _availableBiometrics = availableBiometrics;
      });
    } catch (e) {
      print('Error initializing biometrics: $e');
    }
  }

  void _generateTotpSecret() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final Random random = Random();
    _totpSecret = String.fromCharCodes(Iterable.generate(
        32, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

    // Generate QR code data (typically includes service name, user email, and secret)
    _qrCodeData =
        'otpauth://totp/PlayAndGo:user@example.com?secret=$_totpSecret&issuer=PlayAndGo';
  }

  void _generateRecoveryCodes() {
    final Random random = Random();
    _recoveryCodes = List.generate(10, (index) {
      return '${random.nextInt(9999).toString().padLeft(4, '0')}-${random.nextInt(9999).toString().padLeft(4, '0')}';
    });

    setState(() {
      _isRecoveryCodesGenerated = true;
    });
  }

  Future<void> _setupBiometric() async {
    if (!_biometricAvailable) return;

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to set up biometric security',
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true));

      if (didAuthenticate) {
        setState(() {
          _isBiometricSetup = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Biometric authentication set up successfully'),
            backgroundColor: AppTheme.successLight));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to set up biometric authentication: $e'),
          backgroundColor: AppTheme.errorLight));
    }
  }

  bool _canCompleteSetup() {
    return _isMfaSetup &&
        (_isBiometricSetup ||
            _smsVerificationEnabled ||
            _emailVerificationEnabled);
  }

  int _getSecurityScore() {
    int score = 0;
    if (_isMfaSetup) score += 25;
    if (_isBiometricSetup) score += 25;
    if (_smsVerificationEnabled) score += 15;
    if (_emailVerificationEnabled) score += 15;
    if (_isRecoveryCodesGenerated) score += 10;
    if (_isSecurityQuestionsSetup) score += 10;
    return score;
  }

  void _completeSetup() {
    if (!_canCompleteSetup()) return;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Security Setup Complete'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.security,
                      size: 48.h, color: AppTheme.successLight),
                  SizedBox(height: 16.h),
                  Text(
                      'Your account security score: ${_getSecurityScore()}/100',
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8.h),
                  Text(
                      'Your account is now protected with enhanced security measures.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center),
                ]),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pop(); // Return to previous screen
                      },
                      child: const Text('Continue')),
                ]));
  }

  void _showSkipWarning() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Security Risk Warning'),
                content: const Text(
                    'Skipping enhanced security setup leaves your account vulnerable to unauthorized access. Are you sure you want to continue?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pop(); // Return to previous screen
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: AppTheme.errorLight),
                      child: const Text('Skip Anyway')),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Enhanced Security Setup'),
            centerTitle: true,
            actions: [
              TextButton(
                  onPressed: _showSkipWarning, child: const Text('Skip')),
            ]),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Security header
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 10,
                            offset: const Offset(0, 2)),
                      ]),
                  child: Column(children: [
                    Icon(Icons.security,
                        size: 48.h, color: AppTheme.primaryLight),
                    SizedBox(height: 16.h),
                    Text('Secure Your Account',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center),
                    SizedBox(height: 8.h),
                    Text(
                        'Enhanced security protects your account with multiple layers of authentication, ensuring only you can access your sports networking data.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center),
                  ])),

              SizedBox(height: 24.h),

              // Security progress indicator
              SecurityProgressWidget(
                  mfaSetup: _isMfaSetup,
                  biometricSetup: _isBiometricSetup,
                  recoveryCodesGenerated: _isRecoveryCodesGenerated,
                  securityQuestionsSetup: _isSecurityQuestionsSetup,
                  securityScore: _getSecurityScore()),

              SizedBox(height: 24.h),

              // MFA Setup Section
              MfaSetupWidget(
                  totpSecret: _totpSecret,
                  qrCodeData: _qrCodeData,
                  smsVerificationEnabled: _smsVerificationEnabled,
                  emailVerificationEnabled: _emailVerificationEnabled,
                  phoneController: _phoneController,
                  emailController: _emailController,
                  totpCodeController: _totpCodeController,
                  onMfaSetupComplete: (bool isComplete) {
                    setState(() {
                      _isMfaSetup = isComplete;
                    });
                  },
                  onSmsToggle: (bool enabled) {
                    setState(() {
                      _smsVerificationEnabled = enabled;
                    });
                  },
                  onEmailToggle: (bool enabled) {
                    setState(() {
                      _emailVerificationEnabled = enabled;
                    });
                  }),

              SizedBox(height: 24.h),

              // Biometric Setup Section
              BiometricSetupWidget(
                  biometricAvailable: _biometricAvailable,
                  availableBiometrics: _availableBiometrics,
                  isBiometricSetup: _isBiometricSetup,
                  onSetupBiometric: _setupBiometric),

              SizedBox(height: 24.h),

              // Recovery Codes Section
              RecoveryCodesWidget(
                  recoveryCodes: _recoveryCodes,
                  isGenerated: _isRecoveryCodesGenerated,
                  onGenerateCodes: _generateRecoveryCodes),

              SizedBox(height: 24.h),

              // Security Questions Section
              SecurityQuestionsWidget(
                  selectedQuestion: _selectedSecurityQuestion,
                  answerController: _securityAnswerController,
                  onQuestionSelected: (String question) {
                    setState(() {
                      _selectedSecurityQuestion = question;
                    });
                  },
                  onAnswerChanged: (String answer) {
                    setState(() {
                      _securityAnswer = answer;
                      _isSecurityQuestionsSetup =
                          _selectedSecurityQuestion.isNotEmpty &&
                              answer.isNotEmpty;
                    });
                  }),

              SizedBox(height: 32.h),

              // Complete Setup Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _canCompleteSetup() ? _completeSetup : null,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder()),
                      child: Text('Complete Setup',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white)))),

              SizedBox(height: 16.h),

              // Requirements text
              if (!_canCompleteSetup())
                Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                        color: AppTheme.warningLight.withAlpha(26),
                        border: Border.all(
                            color: AppTheme.warningLight.withAlpha(77))),
                    child: Row(children: [
                      Icon(Icons.info_outline,
                          color: AppTheme.warningLight, size: 20.h),
                      SizedBox(width: 12.w),
                      Expanded(
                          child: Text(
                              'Complete MFA setup and at least one additional security method to continue.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.warningLight))),
                    ])),
            ])));
  }
}
