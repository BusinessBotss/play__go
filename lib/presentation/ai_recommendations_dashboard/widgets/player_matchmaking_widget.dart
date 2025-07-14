import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PlayerMatchmakingWidget extends StatelessWidget {
  final List<Map<String, dynamic>> playerMatches;
  final Function(String, String) onFeedback;

  const PlayerMatchmakingWidget({
    Key? key,
    required this.playerMatches,
    required this.onFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (playerMatches.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.people_outline, size: 64.h, color: Colors.grey),
        SizedBox(height: 16.h),
        Text('No player matches available',
            style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8.h),
        Text('Try adjusting your preferences or check back later',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey)),
      ]));
    }

    return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: playerMatches.length,
        itemBuilder: (context, index) {
          final player = playerMatches[index];
          return _PlayerMatchCard(player: player, onFeedback: onFeedback);
        });
  }
}

class _PlayerMatchCard extends StatelessWidget {
  final Map<String, dynamic> player;
  final Function(String, String) onFeedback;

  const _PlayerMatchCard({
    Key? key,
    required this.player,
    required this.onFeedback,
  }) : super(key: key);

  void _showPlayerProfile(BuildContext context) {
    Navigator.pushNamed(context, '/user-profile', arguments: player);
  }

  void _connectWithPlayer(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Connection request sent to ${player['name']}'),
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
          Row(children: [
            // Player Avatar
            Stack(children: [
              ClipRRect(
                  child: CachedNetworkImage(
                      imageUrl: player['imageUrl'],
                      width: 60.w,
                      height: 60.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                          width: 60.w,
                          height: 60.h,
                          color: Colors.grey.shade200,
                          child:
                              const Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => Container(
                          width: 60.w,
                          height: 60.h,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.person, size: 30.h)))),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                          color: AppTheme.successLight,
                          border: Border.all(color: Colors.white, width: 2)))),
            ]),

            SizedBox(width: 16.w),

            // Player Info
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Expanded(
                        child: Text(player['name'],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600))),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            color: AppTheme.primaryLight.withAlpha(26)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.psychology,
                              size: 12.h, color: AppTheme.primaryLight),
                          SizedBox(width: 4.w),
                          Text('${player['matchScore']}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: AppTheme.primaryLight,
                                      fontWeight: FontWeight.w600)),
                        ])),
                  ]),
                  SizedBox(height: 4.h),
                  Row(children: [
                    Icon(Icons.star, size: 16.h, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(player['rating'],
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey.shade600)),
                    SizedBox(width: 16.w),
                    Icon(Icons.place, size: 16.h, color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(player['distance'],
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey.shade600)),
                  ]),
                ])),
          ]),

          SizedBox(height: 16.h),

          // Player Stats
          Row(children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                        color: AppTheme.secondaryLight.withAlpha(26)),
                    child: Column(children: [
                      Text('Sport',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey.shade600)),
                      SizedBox(height: 4.h),
                      Text(player['sport'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ]))),
            SizedBox(width: 8.w),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(color: Colors.blue.withAlpha(26)),
                    child: Column(children: [
                      Text('Skill Level',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey.shade600)),
                      SizedBox(height: 4.h),
                      Text(player['skillLevel'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ]))),
            SizedBox(width: 8.w),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration:
                        BoxDecoration(color: Colors.purple.withAlpha(26)),
                    child: Column(children: [
                      Text('Availability',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey.shade600)),
                      SizedBox(height: 4.h),
                      Text(player['availability'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ]))),
          ]),

          SizedBox(height: 12.h),

          // Mutual Connections
          if (player['mutualConnections'] > 0) ...[
            Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(color: Colors.green.withAlpha(26)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.people, size: 16.h, color: Colors.green),
                  SizedBox(width: 8.w),
                  Text('${player['mutualConnections']} mutual connections',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green, fontWeight: FontWeight.w500)),
                ])),
            SizedBox(height: 12.h),
          ],

          // Action Buttons
          Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () => _connectWithPlayer(context),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder()),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add, size: 16.h),
                          SizedBox(width: 8.w),
                          const Text('Connect'),
                        ]))),
            SizedBox(width: 12.w),
            OutlinedButton(
                onPressed: () => _showPlayerProfile(context),
                style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                child: const Text('View Profile')),
            SizedBox(width: 8.w),
            OutlinedButton(
                onPressed: () => onFeedback(player['id'], 'not_interested'),
                style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                child: Icon(Icons.close, size: 16.h)),
          ]),
        ]));
  }
}