import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AiSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const AiSettingsWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<AiSettingsWidget> createState() => _AiSettingsWidgetState();
}

class _AiSettingsWidgetState extends State<AiSettingsWidget> {
  bool _personalizedRecommendations = true;
  bool _locationBasedSuggestions = true;
  bool _calendarIntegration = false;
  bool _socialRecommendations = true;
  bool _priceBasedFiltering = false;
  bool _skillMatchingEnabled = true;
  bool _weatherIntegration = false;
  bool _pushNotifications = true;
  
  double _recommendationFrequency = 3.0; // Daily
  double _diversityLevel = 2.0; // Medium
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'AI Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600))),
                Icon(
                  Icons.psychology,
                  color: AppTheme.primaryLight,
                  size: 24.h),
              ])),
          
          // Settings Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personalization Section
                  _SectionHeader(
                    title: 'Personalization',
                    icon: Icons.person),
                  
                  _SettingsItem(
                    title: 'Personalized Recommendations',
                    subtitle: 'Get recommendations based on your activity',
                    value: _personalizedRecommendations,
                    onChanged: (value) {
                      setState(() {
                        _personalizedRecommendations = value;
                      });
                    }),
                  
                  _SettingsItem(
                    title: 'Location-Based Suggestions',
                    subtitle: 'Include nearby events and facilities',
                    value: _locationBasedSuggestions,
                    onChanged: (value) {
                      setState(() {
                        _locationBasedSuggestions = value;
                      });
                    }),
                  
                  _SettingsItem(
                    title: 'Calendar Integration',
                    subtitle: 'Sync with calendar for smart scheduling',
                    value: _calendarIntegration,
                    onChanged: (value) {
                      setState(() {
                        _calendarIntegration = value;
                      });
                    }),
                  
                  SizedBox(height: 24.h),
                  
                  // Matching Section
                  _SectionHeader(
                    title: 'Matching & Discovery',
                    icon: Icons.search),
                  
                  _SettingsItem(
                    title: 'Social Recommendations',
                    subtitle: 'Include recommendations from friends',
                    value: _socialRecommendations,
                    onChanged: (value) {
                      setState(() {
                        _socialRecommendations = value;
                      });
                    }),
                  
                  _SettingsItem(
                    title: 'Skill-Based Matching',
                    subtitle: 'Match with players of similar skill level',
                    value: _skillMatchingEnabled,
                    onChanged: (value) {
                      setState(() {
                        _skillMatchingEnabled = value;
                      });
                    }),
                  
                  _SettingsItem(
                    title: 'Price-Based Filtering',
                    subtitle: 'Filter recommendations by price range',
                    value: _priceBasedFiltering,
                    onChanged: (value) {
                      setState(() {
                        _priceBasedFiltering = value;
                      });
                    }),
                  
                  SizedBox(height: 24.h),
                  
                  // External Integration Section
                  _SectionHeader(
                    title: 'External Integration',
                    icon: Icons.extension),
                  
                  _SettingsItem(
                    title: 'Weather Integration',
                    subtitle: 'Consider weather for outdoor activities',
                    value: _weatherIntegration,
                    onChanged: (value) {
                      setState(() {
                        _weatherIntegration = value;
                      });
                    }),
                  
                  _SettingsItem(
                    title: 'Push Notifications',
                    subtitle: 'Get notified about new recommendations',
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    }),
                  
                  SizedBox(height: 24.h),
                  
                  // Recommendation Frequency
                  _SectionHeader(
                    title: 'Recommendation Frequency',
                    icon: Icons.schedule),
                  
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How often would you like new recommendations?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500)),
                        SizedBox(height: 12.h),
                        Slider(
                          value: _recommendationFrequency,
                          min: 1.0,
                          max: 5.0,
                          divisions: 4,
                          label: _getFrequencyLabel(_recommendationFrequency),
                          onChanged: (value) {
                            setState(() {
                              _recommendationFrequency = value;
                            });
                          }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Less frequent',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600)),
                            Text(
                              'More frequent',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600)),
                          ]),
                      ])),
                  
                  SizedBox(height: 20.h),
                  
                  // Diversity Level
                  _SectionHeader(
                    title: 'Recommendation Diversity',
                    icon: Icons.tune),
                  
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How diverse should your recommendations be?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500)),
                        SizedBox(height: 12.h),
                        Slider(
                          value: _diversityLevel,
                          min: 1.0,
                          max: 3.0,
                          divisions: 2,
                          label: _getDiversityLabel(_diversityLevel),
                          onChanged: (value) {
                            setState(() {
                              _diversityLevel = value;
                            });
                          }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Similar to past',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600)),
                            Text(
                              'Very diverse',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600)),
                          ]),
                      ])),
                  
                  SizedBox(height: 24.h),
                  
                  // Data & Privacy
                  _SectionHeader(
                    title: 'Data & Privacy',
                    icon: Icons.privacy_tip),
                  
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      
                      border: Border.all(color: Colors.blue.shade200)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 20.h),
                            SizedBox(width: 8.w),
                            Text(
                              'Data Usage',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800)),
                          ]),
                        SizedBox(height: 8.h),
                        Text(
                          'Your data is processed locally and used only to improve recommendations. No personal information is shared with third parties.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade800)),
                      ])),
                  
                  SizedBox(height: 16.h),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Clear all AI data
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Clear AI Data'),
                                content: const Text(
                                  'This will reset all AI learning and recommendations. Are you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('AI data cleared')));
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppTheme.errorLight),
                                    child: const Text('Clear')),
                                ]));
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder()),
                          child: const Text('Clear AI Data'))),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Save settings
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('AI settings saved')));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder()),
                          child: const Text('Save Settings'))),
                    ]),
                ]))),
        ]));
  }
  
  String _getFrequencyLabel(double value) {
    switch (value.round()) {
      case 1: return 'Weekly';
      case 2: return 'Bi-weekly';
      case 3: return 'Daily';
      case 4: return 'Twice daily';
      case 5: return 'Real-time';
      default: return 'Daily';
    }
  }
  
  String _getDiversityLabel(double value) {
    switch (value.round()) {
      case 1: return 'Low';
      case 2: return 'Medium';
      case 3: return 'High';
      default: return 'Medium';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryLight,
            size: 20.h),
          SizedBox(width: 8.w),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600)),
        ]));
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SettingsItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500)),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600)),
              ])),
          Switch(
            value: value,
            onChanged: onChanged),
        ]));
  }
}