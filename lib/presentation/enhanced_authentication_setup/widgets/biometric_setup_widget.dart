import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BiometricSetupWidget extends StatelessWidget {
  final bool biometricAvailable;
  final List<BiometricType> availableBiometrics;
  final bool isBiometricSetup;
  final VoidCallback onSetupBiometric;

  const BiometricSetupWidget({
    Key? key,
    required this.biometricAvailable,
    required this.availableBiometrics,
    required this.isBiometricSetup,
    required this.onSetupBiometric,
  }) : super(key: key);

  String _getBiometricDisplayName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }

  IconData _getBiometricIcon(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return Icons.face;
      case BiometricType.fingerprint:
        return Icons.fingerprint;
      case BiometricType.iris:
        return Icons.remove_red_eye;
      case BiometricType.strong:
        return Icons.security;
      case BiometricType.weak:
        return Icons.security;
    }
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
            Icon(Icons.fingerprint, color: AppTheme.primaryLight, size: 24.h),
            SizedBox(width: 12.w),
            Expanded(
                child: Text('Biometric Authentication',
                    style: Theme.of(context).textTheme.titleLarge)),
            if (isBiometricSetup)
              Icon(Icons.check_circle,
                  color: AppTheme.successLight, size: 24.h),
          ]),
          SizedBox(height: 16.h),
          if (!biometricAvailable) ...[
            Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: Colors.grey.shade100),
                child: Row(children: [
                  Icon(Icons.info_outline,
                      color: Colors.grey.shade600, size: 20.h),
                  SizedBox(width: 12.w),
                  Expanded(
                      child: Text(
                          'Biometric authentication is not available on this device.',
                          style: Theme.of(context).textTheme.bodyMedium)),
                ])),
          ] else if (availableBiometrics.isEmpty) ...[
            Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                    color: AppTheme.warningLight.withAlpha(26),
                    border:
                        Border.all(color: AppTheme.warningLight.withAlpha(77))),
                child: Row(children: [
                  Icon(Icons.warning_amber_outlined,
                      color: AppTheme.warningLight, size: 20.h),
                  SizedBox(width: 12.w),
                  Expanded(
                      child: Text(
                          'No biometric methods are enrolled on this device. Please set up biometric authentication in your device settings first.',
                          style: Theme.of(context).textTheme.bodyMedium)),
                ])),
          ] else ...[
            Text('Available biometric methods on your device:',
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 12.h),
            ...availableBiometrics
                .map((biometric) => Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withAlpha(13),
                        border: Border.all(
                            color: AppTheme.primaryLight.withAlpha(51))),
                    child: Row(children: [
                      Icon(_getBiometricIcon(biometric),
                          color: AppTheme.primaryLight, size: 20.h),
                      SizedBox(width: 12.w),
                      Text(_getBiometricDisplayName(biometric),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ])))
                .toList(),
            SizedBox(height: 16.h),
            if (!isBiometricSetup) ...[
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: onSetupBiometric,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder()),
                      child: Text('Set Up Biometric Authentication',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white)))),
              SizedBox(height: 12.h),
              Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(color: Colors.blue.shade200)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue, size: 16.h),
                        SizedBox(width: 8.w),
                        Expanded(
                            child: Text(
                                'Biometric data is stored securely on your device and never transmitted to our servers.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.blue.shade800))),
                      ])),
            ] else ...[
              Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                      color: AppTheme.successLight.withAlpha(26),
                      border: Border.all(
                          color: AppTheme.successLight.withAlpha(77))),
                  child: Row(children: [
                    Icon(Icons.check_circle,
                        color: AppTheme.successLight, size: 20.h),
                    SizedBox(width: 12.w),
                    Expanded(
                        child: Text(
                            'Biometric authentication is successfully configured. You can now use your biometric method to secure your account.',
                            style: Theme.of(context).textTheme.bodyMedium)),
                  ])),
            ],
          ],
        ]));
  }
}
