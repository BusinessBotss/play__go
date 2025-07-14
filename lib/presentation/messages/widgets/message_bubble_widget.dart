import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final bool isGroup;
  final VoidCallback onLongPress;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.isGroup,
    required this.onLongPress,
  }) : super(key: key);

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final messageText = message['message'] as String;
    final timestamp = message['timestamp'] as DateTime;
    final isRead = message['isRead'] as bool;
    final senderName = message['senderName'] as String?;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isCurrentUser && isGroup) ...[
              Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.only(right: 2.w, bottom: 1.h),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Text(
                    (senderName ?? 'U').substring(0, 1).toUpperCase(),
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 75.w,
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(isCurrentUser ? 18 : 4),
                    bottomRight: Radius.circular(isCurrentUser ? 4 : 18),
                  ),
                  border: !isCurrentUser
                      ? Border.all(
                          color: AppTheme.lightTheme.dividerColor,
                          width: 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isCurrentUser && isGroup && senderName != null) ...[
                      Text(
                        senderName,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                    ],
                    Text(
                      messageText,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isCurrentUser
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _formatTime(timestamp),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isCurrentUser
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                    .withValues(alpha: 0.7)
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                        if (isCurrentUser) ...[
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: isRead ? 'done_all' : 'done',
                            color: isRead
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : AppTheme.lightTheme.colorScheme.onPrimary
                                    .withValues(alpha: 0.7),
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
