import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MfaSetupWidget extends StatefulWidget {
  final String totpSecret;
  final String qrCodeData;
  final bool smsVerificationEnabled;
  final bool emailVerificationEnabled;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController totpCodeController;
  final Function(bool) onMfaSetupComplete;
  final Function(bool) onSmsToggle;
  final Function(bool) onEmailToggle;

  const MfaSetupWidget({
    Key? key,
    required this.totpSecret,
    required this.qrCodeData,
    required this.smsVerificationEnabled,
    required this.emailVerificationEnabled,
    required this.phoneController,
    required this.emailController,
    required this.totpCodeController,
    required this.onMfaSetupComplete,
    required this.onSmsToggle,
    required this.onEmailToggle,
  }) : super(key: key);

  @override
  State<MfaSetupWidget> createState() => _MfaSetupWidgetState();
}

class _MfaSetupWidgetState extends State<MfaSetupWidget> {
  bool _showQrCode = true;
  bool _totpVerified = false;
  bool _smsVerified = false;
  bool _emailVerified = false;

  void _copySecretToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.totpSecret));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Secret key copied to clipboard'),
        duration: Duration(seconds: 2)));
  }

  void _verifyTotpCode() {
    // In a real app, this would verify the TOTP code against the server
    if (widget.totpCodeController.text.length == 6) {
      setState(() {
        _totpVerified = true;
      });
      _checkMfaCompletion();
    }
  }

  void _verifySmsCode() {
    // Simulate SMS verification
    setState(() {
      _smsVerified = true;
    });
    _checkMfaCompletion();
  }

  void _verifyEmailCode() {
    // Simulate email verification
    setState(() {
      _emailVerified = true;
    });
    _checkMfaCompletion();
  }

  void _checkMfaCompletion() {
    bool isComplete = _totpVerified ||
        (widget.smsVerificationEnabled && _smsVerified) ||
        (widget.emailVerificationEnabled && _emailVerified);
    widget.onMfaSetupComplete(isComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.w),
        decoration:
            BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.phonelink_lock,
                color: AppTheme.primaryLight, size: 24.h),
            SizedBox(width: 12.w),
            Expanded(
                child: Text('Multi-Factor Authentication',
                    style: Theme.of(context).textTheme.titleLarge)),
            if (_totpVerified || _smsVerified || _emailVerified)
              Icon(Icons.check_circle,
                  color: AppTheme.successLight, size: 24.h),
          ]),

          SizedBox(height: 16.h),

          Text('Choose your preferred authentication method:',
              style: Theme.of(context).textTheme.bodyMedium),

          SizedBox(height: 20.h),

          // TOTP Authenticator App Setup
          Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withAlpha(13),
                  border:
                      Border.all(color: AppTheme.primaryLight.withAlpha(51))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.smartphone,
                          color: AppTheme.primaryLight, size: 20.h),
                      SizedBox(width: 8.w),
                      Text('Authenticator App (Recommended)',
                          style: Theme.of(context).textTheme.titleMedium),
                    ]),
                    SizedBox(height: 12.h),
                    if (_showQrCode) ...[
                      Center(
                          child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(color: Colors.white),
                              child: QrImageView(
                                  data: widget.qrCodeData,
                                  version: QrVersions.auto,
                                  size: 150.w))),
                      SizedBox(height: 12.h),
                      Text(
                          'Scan this QR code with your authenticator app (Google Authenticator, Authy, etc.)',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center),
                      SizedBox(height: 12.h),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showQrCode = false;
                                  });
                                },
                                child: const Text('Enter manually')),
                          ]),
                    ] else ...[
                      Text('Secret Key:',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      Container(
                          padding: EdgeInsets.all(12.w),
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          child: Row(children: [
                            Expanded(
                                child: Text(widget.totpSecret,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontFamily: 'monospace'))),
                            IconButton(
                                onPressed: _copySecretToClipboard,
                                icon: const Icon(Icons.copy)),
                          ])),
                      SizedBox(height: 12.h),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showQrCode = true;
                                  });
                                },
                                child: const Text('Show QR Code')),
                          ]),
                    ],
                    SizedBox(height: 16.h),
                    TextField(
                        controller: widget.totpCodeController,
                        decoration: const InputDecoration(
                            labelText: 'Enter 6-digit code',
                            hintText: '123456',
                            suffixIcon: Icon(Icons.lock)),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        onChanged: (value) {
                          if (value.length == 6) {
                            _verifyTotpCode();
                          }
                        }),
                    if (_totpVerified) ...[
                      SizedBox(height: 8.h),
                      Row(children: [
                        Icon(Icons.check_circle,
                            color: AppTheme.successLight, size: 16.h),
                        SizedBox(width: 8.w),
                        Text('TOTP verified successfully',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppTheme.successLight)),
                      ]),
                    ],
                  ])),

          SizedBox(height: 20.h),

          // SMS Verification
          Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: widget.smsVerificationEnabled
                      ? AppTheme.secondaryLight.withAlpha(13)
                      : Colors.grey.shade50,
                  border: Border.all(
                      color: widget.smsVerificationEnabled
                          ? AppTheme.secondaryLight.withAlpha(77)
                          : Colors.grey.shade300)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.sms,
                          color: widget.smsVerificationEnabled
                              ? AppTheme.secondaryLight
                              : Colors.grey,
                          size: 20.h),
                      SizedBox(width: 8.w),
                      Expanded(
                          child: Text('SMS Verification',
                              style: Theme.of(context).textTheme.titleMedium)),
                      Switch(
                          value: widget.smsVerificationEnabled,
                          onChanged: widget.onSmsToggle),
                    ]),
                    if (widget.smsVerificationEnabled) ...[
                      SizedBox(height: 12.h),
                      TextField(
                          controller: widget.phoneController,
                          decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              hintText: '+1234567890',
                              prefixIcon: Icon(Icons.phone)),
                          keyboardType: TextInputType.phone),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                          onPressed: _verifySmsCode,
                          child: const Text('Verify SMS')),
                      if (_smsVerified) ...[
                        SizedBox(height: 8.h),
                        Row(children: [
                          Icon(Icons.check_circle,
                              color: AppTheme.successLight, size: 16.h),
                          SizedBox(width: 8.w),
                          Text('SMS verification enabled',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.successLight)),
                        ]),
                      ],
                    ],
                  ])),

          SizedBox(height: 16.h),

          // Email Verification
          Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: widget.emailVerificationEnabled
                      ? AppTheme.secondaryLight.withAlpha(13)
                      : Colors.grey.shade50,
                  border: Border.all(
                      color: widget.emailVerificationEnabled
                          ? AppTheme.secondaryLight.withAlpha(77)
                          : Colors.grey.shade300)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.email,
                          color: widget.emailVerificationEnabled
                              ? AppTheme.secondaryLight
                              : Colors.grey,
                          size: 20.h),
                      SizedBox(width: 8.w),
                      Expanded(
                          child: Text('Email Verification',
                              style: Theme.of(context).textTheme.titleMedium)),
                      Switch(
                          value: widget.emailVerificationEnabled,
                          onChanged: widget.onEmailToggle),
                    ]),
                    if (widget.emailVerificationEnabled) ...[
                      SizedBox(height: 12.h),
                      TextField(
                          controller: widget.emailController,
                          decoration: const InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'user@example.com',
                              prefixIcon: Icon(Icons.email)),
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                          onPressed: _verifyEmailCode,
                          child: const Text('Verify Email')),
                      if (_emailVerified) ...[
                        SizedBox(height: 8.h),
                        Row(children: [
                          Icon(Icons.check_circle,
                              color: AppTheme.successLight, size: 16.h),
                          SizedBox(width: 8.w),
                          Text('Email verification enabled',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.successLight)),
                        ]),
                      ],
                    ],
                  ])),
        ]));
  }
}
