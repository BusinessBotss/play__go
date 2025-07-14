import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final bool isOwnProfile;
  final VoidCallback? onEditPhoto;

  const ProfileHeaderWidget({
    Key? key,
    required this.userData,
    required this.isOwnProfile,
    this.onEditPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Photo
          Stack(
            children: [
              CircleAvatar(
                radius: 8.h,
                backgroundColor:
                    AppTheme.lightTheme.colorScheme.primaryContainer,
                child: CircleAvatar(
                  radius: 7.5.h,
                  child: CustomImageWidget(
                    imageUrl: userData["profileImage"] as String,
                    width: 15.h,
                    height: 15.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isOwnProfile && onEditPhoto != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditPhoto,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        size: 16,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // User Name and Verification
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  userData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (userData["isVerified"] == true) ...[
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'verified',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ],
            ],
          ),

          SizedBox(height: 1.h),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                size: 16,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 1.w),
              Flexible(
                child: Text(
                  userData["location"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Bio (if available and not empty)
          if (userData["bio"] != null &&
              (userData["bio"] as String).isNotEmpty) ...[
            Text(
              userData["bio"] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
          ],

          // Sport Preferences
          if (userData["sportPreferences"] != null &&
              (userData["sportPreferences"] as List).isNotEmpty) ...[
            Text(
              'Deportes Favoritos',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              alignment: WrapAlignment.center,
              children: (userData["sportPreferences"] as List)
                  .map((sport) => _buildSportChip(sport as String))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSportChip(String sport) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        sport,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
