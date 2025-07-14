import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class HeroSectionWidget extends StatelessWidget {
  final String userName;
  final int recommendationScore;

  const HeroSectionWidget({
    Key? key,
    required this.userName,
    required this.recommendationScore,
  }) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppTheme.successLight;
    if (score >= 60) return AppTheme.secondaryLight;
    if (score >= 40) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  String _getScoreDescription(int score) {
    if (score >= 80) return 'Excellent recommendations based on your activity';
    if (score >= 60) return 'Good recommendations improving daily';
    if (score >= 40) return 'Fair recommendations, help us learn more';
    return 'Limited data, recommendations will improve over time';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryLight,
                  AppTheme.primaryLight.withAlpha(204),
                ]),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.primaryLight.withAlpha(77),
                  blurRadius: 20,
                  offset: const Offset(0, 10)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(color: Colors.white.withAlpha(51)),
                child: Icon(Icons.psychology, color: Colors.white, size: 30.h)),
            SizedBox(width: 16.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('${_getGreeting()}, $userName!',
                      style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  SizedBox(height: 4.h),
                  Text('Your personalized sports recommendations',
                      style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withAlpha(230))),
                ])),
          ]),

          SizedBox(height: 24.h),

          Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  border:
                      Border.all(color: Colors.white.withAlpha(51), width: 1)),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI Recommendation Score',
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withAlpha(230))),
                            SizedBox(height: 4.h),
                            Text(_getScoreDescription(recommendationScore),
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withAlpha(179))),
                          ]),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration:
                              BoxDecoration(color: Colors.white.withAlpha(51)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.auto_awesome,
                                color: Colors.white, size: 16.h),
                            SizedBox(width: 8.w),
                            Text('$recommendationScore%',
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ])),
                    ]),

                SizedBox(height: 16.h),

                // Score Progress Bar
                Container(
                    height: 6.h,
                    decoration:
                        BoxDecoration(color: Colors.white.withAlpha(51)),
                    child: Stack(children: [
                      Container(
                          height: 6.h,
                          decoration:
                              BoxDecoration(color: Colors.white.withAlpha(51))),
                      FractionallySizedBox(
                          widthFactor: recommendationScore / 100,
                          child: Container(
                              height: 6.h,
                              decoration: BoxDecoration(color: Colors.white))),
                    ])),
              ])),

          SizedBox(height: 16.h),

          // Quick Stats
          Row(children: [
            Expanded(
                child: _QuickStat(
                    icon: Icons.event,
                    label: 'Events',
                    value: '12',
                    subtitle: 'Recommended')),
            SizedBox(width: 12.w),
            Expanded(
                child: _QuickStat(
                    icon: Icons.people,
                    label: 'Players',
                    value: '8',
                    subtitle: 'Matched')),
            SizedBox(width: 12.w),
            Expanded(
                child: _QuickStat(
                    icon: Icons.location_on,
                    label: 'Facilities',
                    value: '6',
                    subtitle: 'Nearby')),
          ]),
        ]));
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;

  const _QuickStat({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            color: Colors.white.withAlpha(26),
            border: Border.all(color: Colors.white.withAlpha(51), width: 1)),
        child: Column(children: [
          Icon(icon, color: Colors.white, size: 20.h),
          SizedBox(height: 8.h),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          SizedBox(height: 2.h),
          Text(subtitle,
              style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withAlpha(204))),
        ]));
  }
}