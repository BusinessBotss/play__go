import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class EventRecommendationsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;
  final Function(String, String) onFeedback;

  const EventRecommendationsWidget({
    Key? key,
    required this.recommendations,
    required this.onFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64.h,
              color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No event recommendations available',
              style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your filters or check back later',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey)),
          ]));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final event = recommendations[index];
        return _EventRecommendationCard(
          event: event,
          onFeedback: onFeedback);
      });
  }
}

class _EventRecommendationCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final Function(String, String) onFeedback;

  const _EventRecommendationCard({
    Key? key,
    required this.event,
    required this.onFeedback,
  }) : super(key: key);

  void _showFeedbackOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rate this recommendation',
              style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 20.h),
            _FeedbackOption(
              icon: Icons.thumb_up,
              label: 'Great recommendation',
              color: AppTheme.successLight,
              onTap: () {
                onFeedback(event['id'], 'thumbs_up');
                Navigator.pop(context);
              }),
            SizedBox(height: 12.h),
            _FeedbackOption(
              icon: Icons.thumb_down,
              label: 'Not interested',
              color: AppTheme.errorLight,
              onTap: () {
                onFeedback(event['id'], 'thumbs_down');
                Navigator.pop(context);
              }),
            SizedBox(height: 12.h),
            _FeedbackOption(
              icon: Icons.block,
              label: 'Not interested in this type',
              color: AppTheme.warningLight,
              onTap: () {
                onFeedback(event['id'], 'not_interested');
                Navigator.pop(context);
              }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image and Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(),
                child: Image.network(
                  event['imageUrl'],
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 180.h,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()));
                  },
                  errorBuilder: (context, url, error) => Container(
                    width: double.infinity,
                    height: 180.h,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error)),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 12.h),
                      SizedBox(width: 4.w),
                      Text(
                        '${event['relevanceScore']}%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(179)),
                  child: Text(
                    event['sport'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
                ),
              ),
            ],
          ),
          
          // Event Details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event['title'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600))),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight.withAlpha(26)),
                      child: Text(
                        event['price'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.successLight,
                          fontWeight: FontWeight.w600))),
                  ]),
                
                SizedBox(height: 12.h),
                
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16.h,
                      color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(
                      event['location'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600)),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.place,
                      size: 16.h,
                      color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(
                      event['distance'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600)),
                  ]),
                
                SizedBox(height: 8.h),
                
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16.h,
                      color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(
                      event['time'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600)),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.people,
                      size: 16.h,
                      color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(
                      event['participants'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600)),
                  ]),
                
                SizedBox(height: 12.h),
                
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryLight.withAlpha(26)),
                      child: Text(
                        event['skillLevel'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryLight,
                          fontWeight: FontWeight.w500))),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(26)),
                      child: Text(
                        event['organizer'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500))),
                  ]),
                
                SizedBox(height: 16.h),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/event-details', arguments: event);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder()),
                        child: const Text('View Details'))),
                    SizedBox(width: 12.w),
                    OutlinedButton(
                      onPressed: () => _showFeedbackOptions(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        shape: RoundedRectangleBorder()),
                      child: Icon(
                        Icons.more_horiz,
                        size: 20.h)),
                  ]),
              ])),
        ]));
  }
}

class _FeedbackOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FeedbackOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      onTap: onTap,
      shape: RoundedRectangleBorder());
  }
}