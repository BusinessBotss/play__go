import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RecoveryCodesWidget extends StatelessWidget {
  final List<String> recoveryCodes;
  final bool isGenerated;
  final VoidCallback onGenerateCodes;

  const RecoveryCodesWidget({
    Key? key,
    required this.recoveryCodes,
    required this.isGenerated,
    required this.onGenerateCodes,
  }) : super(key: key);

  void _copyAllCodes(BuildContext context) {
    final codesText = recoveryCodes.join('\n');
    Clipboard.setData(ClipboardData(text: codesText));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Recovery codes copied to clipboard'),
        duration: Duration(seconds: 2)));
  }

  void _downloadCodes(BuildContext context) {
    // In a real app, this would trigger a file download
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Recovery codes download started'),
        duration: Duration(seconds: 2)));
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
            Icon(Icons.key, color: AppTheme.primaryLight, size: 24.h),
            SizedBox(width: 12.w),
            Expanded(
                child: Text('Recovery Codes',
                    style: Theme.of(context).textTheme.titleLarge)),
            if (isGenerated)
              Icon(Icons.check_circle,
                  color: AppTheme.successLight, size: 24.h),
          ]),
          SizedBox(height: 16.h),
          Text(
              'Recovery codes are backup codes that can be used to access your account if you lose access to your primary authentication method.',
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 20.h),
          if (!isGenerated) ...[
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: onGenerateCodes,
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder()),
                    child: Text('Generate Recovery Codes',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white)))),
            SizedBox(height: 12.h),
            Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: AppTheme.warningLight.withAlpha(26),
                    border:
                        Border.all(color: AppTheme.warningLight.withAlpha(77))),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_outlined,
                          color: AppTheme.warningLight, size: 16.h),
                      SizedBox(width: 8.w),
                      Expanded(
                          child: Text(
                              'Recovery codes are important for account security. Generate and store them safely.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.warningLight))),
                    ])),
          ] else ...[
            Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Recovery Codes:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 12.h),
                      ...recoveryCodes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final code = entry.value;
                        return Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey.shade200)),
                            child: Row(children: [
                              SizedBox(
                                  width: 24.w,
                                  child: Text('${index + 1}.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: Colors.grey.shade600))),
                              SizedBox(width: 12.w),
                              Expanded(
                                  child: Text(code,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontFamily: 'monospace',
                                              fontWeight: FontWeight.w500))),
                            ]));
                      }).toList(),
                    ])),
            SizedBox(height: 16.h),
            Row(children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => _copyAllCodes(context),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder()),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.copy, size: 16.h),
                            SizedBox(width: 8.w),
                            const Text('Copy All'),
                          ]))),
              SizedBox(width: 12.w),
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => _downloadCodes(context),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder()),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download, size: 16.h),
                            SizedBox(width: 8.w),
                            const Text('Download'),
                          ]))),
            ]),
            SizedBox(height: 16.h),
            Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: AppTheme.errorLight.withAlpha(26),
                    border:
                        Border.all(color: AppTheme.errorLight.withAlpha(77))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.security,
                            color: AppTheme.errorLight, size: 16.h),
                        SizedBox(width: 8.w),
                        Text('Important Security Instructions:',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: AppTheme.errorLight,
                                    fontWeight: FontWeight.w600)),
                      ]),
                      SizedBox(height: 8.h),
                      Text(
                          '• Store these codes in a safe place\n• Each code can only be used once\n• Keep them separate from your device\n• Do not share them with anyone\n• Consider printing them for offline storage',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppTheme.errorLight)),
                    ])),
          ],
        ]));
  }
}
