import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RecommendationFiltersWidget extends StatelessWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const RecommendationFiltersWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  void _showFiltersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FiltersModal(
        currentFilters: currentFilters,
        onFiltersChanged: onFiltersChanged));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                    'Recommendation Filters',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600))),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset')),
              ],
            ),
          ),
          
          // Filters Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sports Selection
                  Text(
                    'Sports',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _allSports.map((sport) {
                      final isSelected = (_tempFilters['sports'] as List).contains(sport);
                      return FilterChip(
                        label: Text(sport),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            final sports = _tempFilters['sports'] as List<String>;
                            if (selected) {
                              sports.add(sport);
                            } else {
                              sports.remove(sport);
                            }
                          });
                        },
                        selectedColor: AppTheme.primaryLight.withAlpha(51),
                        checkmarkColor: AppTheme.primaryLight);
                    }).toList()),
                  
                  SizedBox(height: 24.h),
                  
                  // Distance Slider
                  Text(
                    'Distance: ${_tempFilters['distance']} km',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Slider(
                    value: _tempFilters['distance']?.toDouble() ?? 10.0,
                    min: 1.0,
                    max: 50.0,
                    divisions: 49,
                    label: '${_tempFilters['distance']} km',
                    onChanged: (value) {
                      setState(() {
                        _tempFilters['distance'] = value.round();
                      });
                    }),
                  
                  SizedBox(height: 24.h),
                  
                  // Skill Level
                  Text(
                    'Skill Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _skillLevels.map((level) {
                      final isSelected = _tempFilters['skillLevel'] == level;
                      return FilterChip(
                        label: Text(level),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _tempFilters['skillLevel'] = selected ? level : null;
                          });
                        },
                        selectedColor: AppTheme.primaryLight.withAlpha(51),
                        checkmarkColor: AppTheme.primaryLight);
                    }).toList()),
                  
                  SizedBox(height: 24.h),
                  
                  // Time Preference
                  Text(
                    'Time Preference',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _timePreferences.map((time) {
                      final isSelected = _tempFilters['timePreference'] == time;
                      return FilterChip(
                        label: Text(time),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _tempFilters['timePreference'] = selected ? time : null;
                          });
                        },
                        selectedColor: AppTheme.primaryLight.withAlpha(51),
                        checkmarkColor: AppTheme.primaryLight);
                    }).toList()),
                ]))),
          
          // Apply Button
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 10,
                  offset: const Offset(0, -2)),
              ]),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder()),
                child: Text(
                  'Apply Filters',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600))))),
        ]));
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive 
              ? AppTheme.primaryLight.withAlpha(26)
              : Colors.grey.shade100,
          
          border: Border.all(
            color: isActive 
                ? AppTheme.primaryLight.withAlpha(77)
                : Colors.grey.shade300)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.h,
              color: isActive ? AppTheme.primaryLight : Colors.grey.shade600),
            SizedBox(width: 6.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive ? AppTheme.primaryLight : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
          ])));
  }
}

class _FiltersModal extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const _FiltersModal({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<_FiltersModal> createState() => _FiltersModalState();
}

class _FiltersModalState extends State<_FiltersModal> {
  late Map<String, dynamic> _tempFilters;
  
  final List<String> _allSports = [
    'Football', 'Basketball', 'Tennis', 'Soccer', 'Volleyball',
    'Baseball', 'Cricket', 'Golf', 'Swimming', 'Running',
    'Cycling', 'Boxing', 'Wrestling', 'Badminton', 'Squash'
  ];
  
  final List<String> _skillLevels = [
    'Beginner', 'Intermediate', 'Advanced', 'Professional'
  ];
  
  final List<String> _timePreferences = [
    'Morning', 'Afternoon', 'Evening', 'Night'
  ];

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.currentFilters);
  }

  void _applyFilters() {
    widget.onFiltersChanged(_tempFilters);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _tempFilters = {
        'sports': <String>[],
        'distance': 10.0,
        'skillLevel': null,
        'timePreference': null,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Recommendation Filters',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600))),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset')),
              ])),
          
          // Filters Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sports Selection
                  Text(
                    'Sports',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _allSports.map((sport) {
                      final isSelected = (_tempFilters['sports'] as List).contains(sport);
                      return FilterChip(
                        label: Text(sport),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            final sports = _tempFilters['sports'] as List<String>;
                            if (selected) {
                              sports.add(sport);
                            } else {
                              sports.remove(sport);
                            }
                          });
                        },
                        selectedColor: AppTheme.primaryLight.withAlpha(51),
                        checkmarkColor: AppTheme.primaryLight);
                    }).toList()),
                  
                  SizedBox(height: 24.h),
                  
                  // Distance Slider
                  Text(
                    'Distance: ${_tempFilters['distance']} km',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Slider(
                    value: _tempFilters['distance']?.toDouble() ?? 10.0,
                    min: 1.0,
                    max: 50.0,
                    divisions: 49,
                    label: '${_tempFilters['distance']} km',
                    onChanged: (value) {
                      setState(() {
                        _tempFilters['distance'] = value.round();
                      });
                    }),
                  
                  SizedBox(height: 24.h),
                  
                  // Skill Level
                  Text(
                    'Skill Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _skillLevels.map((level) {
                      final isSelected = _tempFilters['skillLevel'] == level;
                      return FilterChip(
                        label: Text(level),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _tempFilters['skillLevel'] = selected ? level : null;
                          });
                        },
                        selectedColor: AppTheme.primaryLight.withAlpha(51),
                        checkmarkColor: AppTheme.primaryLight);
                    }).toList()),
                  
                  SizedBox(height: 24.h),
                  
                  // Time Preference
                  Text(
                    'Time Preference',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _timePreferences.map((time) {
                      final isSelected = _tempFilters['timePreference'] == time;
                      return FilterChip(
                        label: Text(time),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _tempFilters['timePreference'] = selected ? time : null;
                          });
                        },
                        selectedColor: AppTheme.primaryLight.withAlpha(51),
                        checkmarkColor: AppTheme.primaryLight);
                    }).toList()),
                ]))),
          
          // Apply Button
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 10,
                  offset: const Offset(0, -2)),
              ]),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder()),
                child: Text(
                  'Apply Filters',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600))))),
        ]));
  }
}