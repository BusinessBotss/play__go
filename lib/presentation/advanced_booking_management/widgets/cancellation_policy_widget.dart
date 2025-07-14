import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancellationPolicyWidget extends StatefulWidget {
  final String? facilityId;
  final DateTime bookingDate;
  final double totalPrice;

  const CancellationPolicyWidget({
    Key? key,
    this.facilityId,
    required this.bookingDate,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<CancellationPolicyWidget> createState() =>
      _CancellationPolicyWidgetState();
}

class _CancellationPolicyWidgetState extends State<CancellationPolicyWidget> {
  bool isExpanded = false;
  List<CancellationTier> cancellationTiers = [];

  @override
  void initState() {
    super.initState();
    _loadCancellationPolicy();
  }

  void _loadCancellationPolicy() {
    // This would typically load from facility-specific policies
    // For now, we'll use a standard policy
    cancellationTiers = [
      CancellationTier(
        timeFrame: 'More than 24 hours',
        refundPercentage: 100,
        fee: 0,
        description: 'Full refund with no cancellation fee',
      ),
      CancellationTier(
        timeFrame: '12-24 hours',
        refundPercentage: 75,
        fee: 5,
        description: 'Partial refund with small cancellation fee',
      ),
      CancellationTier(
        timeFrame: '6-12 hours',
        refundPercentage: 50,
        fee: 10,
        description: 'Half refund with moderate cancellation fee',
      ),
      CancellationTier(
        timeFrame: '2-6 hours',
        refundPercentage: 25,
        fee: 15,
        description: 'Limited refund with higher cancellation fee',
      ),
      CancellationTier(
        timeFrame: 'Less than 2 hours',
        refundPercentage: 0,
        fee: 20,
        description: 'No refund, full cancellation fee applies',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cancellation Policy',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24,
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            // Current refund calculation
            _buildCurrentRefundInfo(),

            if (isExpanded) ...[
              SizedBox(height: 16),
              _buildDetailedPolicy(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentRefundInfo() {
    DateTime now = DateTime.now();
    Duration timeDifference = widget.bookingDate.difference(now);

    CancellationTier currentTier = _getCurrentTier(timeDifference);
    double refundAmount =
        (widget.totalPrice * currentTier.refundPercentage / 100) -
            currentTier.fee;
    refundAmount = refundAmount < 0 ? 0 : refundAmount;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getTierColor(currentTier).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getTierColor(currentTier),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getTierIcon(currentTier),
            size: 20,
            color: _getTierColor(currentTier),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Refund: \$${refundAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getTierColor(currentTier),
                  ),
                ),
                Text(
                  'If cancelled now: ${currentTier.refundPercentage}% refund',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                if (currentTier.fee > 0)
                  Text(
                    'Cancellation fee: \$${currentTier.fee.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Cancellation Terms',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12),

        ...cancellationTiers.map((tier) => _buildPolicyTile(tier)),

        SizedBox(height: 16),

        // Additional terms
        _buildAdditionalTerms(),
      ],
    );
  }

  Widget _buildPolicyTile(CancellationTier tier) {
    DateTime now = DateTime.now();
    Duration timeDifference = widget.bookingDate.difference(now);
    bool isCurrentTier = _getCurrentTier(timeDifference) == tier;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isCurrentTier ? _getTierColor(tier).withValues(alpha: 0.1) : null,
        border: Border.all(
          color: isCurrentTier ? _getTierColor(tier) : Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getTierIcon(tier),
            size: 18,
            color: isCurrentTier ? _getTierColor(tier) : Colors.grey.shade600,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tier.timeFrame,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isCurrentTier ? _getTierColor(tier) : Colors.black,
                  ),
                ),
                Text(
                  tier.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${tier.refundPercentage}% refund',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (tier.fee > 0) ...[
                      SizedBox(width: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '\$${tier.fee.toStringAsFixed(2)} fee',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalTerms() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Terms',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          _buildTermItem('• Refunds are processed within 5-7 business days'),
          _buildTermItem(
              '• Weather-related cancellations may have different policies'),
          _buildTermItem(
              '• Group bookings may have special cancellation terms'),
          _buildTermItem('• Recurring bookings can be cancelled individually'),
          _buildTermItem('• Medical emergencies may qualify for full refund'),
        ],
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  CancellationTier _getCurrentTier(Duration timeDifference) {
    double hoursUntilBooking = timeDifference.inMinutes / 60.0;

    if (hoursUntilBooking > 24) {
      return cancellationTiers[0];
    } else if (hoursUntilBooking > 12) {
      return cancellationTiers[1];
    } else if (hoursUntilBooking > 6) {
      return cancellationTiers[2];
    } else if (hoursUntilBooking > 2) {
      return cancellationTiers[3];
    } else {
      return cancellationTiers[4];
    }
  }

  Color _getTierColor(CancellationTier tier) {
    if (tier.refundPercentage >= 75) return Colors.green;
    if (tier.refundPercentage >= 50) return Colors.orange;
    if (tier.refundPercentage >= 25) return Colors.red;
    return Colors.grey;
  }

  IconData _getTierIcon(CancellationTier tier) {
    if (tier.refundPercentage >= 75) return Icons.check_circle;
    if (tier.refundPercentage >= 50) return Icons.warning;
    if (tier.refundPercentage >= 25) return Icons.error;
    return Icons.cancel;
  }
}

class CancellationTier {
  final String timeFrame;
  final int refundPercentage;
  final double fee;
  final String description;

  CancellationTier({
    required this.timeFrame,
    required this.refundPercentage,
    required this.fee,
    required this.description,
  });
}
