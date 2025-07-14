import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/edit_profile_modal_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/stats_section_widget.dart';

class UserProfile extends StatefulWidget {
  final String? userId;
  final bool isOwnProfile;

  const UserProfile({
    Key? key,
    this.userId,
    this.isOwnProfile = true,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;
  bool _isDarkMode = false;

  // Mock user data
  final Map<String, dynamic> _currentUser = {
    "id": "user_001",
    "name": "Carlos Martínez",
    "location": "Palma, Mallorca",
    "profileImage":
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
    "bio":
        "Passionate football player and tennis enthusiast. Love organizing community sports events in Mallorca.",
    "sportPreferences": ["Football", "Tennis", "Basketball", "Swimming"],
    "eventsAttended": 45,
    "eventsOrganized": 12,
    "followers": 234,
    "following": 189,
    "joinDate": "2023-03-15",
    "isVerified": true,
    "achievements": [
      {"id": 1, "name": "Event Organizer", "icon": "event", "earned": true},
      {"id": 2, "name": "Team Player", "icon": "group", "earned": true},
      {
        "id": 3,
        "name": "Sports Enthusiast",
        "icon": "sports_soccer",
        "earned": true
      },
      {"id": 4, "name": "Community Builder", "icon": "people", "earned": false},
      {
        "id": 5,
        "name": "Tournament Winner",
        "icon": "emoji_events",
        "earned": false
      },
    ],
    "recentActivity": [
      {
        "id": 1,
        "type": "event_attended",
        "title": "Football Match at Son Moix",
        "date": "2025-07-08",
        "image":
            "https://images.pexels.com/photos/274506/pexels-photo-274506.jpeg"
      },
      {
        "id": 2,
        "type": "event_created",
        "title": "Tennis Tournament - Beginners",
        "date": "2025-07-05",
        "image":
            "https://images.pexels.com/photos/209977/pexels-photo-209977.jpeg"
      },
      {
        "id": 3,
        "type": "facility_booked",
        "title": "Basketball Court - 2 hours",
        "date": "2025-07-03",
        "image":
            "https://images.pexels.com/photos/1752757/pexels-photo-1752757.jpeg"
      },
    ],
    "mutualConnections": [
      {
        "id": "user_002",
        "name": "María González",
        "profileImage":
            "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg"
      },
      {
        "id": "user_003",
        "name": "David López",
        "profileImage":
            "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg"
      },
    ],
    "settings": {
      "notifications": {
        "eventReminders": true,
        "newMessages": true,
        "followUpdates": false,
        "promotions": true,
      },
      "privacy": {
        "profileVisibility": "public",
        "showActivity": true,
        "showStats": true,
      },
      "subscription": {
        "plan": "Premium",
        "expiryDate": "2025-12-31",
        "autoRenew": true,
      }
    }
  };

  final Map<String, dynamic> _otherUser = {
    "id": "user_004",
    "name": "Ana Rodríguez",
    "location": "Calvià, Mallorca",
    "profileImage":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
    "bio":
        "Professional tennis coach and swimming instructor. Organizing sports events for youth development.",
    "sportPreferences": ["Tennis", "Swimming", "Volleyball"],
    "eventsAttended": 67,
    "eventsOrganized": 23,
    "followers": 456,
    "following": 234,
    "joinDate": "2022-08-20",
    "isVerified": true,
    "achievements": [
      {"id": 1, "name": "Event Organizer", "icon": "event", "earned": true},
      {"id": 2, "name": "Team Player", "icon": "group", "earned": true},
      {
        "id": 3,
        "name": "Sports Enthusiast",
        "icon": "sports_soccer",
        "earned": true
      },
      {"id": 4, "name": "Community Builder", "icon": "people", "earned": true},
      {
        "id": 5,
        "name": "Tournament Winner",
        "icon": "emoji_events",
        "earned": false
      },
    ],
    "recentActivity": [
      {
        "id": 1,
        "type": "event_created",
        "title": "Youth Swimming Championship",
        "date": "2025-07-09",
        "image":
            "https://images.pexels.com/photos/863988/pexels-photo-863988.jpeg"
      },
      {
        "id": 2,
        "type": "event_attended",
        "title": "Tennis Workshop for Beginners",
        "date": "2025-07-06",
        "image":
            "https://images.pexels.com/photos/209977/pexels-photo-209977.jpeg"
      },
    ],
    "mutualConnections": [
      {
        "id": "user_002",
        "name": "María González",
        "profileImage":
            "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg"
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Simulate loading user data
    if (!widget.isOwnProfile) {
      setState(() {
        _isFollowing = false; // Check if already following
      });
    }
  }

  Map<String, dynamic> get _userData =>
      widget.isOwnProfile ? _currentUser : _otherUser;

  void _showEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileModalWidget(
        userData: _currentUser,
        onSave: _handleProfileUpdate,
      ),
    );
  }

  void _handleProfileUpdate(Map<String, dynamic> updatedData) {
    setState(() {
      _currentUser.addAll(updatedData);
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perfil actualizado correctamente'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        _otherUser["followers"] = (_otherUser["followers"] as int) + 1;
      } else {
        _otherUser["followers"] = (_otherUser["followers"] as int) - 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing
            ? 'Siguiendo a ${_userData["name"]}'
            : 'Dejaste de seguir a ${_userData["name"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _sendMessage() {
    Navigator.pushNamed(context, '/messages');
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Código QR del Perfil'),
        content: Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.lightTheme.dividerColor),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'qr_code',
                  size: 40.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Escanea para ver perfil',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : null,
        title: Text(
          widget.isOwnProfile ? 'Mi Perfil' : _userData["name"] as String,
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          if (widget.isOwnProfile) ...[
            IconButton(
              onPressed: _showQRCode,
              icon: CustomIconWidget(
                iconName: 'qr_code',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _showEditProfileModal,
              icon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ] else ...[
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'share':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Compartir perfil')),
                    );
                    break;
                  case 'report':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reportar usuario')),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      SizedBox(width: 3.w),
                      Text('Compartir'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'report',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'report',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                      SizedBox(width: 3.w),
                      Text('Reportar'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userData: _userData,
              isOwnProfile: widget.isOwnProfile,
              onEditPhoto:
                  widget.isOwnProfile ? () => _showEditProfileModal() : null,
            ),

            SizedBox(height: 2.h),

            // Action Buttons (for other profiles)
            if (!widget.isOwnProfile) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _toggleFollow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFollowing
                              ? AppTheme.lightTheme.colorScheme.surface
                              : AppTheme.lightTheme.colorScheme.primary,
                          foregroundColor: _isFollowing
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onPrimary,
                          side: _isFollowing
                              ? BorderSide(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: Text(_isFollowing ? 'Siguiendo' : 'Seguir'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _sendMessage,
                        child: Text('Mensaje'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
            ],

            // Stats Section
            StatsSection(
              userData: _userData,
              onStatsPressed: (String statType) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ver $statType')),
                );
              },
            ),

            SizedBox(height: 3.h),

            // Achievement Badges
            AchievementBadgesWidget(
              achievements: (_userData["achievements"] as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList(),
            ),

            SizedBox(height: 3.h),

            // Mutual Connections (for other profiles)
            if (!widget.isOwnProfile &&
                (_userData["mutualConnections"] as List).isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conexiones Mutuas',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    SizedBox(
                      height: 8.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            (_userData["mutualConnections"] as List).length,
                        itemBuilder: (context, index) {
                          final connection = (_userData["mutualConnections"]
                              as List)[index] as Map<String, dynamic>;
                          return Padding(
                            padding: EdgeInsets.only(right: 3.w),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 2.5.h,
                                  child: CustomImageWidget(
                                    imageUrl:
                                        connection["profileImage"] as String,
                                    width: 5.h,
                                    height: 5.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  (connection["name"] as String).split(' ')[0],
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
            ],

            // Tab Bar for Activity and Settings
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Actividad'),
                  if (widget.isOwnProfile) Tab(text: 'Configuración'),
                  if (!widget.isOwnProfile) Tab(text: 'Información'),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Tab Bar View
            SizedBox(
              height: 50.h,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Recent Activity Tab
                  RecentActivityWidget(
                    activities: (_userData["recentActivity"] as List)
                        .map((item) => item as Map<String, dynamic>)
                        .toList(),
                  ),

                  // Settings Tab (own profile) or Info Tab (other profile)
                  widget.isOwnProfile
                      ? SettingsSectionWidget(
                          settings:
                              _currentUser["settings"] as Map<String, dynamic>,
                          onSettingChanged: (String key, dynamic value) {
                            setState(() {
                              // Update settings
                              if (key.contains('.')) {
                                final parts = key.split('.');
                                ((_currentUser["settings"]
                                        as Map<String, dynamic>)[parts[0]]
                                    as Map<String, dynamic>)[parts[1]] = value;
                              }
                            });
                          },
                          onLogout: _showLogoutDialog,
                        )
                      : _buildInfoTab(),
                ],
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((_userData["bio"] as String).isNotEmpty) ...[
            Text(
              'Biografía',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              _userData["bio"] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
          ],
          Text(
            'Información',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          _buildInfoRow(
              'Ubicación', _userData["location"] as String, 'location_on'),
          _buildInfoRow(
              'Miembro desde',
              _formatJoinDate(_userData["joinDate"] as String),
              'calendar_today'),
          if (_userData["isVerified"] == true)
            _buildInfoRow('Estado', 'Verificado', 'verified', isVerified: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String iconName,
      {bool isVerified = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 20,
            color: isVerified
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isVerified
                        ? AppTheme.lightTheme.colorScheme.primary
                        : null,
                    fontWeight: isVerified ? FontWeight.w500 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatJoinDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
