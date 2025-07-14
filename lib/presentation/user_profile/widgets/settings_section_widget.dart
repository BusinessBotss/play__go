import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(String, dynamic) onSettingChanged;
  final VoidCallback onLogout;

  const SettingsSectionWidget({
    Key? key,
    required this.settings,
    required this.onSettingChanged,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notifications Section
          _buildSectionHeader('Notificaciones', 'notifications'),
          _buildNotificationSettings(),

          SizedBox(height: 3.h),

          // Privacy Section
          _buildSectionHeader('Privacidad', 'privacy_tip'),
          _buildPrivacySettings(),

          SizedBox(height: 3.h),

          // Subscription Section
          _buildSectionHeader('Suscripción', 'card_membership'),
          _buildSubscriptionSettings(context),

          SizedBox(height: 3.h),

          // Account Section
          _buildSectionHeader('Cuenta', 'account_circle'),
          _buildAccountSettings(context),

          SizedBox(height: 4.h),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: AppTheme.lightTheme.colorScheme.onError,
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'logout',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.onError,
                  ),
                  SizedBox(width: 2.w),
                  Text('Cerrar Sesión'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 20,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    final notifications = settings["notifications"] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            'Recordatorios de eventos',
            'Recibe notificaciones antes de tus eventos',
            notifications["eventReminders"] as bool,
            (value) => onSettingChanged('notifications.eventReminders', value),
            'event',
          ),
          Divider(),
          _buildSwitchTile(
            'Nuevos mensajes',
            'Notificaciones de mensajes directos',
            notifications["newMessages"] as bool,
            (value) => onSettingChanged('notifications.newMessages', value),
            'message',
          ),
          Divider(),
          _buildSwitchTile(
            'Actualizaciones de seguidos',
            'Actividad de personas que sigues',
            notifications["followUpdates"] as bool,
            (value) => onSettingChanged('notifications.followUpdates', value),
            'people',
          ),
          Divider(),
          _buildSwitchTile(
            'Promociones',
            'Ofertas especiales y descuentos',
            notifications["promotions"] as bool,
            (value) => onSettingChanged('notifications.promotions', value),
            'local_offer',
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    final privacy = settings["privacy"] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildDropdownTile(
            'Visibilidad del perfil',
            'Quién puede ver tu perfil',
            privacy["profileVisibility"] as String,
            ['public', 'friends', 'private'],
            ['Público', 'Solo amigos', 'Privado'],
            (value) => onSettingChanged('privacy.profileVisibility', value),
            'visibility',
          ),
          Divider(),
          _buildSwitchTile(
            'Mostrar actividad',
            'Permite que otros vean tu actividad reciente',
            privacy["showActivity"] as bool,
            (value) => onSettingChanged('privacy.showActivity', value),
            'timeline',
          ),
          Divider(),
          _buildSwitchTile(
            'Mostrar estadísticas',
            'Muestra tus estadísticas públicamente',
            privacy["showStats"] as bool,
            (value) => onSettingChanged('privacy.showStats', value),
            'bar_chart',
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSettings(BuildContext context) {
    final subscription = settings["subscription"] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            'Plan actual',
            subscription["plan"] as String,
            'Expira: ${_formatDate(subscription["expiryDate"] as String)}',
            'card_membership',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gestionar suscripción')),
              );
            },
          ),
          Divider(),
          _buildSwitchTile(
            'Renovación automática',
            'Renueva automáticamente tu suscripción',
            subscription["autoRenew"] as bool,
            (value) => onSettingChanged('subscription.autoRenew', value),
            'autorenew',
          ),
          Divider(),
          _buildActionTile(
            'Métodos de pago',
            'Gestiona tus tarjetas y métodos de pago',
            'payment',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gestionar métodos de pago')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildActionTile(
            'Cambiar contraseña',
            'Actualiza tu contraseña de acceso',
            'lock',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cambiar contraseña')),
              );
            },
          ),
          Divider(),
          _buildActionTile(
            'Descargar mis datos',
            'Obtén una copia de tu información',
            'download',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Preparando descarga...')),
              );
            },
          ),
          Divider(),
          _buildActionTile(
            'Eliminar cuenta',
            'Elimina permanentemente tu cuenta',
            'delete_forever',
            () {
              _showDeleteAccountDialog(context);
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    String iconName,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CustomIconWidget(
        iconName: iconName,
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall,
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String currentValue,
    List<String> values,
    List<String> displayValues,
    Function(String) onChanged,
    String iconName,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CustomIconWidget(
        iconName: iconName,
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall,
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: DropdownButton<String>(
        value: currentValue,
        underline: SizedBox(),
        items: values.asMap().entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.value,
            child: Text(displayValues[entry.key]),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(
      String title, String value, String subtitle, String iconName,
      {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CustomIconWidget(
        iconName: iconName,
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
      trailing: onTap != null
          ? CustomIconWidget(
              iconName: 'arrow_forward_ios',
              size: 16,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildActionTile(
      String title, String subtitle, String iconName, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CustomIconWidget(
        iconName: iconName,
        size: 24,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          color: isDestructive ? AppTheme.lightTheme.colorScheme.error : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        size: 16,
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Cuenta'),
        content: Text(
          'Esta acción no se puede deshacer. Se eliminarán todos tus datos, eventos y conexiones permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Solicitud de eliminación enviada'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
