import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final Function(bool) onTyping;

  const MessageInputWidget({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onTyping,
  }) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  bool _isTyping = false;
  bool _showSendButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;

    if (hasText != _showSendButton) {
      setState(() {
        _showSendButton = hasText;
      });
    }

    if (hasText && !_isTyping) {
      setState(() {
        _isTyping = true;
      });
      widget.onTyping(true);
    } else if (!hasText && _isTyping) {
      setState(() {
        _isTyping = false;
      });
      widget.onTyping(false);
    }
  }

  void _sendMessage() {
    if (widget.controller.text.trim().isNotEmpty) {
      widget.onSend(widget.controller.text);
      setState(() {
        _isTyping = false;
        _showSendButton = false;
      });
      widget.onTyping(false);
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: 'camera_alt',
                    label: 'Cámara',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    onTap: () {
                      Navigator.pop(context);
                      // Camera logic
                    },
                  ),
                  _buildAttachmentOption(
                    icon: 'photo',
                    label: 'Galería',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    onTap: () {
                      Navigator.pop(context);
                      // Gallery logic
                    },
                  ),
                  _buildAttachmentOption(
                    icon: 'location_on',
                    label: 'Ubicación',
                    color: AppTheme.lightTheme.colorScheme.error,
                    onTap: () {
                      Navigator.pop(context);
                      // Location logic
                    },
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 28,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            IconButton(
              onPressed: _showAttachmentOptions,
              icon: CustomIconWidget(
                iconName: 'attach_file',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 24,
              ),
            ),

            // Text input
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 20.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    suffixIcon: !_showSendButton
                        ? IconButton(
                            onPressed: () {
                              // Emoji picker logic
                            },
                            icon: CustomIconWidget(
                              iconName: 'emoji_emotions',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 24,
                            ),
                          )
                        : null,
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // Send/Voice button
            GestureDetector(
              onTap: _showSendButton ? _sendMessage : null,
              onLongPress: !_showSendButton
                  ? () {
                      // Voice recording logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mantén presionado para grabar audio'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  : null,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _showSendButton
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: _showSendButton ? 'send' : 'mic',
                    color: _showSendButton
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
