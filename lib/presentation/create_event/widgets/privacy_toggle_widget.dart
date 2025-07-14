import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PrivacyToggleWidget extends StatelessWidget {
  final bool isPrivate;
  final ValueChanged<bool> onChanged;

  const PrivacyToggleWidget({
    Key? key,
    required this.isPrivate,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacidad del Evento',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Public Event Option
        Container(
          decoration: BoxDecoration(
            color: !isPrivate
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(
              color: !isPrivate
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.dividerColor,
              width: !isPrivate ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: RadioListTile<bool>(
            value: false,
            groupValue: isPrivate,
            onChanged: (value) => onChanged(value ?? false),
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'public',
                  color: !isPrivate
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evento Público',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: !isPrivate
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Visible para todos los usuarios en la aplicación',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),

        const SizedBox(height: 12),

        // Private Event Option
        Container(
          decoration: BoxDecoration(
            color: isPrivate
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(
              color: isPrivate
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.dividerColor,
              width: isPrivate ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: RadioListTile<bool>(
            value: true,
            groupValue: isPrivate,
            onChanged: (value) => onChanged(value ?? false),
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'lock',
                  color: isPrivate
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evento Privado',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: isPrivate
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Solo visible para usuarios invitados',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),

        // Private Event Features
        if (isPrivate) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Características del Evento Privado',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFeatureItem(
                  icon: 'link',
                  text: 'Se generará un enlace de invitación único',
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(
                  icon: 'share',
                  text: 'Podrás compartir el enlace con quien quieras',
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(
                  icon: 'visibility_off',
                  text: 'No aparecerá en búsquedas públicas',
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(
                  icon: 'group',
                  text: 'Solo los invitados podrán unirse',
                ),
              ],
            ),
          ),
        ],

        // Public Event Features
        if (!isPrivate) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Características del Evento Público',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFeatureItem(
                  icon: 'search',
                  text: 'Aparecerá en búsquedas y recomendaciones',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(
                  icon: 'people',
                  text: 'Cualquier usuario podrá unirse',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(
                  icon: 'trending_up',
                  text: 'Mayor visibilidad y participación',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String text,
    Color? color,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: color ?? AppTheme.lightTheme.colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}
