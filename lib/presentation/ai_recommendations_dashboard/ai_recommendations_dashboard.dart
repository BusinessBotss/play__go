import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/ai_settings_widget.dart';
import './widgets/event_recommendations_widget.dart';
import './widgets/facility_suggestions_widget.dart';
import './widgets/hero_section_widget.dart';
import './widgets/player_matchmaking_widget.dart';
import './widgets/recommendation_filters_widget.dart';
import './widgets/smart_scheduling_widget.dart';

class AiRecommendationsDashboard extends StatefulWidget {
  const AiRecommendationsDashboard({Key? key}) : super(key: key);

  @override
  State<AiRecommendationsDashboard> createState() =>
      _AiRecommendationsDashboardState();
}

class _AiRecommendationsDashboardState extends State<AiRecommendationsDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // User data
  String _userName = 'Alex Johnson';
  int _recommendationScore = 85;

  // Filter state
  Map<String, dynamic> _filters = {
    'sports': ['Football', 'Basketball', 'Tennis'],
    'distance': 10.0,
    'skillLevel': 'Intermediate',
    'timePreference': 'Evening',
  };

  // Recommendation data
  List<Map<String, dynamic>> _eventRecommendations = [];
  List<Map<String, dynamic>> _playerMatches = [];
  List<Map<String, dynamic>> _facilitySuggestions = [];
  List<Map<String, dynamic>> _scheduleSuggestions = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _eventRecommendations = _generateEventRecommendations();
        _playerMatches = _generatePlayerMatches();
        _facilitySuggestions = _generateFacilitySuggestions();
        _scheduleSuggestions = _generateScheduleSuggestions();
        _isLoading = false;
      });
    });
  }

  List<Map<String, dynamic>> _generateEventRecommendations() {
    final sports = ['Football', 'Basketball', 'Tennis', 'Soccer', 'Volleyball'];
    final locations = [
      'Central Park',
      'Sports Complex',
      'Community Center',
      'Local Stadium'
    ];
    final times = ['Morning', 'Afternoon', 'Evening'];

    return List.generate(10, (index) {
      final random = Random();
      return {
        'id': 'event_$index',
        'title': '${sports[random.nextInt(sports.length)]} Match',
        'sport': sports[random.nextInt(sports.length)],
        'location': locations[random.nextInt(locations.length)],
        'time': times[random.nextInt(times.length)],
        'distance': '${random.nextInt(15) + 1}km',
        'participants': '${random.nextInt(20) + 5}/${random.nextInt(10) + 20}',
        'skillLevel': [
          'Beginner',
          'Intermediate',
          'Advanced'
        ][random.nextInt(3)],
        'relevanceScore': random.nextInt(30) + 70,
        'imageUrl':
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        'organizer': 'Sports Club ${random.nextInt(5) + 1}',
        'price': random.nextBool() ? 'Free' : '\$${random.nextInt(20) + 5}',
      };
    });
  }

  List<Map<String, dynamic>> _generatePlayerMatches() {
    final names = [
      'Emma Wilson',
      'Michael Chen',
      'Sarah Davis',
      'David Kumar',
      'Lisa Brown'
    ];
    final sports = ['Football', 'Basketball', 'Tennis', 'Soccer', 'Volleyball'];

    return List.generate(8, (index) {
      final random = Random();
      return {
        'id': 'player_$index',
        'name': names[random.nextInt(names.length)],
        'sport': sports[random.nextInt(sports.length)],
        'skillLevel': [
          'Beginner',
          'Intermediate',
          'Advanced'
        ][random.nextInt(3)],
        'distance': '${random.nextInt(10) + 1}km',
        'matchScore': random.nextInt(30) + 70,
        'availability': ['Weekdays', 'Weekends', 'Evenings'][random.nextInt(3)],
        'imageUrl':
            'https://images.unsplash.com/photo-1494790108755-2616b2e4d15a?w=400&h=400&fit=crop',
        'mutualConnections': random.nextInt(5) + 1,
        'rating': (random.nextDouble() * 2 + 3).toStringAsFixed(1),
      };
    });
  }

  List<Map<String, dynamic>> _generateFacilitySuggestions() {
    final facilities = [
      'Sports Complex A',
      'Community Center B',
      'Elite Gym C',
      'Local Stadium D'
    ];
    final types = ['Gym', 'Court', 'Field', 'Pool'];

    return List.generate(6, (index) {
      final random = Random();
      return {
        'id': 'facility_$index',
        'name': facilities[random.nextInt(facilities.length)],
        'type': types[random.nextInt(types.length)],
        'distance': '${random.nextInt(15) + 1}km',
        'rating': (random.nextDouble() * 2 + 3).toStringAsFixed(1),
        'priceRange':
            '\$${random.nextInt(20) + 10}-\$${random.nextInt(30) + 30}',
        'availability':
            '${random.nextInt(12) + 1}/${random.nextInt(12) + 12} slots',
        'imageUrl':
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop',
        'amenities': ['Parking', 'Changing Rooms', 'Equipment', 'Showers']
            .sublist(0, random.nextInt(4) + 1),
      };
    });
  }

  List<Map<String, dynamic>> _generateScheduleSuggestions() {
    final activities = [
      'Football Practice',
      'Basketball Game',
      'Tennis Match',
      'Gym Session'
    ];
    final times = ['9:00 AM', '2:00 PM', '6:00 PM', '8:00 PM'];

    return List.generate(4, (index) {
      final random = Random();
      return {
        'id': 'schedule_$index',
        'activity': activities[random.nextInt(activities.length)],
        'time': times[random.nextInt(times.length)],
        'date': DateTime.now().add(Duration(days: random.nextInt(7) + 1)),
        'confidence': random.nextInt(30) + 70,
        'conflicts': random.nextInt(2),
        'location': [
          'Central Park',
          'Sports Complex',
          'Community Center'
        ][random.nextInt(3)],
      };
    });
  }

  Future<void> _refreshRecommendations() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with new data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _eventRecommendations = _generateEventRecommendations();
      _playerMatches = _generatePlayerMatches();
      _facilitySuggestions = _generateFacilitySuggestions();
      _scheduleSuggestions = _generateScheduleSuggestions();
      _recommendationScore = Random().nextInt(20) + 80;
      _isLoading = false;
    });
  }

  void _onFilterChanged(Map<String, dynamic> newFilters) {
    setState(() {
      _filters = newFilters;
    });
    _refreshRecommendations();
  }

  void _onRecommendationFeedback(String itemId, String feedbackType) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Feedback recorded: $feedbackType'),
        duration: const Duration(seconds: 2)));

    // In a real app, this would send feedback to the AI service
    // Remove item from recommendations if "not interested"
    if (feedbackType == 'not_interested') {
      setState(() {
        _eventRecommendations.removeWhere((item) => item['id'] == itemId);
        _playerMatches.removeWhere((item) => item['id'] == itemId);
        _facilitySuggestions.removeWhere((item) => item['id'] == itemId);
      });
    }
  }

  void _openAISettings() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AiSettingsWidget(
            currentFilters: _filters, onFiltersChanged: _onFilterChanged));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('AI Recommendations'),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: const Icon(Icons.settings), onPressed: _openAISettings),
            ]),
        body: RefreshIndicator(
            onRefresh: _refreshRecommendations,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(controller: _scrollController, slivers: [
                    SliverToBoxAdapter(
                        child: Column(children: [
                      // Hero Section
                      HeroSectionWidget(
                          userName: _userName,
                          recommendationScore: _recommendationScore),

                      SizedBox(height: 16.h),

                      // Filters
                      RecommendationFiltersWidget(
                          currentFilters: _filters,
                          onFiltersChanged: _onFilterChanged),

                      SizedBox(height: 20.h),

                      // Tab Bar
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration:
                              BoxDecoration(color: Theme.of(context).cardColor),
                          child: TabBar(
                              controller: _tabController,
                              tabs: [
                                Tab(
                                    icon: Icon(Icons.event, size: 20.h),
                                    text: 'Events'),
                                Tab(
                                    icon: Icon(Icons.people, size: 20.h),
                                    text: 'Players'),
                                Tab(
                                    icon: Icon(Icons.location_on, size: 20.h),
                                    text: 'Facilities'),
                                Tab(
                                    icon: Icon(Icons.schedule, size: 20.h),
                                    text: 'Schedule'),
                              ],
                              labelColor: AppTheme.primaryLight,
                              unselectedLabelColor: Colors.grey,
                              indicator: BoxDecoration(
                                  color: AppTheme.primaryLight.withAlpha(26)))),
                    ])),
                    SliverFillRemaining(
                        child:
                            TabBarView(controller: _tabController, children: [
                      // Events Tab
                      EventRecommendationsWidget(
                          recommendations: _eventRecommendations,
                          onFeedback: _onRecommendationFeedback),

                      // Players Tab
                      PlayerMatchmakingWidget(
                          playerMatches: _playerMatches,
                          onFeedback: _onRecommendationFeedback),

                      // Facilities Tab
                      FacilitySuggestionsWidget(
                          facilities: _facilitySuggestions,
                          onFeedback: _onRecommendationFeedback),

                      // Schedule Tab
                      SmartSchedulingWidget(
                          scheduleSuggestions: _scheduleSuggestions,
                          onFeedback: _onRecommendationFeedback),
                    ])),
                  ])));
  }
}
