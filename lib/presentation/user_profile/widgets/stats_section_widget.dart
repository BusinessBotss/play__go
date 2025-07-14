import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatsSection extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function(String) onStatsPressed;

  const StatsSection({
    Key? key,
    required this.userData,
    required this.onStatsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            'Eventos\nAsistidos',
            userData["eventsAttended"].toString(),
            'event',
            () => onStatsPressed('eventos_asistidos'),
          ),
          _buildDivider(),
          _buildStatItem(
            'Eventos\nOrganizados',
            userData["eventsOrganized"].toString(),
            'event_available',
            () => onStatsPressed('eventos_organizados'),
          ),
          _buildDivider(),
          _buildStatItem(
            'Seguidores',
            _formatNumber(userData["followers"] as int),
            'people',
            () => onStatsPressed('seguidores'),
          ),
          _buildDivider(),
          _buildStatItem(
            'Siguiendo',
            _formatNumber(userData["following"] as int),
            'person_add',
            () => onStatsPressed('siguiendo'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, String iconName, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: iconName,
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 1.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 6.h,
      width: 1,
      color: AppTheme.lightTheme.dividerColor,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
