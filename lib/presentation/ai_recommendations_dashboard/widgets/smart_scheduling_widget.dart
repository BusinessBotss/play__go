import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SmartSchedulingWidget extends StatelessWidget {
  final List<Map<String, dynamic>> scheduleSuggestions;
  final Function(String, String) onFeedback;

  const SmartSchedulingWidget({
    Key? key,
    required this.scheduleSuggestions,
    required this.onFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scheduleSuggestions.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.schedule, size: 64.h, color: Colors.grey),
        SizedBox(height: 16.h),
        Text('No scheduling suggestions available',
            style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8.h),
        Text('Connect your calendar for personalized suggestions',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey)),
      ]));
    }

    return Column(children: [
      // Header with Calendar Integration
      Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
              color: AppTheme.primaryLight.withAlpha(26),
              border: Border.all(color: AppTheme.primaryLight.withAlpha(51))),
          child: Row(children: [
            Icon(Icons.calendar_today,
                color: AppTheme.primaryLight, size: 24.h),
            SizedBox(width: 12.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Smart Scheduling',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 4.h),
                  Text('AI-powered suggestions based on your calendar',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade600)),
                ])),
            OutlinedButton(
                onPressed: () {
                  // Open calendar integration
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Opening calendar integration...')));
                },
                style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    shape: RoundedRectangleBorder()),
                child: const Text('Connect')),
          ])),

      // Schedule Suggestions
      Expanded(
          child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: scheduleSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = scheduleSuggestions[index];
                return _ScheduleSuggestionCard(
                    suggestion: suggestion, onFeedback: onFeedback);
              })),
    ]);
  }
}

class _ScheduleSuggestionCard extends StatelessWidget {
  final Map<String, dynamic> suggestion;
  final Function(String, String) onFeedback;

  const _ScheduleSuggestionCard({
    Key? key,
    required this.suggestion,
    required this.onFeedback,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference < 7) return '${difference} days from now';

    return '${date.day}/${date.month}/${date.year}';
  }

  void _scheduleActivity(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Scheduling ${suggestion['activity']}...'),
        duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration:
            BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Activity Header
          Row(children: [
            Container(
                padding: EdgeInsets.all(8.w),
                decoration:
                    BoxDecoration(color: AppTheme.primaryLight.withAlpha(26)),
                child: Icon(Icons.event,
                    color: AppTheme.primaryLight, size: 20.h)),
            SizedBox(width: 12.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(suggestion['activity'],
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 4.h),
                  Text(suggestion['location'],
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade600)),
                ])),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration:
                    BoxDecoration(color: AppTheme.successLight.withAlpha(26)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.psychology,
                      size: 12.h, color: AppTheme.successLight),
                  SizedBox(width: 4.w),
                  Text('${suggestion['confidence']}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.successLight,
                          fontWeight: FontWeight.w600)),
                ])),
          ]),

          SizedBox(height: 16.h),

          // Time and Date Info
          Row(children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(color: Colors.blue.withAlpha(26)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade600)),
                          SizedBox(height: 4.h),
                          Text(_formatDate(suggestion['date']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                        ]))),
            SizedBox(width: 12.w),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration:
                        BoxDecoration(color: Colors.purple.withAlpha(26)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Time',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade600)),
                          SizedBox(height: 4.h),
                          Text(suggestion['time'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                        ]))),
          ]),

          SizedBox(height: 12.h),

          // Conflicts Warning
          if (suggestion['conflicts'] > 0) ...[
            Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: AppTheme.warningLight.withAlpha(26),
                    border:
                        Border.all(color: AppTheme.warningLight.withAlpha(77))),
                child: Row(children: [
                  Icon(Icons.warning_amber,
                      color: AppTheme.warningLight, size: 16.h),
                  SizedBox(width: 8.w),
                  Expanded(
                      child: Text(
                          '${suggestion['conflicts']} potential conflict(s) detected',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppTheme.warningLight))),
                ])),
            SizedBox(height: 12.h),
          ],

          // AI Insights
          Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: Colors.green.withAlpha(26)),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.lightbulb, color: Colors.green, size: 16.h),
                SizedBox(width: 8.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('AI Insight',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600)),
                      SizedBox(height: 4.h),
                      Text(
                          'Based on your activity patterns, this is an optimal time for ${suggestion['activity'].toLowerCase()}.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.green)),
                    ])),
              ])),

          SizedBox(height: 16.h),

          // Action Buttons
          Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () => _scheduleActivity(context),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder()),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.help_outline, size: 16.h),
                          SizedBox(width: 8.w),
                          const Text('Schedule'),
                        ]))),
            SizedBox(width: 12.w),
            OutlinedButton(
                onPressed: () => onFeedback(suggestion['id'], 'thumbs_up'),
                style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                child: Icon(Icons.thumb_up, size: 16.h)),
            SizedBox(width: 8.w),
            OutlinedButton(
                onPressed: () => onFeedback(suggestion['id'], 'not_interested'),
                style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                child: Icon(Icons.close, size: 16.h)),
          ]),
        ]));
  }
}
