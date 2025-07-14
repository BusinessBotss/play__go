import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SecurityProgressWidget extends StatelessWidget {
  final bool mfaSetup;
  final bool biometricSetup;
  final bool recoveryCodesGenerated;
  final bool securityQuestionsSetup;
  final int securityScore;

  const SecurityProgressWidget({
    Key? key,
    required this.mfaSetup,
    required this.biometricSetup,
    required this.recoveryCodesGenerated,
    required this.securityQuestionsSetup,
    required this.securityScore,
  }) : super(key: key);

  Color _getScoreColor(int score) {
    if (score >= 80) return AppTheme.successLight;
    if (score >= 60) return AppTheme.secondaryLight;
    if (score >= 40) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Poor';
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
            Icon(Icons.shield, color: AppTheme.primaryLight, size: 24.h),
            SizedBox(width: 12.w),
            Expanded(
                child: Text('Security Progress',
                    style: Theme.of(context).textTheme.titleLarge)),
          ]),

          SizedBox(height: 20.h),

          // Security Score Display
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Security Score',
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 4.h),
                  Text(_getScoreLabel(securityScore),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getScoreColor(securityScore),
                          fontWeight: FontWeight.w600)),
                ])),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                    color: _getScoreColor(securityScore).withAlpha(26),
                    border: Border.all(
                        color: _getScoreColor(securityScore).withAlpha(77))),
                child: Text('$securityScore/100',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _getScoreColor(securityScore),
                        fontWeight: FontWeight.w600))),
          ]),

          SizedBox(height: 16.h),

          // Progress Bar
          Container(
              height: 8.h,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Stack(children: [
                Container(
                    height: 8.h,
                    decoration: BoxDecoration(color: Colors.grey.shade200)),
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 8.h,
                    width: (securityScore / 100) *
                        MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: _getScoreColor(securityScore))),
              ])),

          SizedBox(height: 20.h),

          // Security Items Checklist
          Text('Security Measures:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),

          SizedBox(height: 12.h),

          _SecurityItem(
              icon: Icons.phonelink_lock,
              title: 'Multi-Factor Authentication',
              isCompleted: mfaSetup,
              description: 'TOTP, SMS, or Email verification',
              points: 25),

          SizedBox(height: 8.h),

          _SecurityItem(
              icon: Icons.fingerprint,
              title: 'Biometric Authentication',
              isCompleted: biometricSetup,
              description: 'Face ID, Touch ID, or Fingerprint',
              points: 25),

          SizedBox(height: 8.h),

          _SecurityItem(
              icon: Icons.key,
              title: 'Recovery Codes',
              isCompleted: recoveryCodesGenerated,
              description: 'Backup codes for account recovery',
              points: 10),

          SizedBox(height: 8.h),

          _SecurityItem(
              icon: Icons.help_outline,
              title: 'Security Questions',
              isCompleted: securityQuestionsSetup,
              description: 'Additional recovery method',
              points: 10),

          SizedBox(height: 16.h),

          // Recommendations
          if (securityScore < 100) ...[
            Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade200)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.lightbulb_outline,
                            color: Colors.blue, size: 16.h),
                        SizedBox(width: 8.w),
                        Text('Recommendations:',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.w600)),
                      ]),
                      SizedBox(height: 8.h),
                      if (!mfaSetup)
                        Text(
                            '• Set up Multi-Factor Authentication for maximum security',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.blue.shade800)),
                      if (!biometricSetup)
                        Text(
                            '• Enable biometric authentication for convenient access',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.blue.shade800)),
                      if (!recoveryCodesGenerated)
                        Text(
                            '• Generate recovery codes as backup access method',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.blue.shade800)),
                      if (!securityQuestionsSetup)
                        Text(
                            '• Set up security questions for additional recovery',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.blue.shade800)),
                    ])),
          ],
        ]));
  }
}

class _SecurityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCompleted;
  final String description;
  final int points;

  const _SecurityItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.isCompleted,
    required this.description,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            color: isCompleted
                ? AppTheme.successLight.withAlpha(13)
                : Colors.grey.shade50,
            border: Border.all(
                color: isCompleted
                    ? AppTheme.successLight.withAlpha(51)
                    : Colors.grey.shade200)),
        child: Row(children: [
          Icon(icon,
              color: isCompleted ? AppTheme.successLight : Colors.grey,
              size: 20.h),
          SizedBox(width: 12.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                Text(description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade600)),
              ])),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.successLight.withAlpha(26)
                      : Colors.grey.shade200),
              child: Text('+$points pts',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isCompleted ? AppTheme.successLight : Colors.grey,
                      fontWeight: FontWeight.w500))),
          SizedBox(width: 8.w),
          Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? AppTheme.successLight : Colors.grey,
              size: 20.h),
        ]));
  }
}
