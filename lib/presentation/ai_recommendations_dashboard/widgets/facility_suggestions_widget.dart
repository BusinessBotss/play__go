import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FacilitySuggestionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> facilities;
  final Function(String, String) onFeedback;

  const FacilitySuggestionsWidget({
    Key? key,
    required this.facilities,
    required this.onFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (facilities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64.h,
              color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No facility suggestions available',
              style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your location or check back later',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: facilities.length,
      itemBuilder: (context, index) {
        final facility = facilities[index];
        return _FacilitySuggestionCard(
          facility: facility,
          onFeedback: onFeedback);
      });
  }
}

class _FacilitySuggestionCard extends StatelessWidget {
  final Map<String, dynamic> facility;
  final Function(String, String) onFeedback;

  const _FacilitySuggestionCard({
    Key? key,
    required this.facility,
    required this.onFeedback,
  }) : super(key: key);

  void _bookFacility(BuildContext context) {
    // Navigate to booking screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ${facility['name']}...'),
        duration: const Duration(seconds: 2)));
  }

  void _viewFacilityDetails(BuildContext context) {
    // Navigate to facility details
    Navigator.pushNamed(context, '/facility-details', arguments: facility);
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
          // Facility Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              facility['imageUrl'],
              width: double.infinity,
              height: 160.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 160.h,
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()));
              },
              errorBuilder: (context, url, error) => Container(
                width: double.infinity,
                height: 160.h,
                color: Colors.grey.shade200,
                child: const Icon(Icons.error)),
            ),
          ),
          
          // Facility Details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            facility['name'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600)),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight.withAlpha(26)),
                            child: Text(
                              facility['type'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w500))),
                        ])),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16.h,
                              color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              facility['rating'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600)),
                          ]),
                        SizedBox(height: 4.h),
                        Text(
                          facility['priceRange'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600)),
                      ]),
                  ]),
                
                SizedBox(height: 12.h),
                
                // Location and Distance
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 16.h,
                      color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(
                      facility['distance'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600)),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.access_time,
                      size: 16.h,
                      color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(
                      facility['availability'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600)),
                  ]),
                
                SizedBox(height: 12.h),
                
                // Amenities
                if (facility['amenities'] != null && facility['amenities'].isNotEmpty) ...[
                  Text(
                    'Amenities:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: (facility['amenities'] as List<String>).map((amenity) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryLight.withAlpha(26)),
                        child: Text(
                          amenity,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryLight,
                            fontWeight: FontWeight.w500)));
                    }).toList()),
                  SizedBox(height: 16.h),
                ],
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _bookFacility(context),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.book_online, size: 16.h),
                            SizedBox(width: 8.w),
                            const Text('Book Now'),
                          ]))),
                    SizedBox(width: 12.w),
                    OutlinedButton(
                      onPressed: () => _viewFacilityDetails(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        shape: RoundedRectangleBorder()),
                      child: const Text('Details')),
                    SizedBox(width: 8.w),
                    OutlinedButton(
                      onPressed: () => onFeedback(facility['id'], 'not_interested'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        shape: RoundedRectangleBorder()),
                      child: Icon(
                        Icons.close,
                        size: 16.h)),
                  ]),
              ])),
        ]));
  }
}