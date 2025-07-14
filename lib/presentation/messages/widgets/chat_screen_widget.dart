import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './message_bubble_widget.dart';
import './message_input_widget.dart';

class ChatScreenWidget extends StatefulWidget {
  final Map<String, dynamic> conversation;
  final int currentUserId;

  const ChatScreenWidget({
    Key? key,
    required this.conversation,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ChatScreenWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  late List<Map<String, dynamic>> _messages;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages =
        List<Map<String, dynamic>>.from(widget.conversation['messages'] ?? []);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final newMessage = {
      "id": _messages.length + 1,
      "senderId": widget.currentUserId,
      "message": message.trim(),
      "timestamp": DateTime.now(),
      "isRead": false,
      "messageType": "text"
    };

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    _scrollToBottom();

    // Simulate response after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        final responseMessage = {
          "id": _messages.length + 1,
          "senderId": widget.conversation['id'],
          "message": "¡Gracias por tu mensaje!",
          "timestamp": DateTime.now(),
          "isRead": false,
          "messageType": "text"
        };

        setState(() {
          _messages.add(responseMessage);
        });

        _scrollToBottom();
      }
    });
  }

  void _onMessageLongPress(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text('Copiar'),
                onTap: () {
                  Navigator.pop(context);
                  // Copy message logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mensaje copiado')),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'reply',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text('Responder'),
                onTap: () {
                  Navigator.pop(context);
                  // Reply logic
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'forward',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text('Reenviar'),
                onTap: () {
                  Navigator.pop(context);
                  // Forward logic
                },
              ),
              if (message['senderId'] == widget.currentUserId)
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                  title: Text(
                    'Eliminar',
                    style:
                        TextStyle(color: AppTheme.lightTheme.colorScheme.error),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _messages
                          .removeWhere((msg) => msg['id'] == message['id']);
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'En línea';
    } else if (difference.inMinutes < 60) {
      return 'Visto hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Visto hace ${difference.inHours}h';
    } else {
      return 'Visto hace ${difference.inDays}d';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOnline = widget.conversation['isOnline'] as bool;
    final bool isGroup = widget.conversation['isGroup'] ?? false;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: widget.conversation['avatar'] as String,
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation['contactName'] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isGroup)
                    Text(
                      isOnline
                          ? 'En línea'
                          : _formatLastSeen(
                              widget.conversation['lastSeen'] as DateTime),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isOnline
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Video call logic
            },
            icon: CustomIconWidget(
              iconName: 'videocam',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              // Voice call logic
            },
            icon: CustomIconWidget(
              iconName: 'call',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.pushNamed(context, '/user-profile');
                  break;
                case 'mute':
                  // Mute logic
                  break;
                case 'block':
                  // Block logic
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Ver perfil'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'notifications_off',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Silenciar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'block',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Bloquear',
                      style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'chat_bubble_outline',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Inicia la conversación',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isCurrentUser =
                          message['senderId'] == widget.currentUserId;
                      final showTimestamp = index == 0 ||
                          (index > 0 &&
                              (message['timestamp'] as DateTime)
                                      .difference(_messages[index - 1]
                                          ['timestamp'] as DateTime)
                                      .inMinutes >
                                  5);

                      return Column(
                        children: [
                          if (showTimestamp)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 1.h),
                              child: Text(
                                _formatMessageTimestamp(
                                    message['timestamp'] as DateTime),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          MessageBubbleWidget(
                            message: message,
                            isCurrentUser: isCurrentUser,
                            isGroup: isGroup,
                            onLongPress: () => _onMessageLongPress(message),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          MessageInputWidget(
            controller: _messageController,
            onSend: _sendMessage,
            onTyping: (isTyping) {
              setState(() {
                _isTyping = isTyping;
              });
            },
          ),
        ],
      ),
    );
  }

  String _formatMessageTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Ayer ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
      } else {
        return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
      }
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
