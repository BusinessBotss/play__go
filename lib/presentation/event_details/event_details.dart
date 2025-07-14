import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/event_action_button_widget.dart';
import './widgets/event_description_widget.dart';
import './widgets/event_facility_widget.dart';
import './widgets/event_header_widget.dart';
import './widgets/event_info_widget.dart';
import './widgets/event_location_widget.dart';
import './widgets/event_organizer_widget.dart';
import './widgets/event_participants_widget.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyHeader = false;
  bool _isJoined = false;
  int _availableSpots = 8;
  final int _totalSpots = 20;

  // Mock event data
  final Map<String, dynamic> eventData = {
    "id": 1,
    "title": "Fútbol Amistoso - Calvià",
    "description":
        "Únete a nosotros para un partido de fútbol amistoso en el campo deportivo de Calvià. Perfecto para jugadores de todos los niveles que buscan diversión y ejercicio. Traed vuestras botas y ganas de jugar. Habrá agua disponible y un pequeño refrigerio después del partido.",
    "sport": "Fútbol",
    "date": "2025-07-15",
    "time": "18:00",
    "location": "Campo Deportivo Calvià",
    "address": "Carrer de sa Coma, 07184 Calvià, Illes Balears",
    "latitude": 39.5138,
    "longitude": 2.4731,
    "heroImage":
        "https://images.unsplash.com/photo-1574629810360-7efbbe195018?fm=jpg&q=80&w=1200",
    "organizer": {
      "id": 1,
      "name": "Carlos Martínez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 4.8,
      "eventsOrganized": 23,
      "isFollowing": false
    },
    "participants": [
      {
        "id": 1,
        "name": "Ana García",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": true
      },
      {
        "id": 2,
        "name": "Miguel López",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": false
      },
      {
        "id": 3,
        "name": "Laura Sánchez",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": true
      },
      {
        "id": 4,
        "name": "David Ruiz",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": false
      },
      {
        "id": 5,
        "name": "Carmen Vega",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": true
      },
      {
        "id": 6,
        "name": "Javier Moreno",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": false
      },
      {
        "id": 7,
        "name": "Isabel Torres",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": false
      },
      {
        "id": 8,
        "name": "Roberto Silva",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": true
      },
      {
        "id": 9,
        "name": "Elena Jiménez",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": false
      },
      {
        "id": 10,
        "name": "Fernando Castro",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": true
      },
      {
        "id": 11,
        "name": "Pilar Romero",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": false
      },
      {
        "id": 12,
        "name": "Antonio Herrera",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isFollowing": false
      }
    ],
    "facility": {
      "name": "Centro Deportivo Calvià",
      "rating": 4.5,
      "amenities": ["Vestuarios", "Aparcamiento", "Cafetería", "Duchas"],
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=80&w=800"
    },
    "price": "Gratis",
    "skillLevel": "Todos los niveles",
    "equipment": "Traer botas de fútbol",
    "notes": "Agua y refrigerio incluidos"
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showStickyHeader) {
      setState(() {
        _showStickyHeader = true;
      });
    } else if (_scrollController.offset <= 200 && _showStickyHeader) {
      setState(() {
        _showStickyHeader = false;
      });
    }
  }

  void _toggleJoinEvent() {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_isJoined) {
        _isJoined = false;
        _availableSpots++;
      } else {
        if (_availableSpots > 0) {
          _isJoined = true;
          _availableSpots--;
        }
      }
    });
  }

  void _shareEvent() {
    HapticFeedback.lightImpact();
    // Native share functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enlace del evento copiado'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addToCalendar() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Evento añadido al calendario'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _contactOrganizer() {
    Navigator.pushNamed(context, '/messages');
  }

  void _viewOrganizerProfile() {
    Navigator.pushNamed(context, '/user-profile');
  }

  void _viewParticipantProfile(Map<String, dynamic> participant) {
    Navigator.pushNamed(context, '/user-profile');
  }

  void _expandMap() {
    // Full map view would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo mapa completo...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: EventHeaderWidget(
                  eventData: eventData,
                  onShare: _shareEvent,
                  onBack: () => Navigator.pop(context),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventInfoWidget(
                        eventData: eventData,
                        availableSpots: _availableSpots,
                        totalSpots: _totalSpots,
                        onAddToCalendar: _addToCalendar,
                      ),
                      SizedBox(height: 3.h),
                      EventDescriptionWidget(
                        description: eventData["description"] as String,
                        price: eventData["price"] as String,
                        skillLevel: eventData["skillLevel"] as String,
                        equipment: eventData["equipment"] as String,
                        notes: eventData["notes"] as String,
                      ),
                      SizedBox(height: 3.h),
                      EventLocationWidget(
                        location: eventData["location"] as String,
                        address: eventData["address"] as String,
                        latitude: eventData["latitude"] as double,
                        longitude: eventData["longitude"] as double,
                        onExpandMap: _expandMap,
                      ),
                      SizedBox(height: 3.h),
                      EventOrganizerWidget(
                        organizer:
                            eventData["organizer"] as Map<String, dynamic>,
                        onContactOrganizer: _contactOrganizer,
                        onViewProfile: _viewOrganizerProfile,
                      ),
                      SizedBox(height: 3.h),
                      EventParticipantsWidget(
                        participants: (eventData["participants"] as List)
                            .cast<Map<String, dynamic>>(),
                        onParticipantTap: _viewParticipantProfile,
                      ),
                      if (eventData["facility"] != null) ...[
                        SizedBox(height: 3.h),
                        EventFacilityWidget(
                          facility:
                              eventData["facility"] as Map<String, dynamic>,
                        ),
                      ],
                      SizedBox(height: 12.h), // Space for fixed button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky header
          if (_showStickyHeader)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 4.w,
                  right: 4.w,
                  bottom: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 6.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventData["title"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${eventData["date"]} • ${eventData["time"]}",
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: _availableSpots > 0
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _isJoined
                            ? 'Unirse'
                            : (_availableSpots > 0 ? 'Unirse' : 'Completo'),
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: _availableSpots > 0
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Fixed action button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: EventActionButtonWidget(
              isJoined: _isJoined,
              availableSpots: _availableSpots,
              totalSpots: _totalSpots,
              onToggleJoin: _toggleJoinEvent,
            ),
          ),
        ],
      ),
    );
  }
}
