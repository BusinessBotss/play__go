import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_screen_widget.dart';
import './widgets/conversation_list_item_widget.dart';
import './widgets/search_bar_widget.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  String _searchQuery = '';
  int? _selectedConversationIndex;
  bool _isLoading = false;

  // Mock conversations data
  final List<Map<String, dynamic>> _conversations = [
    {
      "id": 1,
      "contactName": "Carlos Mendoza",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage": "¿Vienes al partido de fútbol mañana?",
      "timestamp": DateTime.now().subtract(Duration(minutes: 15)),
      "unreadCount": 2,
      "isOnline": true,
      "isTyping": false,
      "lastSeen": DateTime.now().subtract(Duration(minutes: 5)),
      "messages": [
        {
          "id": 1,
          "senderId": 2,
          "message": "¡Hola! ¿Cómo estás?",
          "timestamp": DateTime.now().subtract(Duration(hours: 2)),
          "isRead": true,
          "messageType": "text"
        },
        {
          "id": 2,
          "senderId": 1,
          "message": "¡Muy bien! ¿Y tú?",
          "timestamp": DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
          "isRead": true,
          "messageType": "text"
        },
        {
          "id": 3,
          "senderId": 2,
          "message": "¿Vienes al partido de fútbol mañana?",
          "timestamp": DateTime.now().subtract(Duration(minutes: 15)),
          "isRead": false,
          "messageType": "text"
        }
      ]
    },
    {
      "id": 2,
      "contactName": "María González",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage": "Perfecto, nos vemos en el gimnasio",
      "timestamp": DateTime.now().subtract(Duration(hours: 1)),
      "unreadCount": 0,
      "isOnline": false,
      "isTyping": false,
      "lastSeen": DateTime.now().subtract(Duration(hours: 3)),
      "messages": [
        {
          "id": 1,
          "senderId": 1,
          "message": "¿Quieres entrenar juntas esta tarde?",
          "timestamp": DateTime.now().subtract(Duration(hours: 2)),
          "isRead": true,
          "messageType": "text"
        },
        {
          "id": 2,
          "senderId": 3,
          "message": "¡Claro! ¿A qué hora?",
          "timestamp": DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
          "isRead": true,
          "messageType": "text"
        },
        {
          "id": 3,
          "senderId": 1,
          "message": "A las 6:00 PM",
          "timestamp": DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
          "isRead": true,
          "messageType": "text"
        },
        {
          "id": 4,
          "senderId": 3,
          "message": "Perfecto, nos vemos en el gimnasio",
          "timestamp": DateTime.now().subtract(Duration(hours: 1)),
          "isRead": true,
          "messageType": "text"
        }
      ]
    },
    {
      "id": 3,
      "contactName": "Equipo Baloncesto",
      "avatar":
          "https://images.pexels.com/photos/1752757/pexels-photo-1752757.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage": "Javier: El entrenamiento es a las 7:00",
      "timestamp": DateTime.now().subtract(Duration(hours: 3)),
      "unreadCount": 5,
      "isOnline": true,
      "isTyping": true,
      "lastSeen": DateTime.now(),
      "isGroup": true,
      "messages": [
        {
          "id": 1,
          "senderId": 4,
          "senderName": "Javier",
          "message": "¿Confirmamos el entrenamiento para hoy?",
          "timestamp": DateTime.now().subtract(Duration(hours: 4)),
          "isRead": true,
          "messageType": "text"
        },
        {
          "id": 2,
          "senderId": 5,
          "senderName": "Ana",
          "message": "Yo confirmo",
          "timestamp": DateTime.now().subtract(Duration(hours: 3, minutes: 45)),
          "isRead": true,
          "messageType": "text"
        },
        {
          "id": 3,
          "senderId": 4,
          "senderName": "Javier",
          "message": "El entrenamiento es a las 7:00",
          "timestamp": DateTime.now().subtract(Duration(hours: 3)),
          "isRead": false,
          "messageType": "text"
        }
      ]
    },
    {
      "id": 4,
      "contactName": "Luis Rodríguez",
      "avatar":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage": "Gracias por la invitación al torneo",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "unreadCount": 0,
      "isOnline": false,
      "isTyping": false,
      "lastSeen": DateTime.now().subtract(Duration(hours: 12)),
      "messages": [
        {
          "id": 1,
          "senderId": 1,
          "message": "¿Te interesa participar en el torneo de tenis?",
          "timestamp": DateTime.now().subtract(Duration(days: 1, hours: 2)),
          "isRead": true,
          "messageType": "text"
        },
        {
          "id": 2,
          "senderId": 6,
          "message": "Gracias por la invitación al torneo",
          "timestamp": DateTime.now().subtract(Duration(days: 1)),
          "isRead": true,
          "messageType": "text"
        }
      ]
    },
    {
      "id": 5,
      "contactName": "Sofia Martín",
      "avatar":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage": "¡Excelente clase de yoga!",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "unreadCount": 0,
      "isOnline": true,
      "isTyping": false,
      "lastSeen": DateTime.now().subtract(Duration(minutes: 30)),
      "messages": [
        {
          "id": 1,
          "senderId": 7,
          "message": "¡Excelente clase de yoga!",
          "timestamp": DateTime.now().subtract(Duration(days: 2)),
          "isRead": true,
          "messageType": "text"
        }
      ]
    }
  ];

  List<Map<String, dynamic>> get _filteredConversations {
    if (_searchQuery.isEmpty) {
      return _conversations;
    }
    return _conversations.where((conversation) {
      final name = (conversation['contactName'] as String).toLowerCase();
      final lastMessage = (conversation['lastMessage'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || lastMessage.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshConversations() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _openConversation(int index) {
    final conversation = _filteredConversations[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreenWidget(
          conversation: conversation,
          currentUserId: 1,
        ),
      ),
    );
  }

  void _archiveConversation(int index) {
    final conversation = _filteredConversations[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Conversación con ${conversation['contactName']} archivada'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            // Restore conversation logic
          },
        ),
      ),
    );
  }

  void _deleteConversation(int index) {
    final conversation = _filteredConversations[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar conversación'),
          content: Text(
              '¿Estás seguro de que quieres eliminar la conversación con ${conversation['contactName']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _conversations
                      .removeWhere((conv) => conv['id'] == conversation['id']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Conversación eliminada'),
                  ),
                );
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: _isSearching
            ? null
            : Text(
                'Mensajes',
                style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
              ),
        actions: [
          if (_isSearching)
            Expanded(
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onClear: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
              ),
            )
          else
            IconButton(
              onPressed: _toggleSearch,
              icon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          if (!_isSearching)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-event');
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching && _searchQuery.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Text(
                '${_filteredConversations.length} resultado${_filteredConversations.length != 1 ? 's' : ''}',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshConversations,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    )
                  : _filteredConversations.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'message',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                size: 64,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'No se encontraron conversaciones'
                                    : 'No hay mensajes',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'Intenta con otros términos de búsqueda'
                                    : 'Inicia una conversación para conectar con otros deportistas',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _filteredConversations.length,
                          itemBuilder: (context, index) {
                            final conversation = _filteredConversations[index];
                            return ConversationListItemWidget(
                              conversation: conversation,
                              onTap: () => _openConversation(index),
                              onArchive: () => _archiveConversation(index),
                              onDelete: () => _deleteConversation(index),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
