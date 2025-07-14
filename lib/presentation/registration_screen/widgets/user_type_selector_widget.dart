import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserTypeSelectorWidget extends StatelessWidget {
  final String selectedUserType;
  final Function(String) onUserTypeChanged;

  const UserTypeSelectorWidget({
    Key? key,
    required this.selectedUserType,
    required this.onUserTypeChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> userTypes = const [
    {
      'type': 'Player',
      'label': 'Jugador',
      'description': 'Participa en eventos deportivos',
      'icon': 'sports_soccer',
    },
    {
      'type': 'Organizer',
      'label': 'Organizador',
      'description': 'Crea y gestiona eventos',
      'icon': 'event',
    },
    {
      'type': 'Fan',
      'label': 'Aficionado',
      'description': 'Sigue eventos y equipos',
      'icon': 'favorite',
    },
    {
      'type': 'Facility Owner',
      'label': 'Propietario',
      'description': 'Gestiona instalaciones deportivas',
      'icon': 'business',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Usuario',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 2.h),

        // User Type Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: userTypes.length,
          itemBuilder: (context, index) {
            final userType = userTypes[index];
            final isSelected = selectedUserType == userType['type'];

            return GestureDetector(
              onTap: () => onUserTypeChanged(userType['type']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(3.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: userType['icon'],
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      userType['label'],
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      userType['description'],
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
            );
          },
        ),
      ],
    );
  }
}
