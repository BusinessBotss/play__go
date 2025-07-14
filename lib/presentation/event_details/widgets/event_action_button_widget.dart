import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EventActionButtonWidget extends StatelessWidget {
  final bool isJoined;
  final int availableSpots;
  final int totalSpots;
  final VoidCallback onToggleJoin;

  const EventActionButtonWidget({
    super.key,
    required this.isJoined,
    required this.availableSpots,
    required this.totalSpots,
    required this.onToggleJoin,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFull = availableSpots <= 0 && !isJoined;
    final bool isWaitlist = availableSpots <= 0 && !isJoined;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status indicator
            if (!isFull)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: isJoined
                      ? AppTheme.lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.5)
                      : AppTheme.lightTheme.colorScheme.secondaryContainer
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isJoined
                      ? '¡Ya estás apuntado! Puedes cancelar hasta 2 horas antes'
                      : '$availableSpots ${availableSpots == 1 ? 'plaza disponible' : 'plazas disponibles'}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isJoined
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Main action button
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: ElevatedButton(
                onPressed: isFull ? null : onToggleJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(),
                  foregroundColor: _getButtonTextColor(),
                  disabledBackgroundColor:
                      AppTheme.lightTheme.colorScheme.outline,
                  disabledForegroundColor: AppTheme
                      .lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  elevation: isFull ? 0 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: _getButtonIcon(),
                      color: _getButtonTextColor(),
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _getButtonText(),
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: _getButtonTextColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Additional info for full events
            if (isFull)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.textSecondaryLight,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Evento completo • Únete a la lista de espera',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor() {
    if (isJoined) {
      return AppTheme.lightTheme.colorScheme.errorContainer;
    } else if (availableSpots > 0) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else {
      return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  Color _getButtonTextColor() {
    if (isJoined) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (availableSpots > 0) {
      return AppTheme.lightTheme.colorScheme.onPrimary;
    } else {
      return AppTheme.lightTheme.colorScheme.onSecondary;
    }
  }

  String _getButtonIcon() {
    if (isJoined) {
      return 'exit_to_app';
    } else if (availableSpots > 0) {
      return 'add';
    } else {
      return 'queue';
    }
  }

  String _getButtonText() {
    if (isJoined) {
      return 'Cancelar Participación';
    } else if (availableSpots > 0) {
      return 'Unirse al Evento';
    } else {
      return 'Lista de Espera';
    }
  }
}
