import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingConfirmationWidget extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final VoidCallback onShareBooking;
  final VoidCallback onAddToCalendar;
  final VoidCallback onViewQRCode;

  const BookingConfirmationWidget({
    Key? key,
    required this.bookingData,
    required this.onShareBooking,
    required this.onAddToCalendar,
    required this.onViewQRCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success header
          _buildSuccessHeader(),

          SizedBox(height: 20),

          // Booking details card
          _buildBookingDetailsCard(),

          SizedBox(height: 20),

          // QR Code for check-in
          _buildQRCodeSection(),

          SizedBox(height: 20),

          // Action buttons
          _buildActionButtons(context),

          SizedBox(height: 20),

          // Important information
          _buildImportantInfo(),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            size: 48,
            color: Colors.green,
          ),
          SizedBox(height: 12),
          Text(
            'Booking Confirmed!',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Your booking has been successfully confirmed',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard() {
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
            Text(
              'Booking Details',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),

            // Booking ID
            _buildDetailRow('Booking ID',
                'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'),

            // Date and Time
            _buildDetailRow(
                'Date', bookingData['date']?.toString().split(' ')[0] ?? 'N/A'),
            _buildDetailRow('Time', bookingData['timeSlot'] ?? 'N/A'),

            // Participants
            _buildDetailRow(
                'Participants', '${bookingData['participants'] ?? 1} people'),

            // Equipment
            if (bookingData['equipment'] != null &&
                (bookingData['equipment'] as List).isNotEmpty)
              _buildDetailRow(
                  'Equipment', (bookingData['equipment'] as List).join(', ')),

            // Special Requirements
            if (bookingData['specialRequirements'] != null &&
                bookingData['specialRequirements'].isNotEmpty)
              _buildDetailRow(
                  'Special Requirements', bookingData['specialRequirements']),

            // Payment Method
            _buildDetailRow('Payment Method',
                _getPaymentMethodName(bookingData['paymentMethod'])),

            // Recurring
            if (bookingData['isRecurring'] == true)
              _buildDetailRow(
                  'Recurring', 'Yes - ${_getRecurringDescription()}'),

            Divider(height: 24),

            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${_calculateTotalAmount().toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeSection() {
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
            Text(
              'Check-in QR Code',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: onViewQRCode,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: 60,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to view',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Present this QR code at the facility for quick check-in',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary actions
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onAddToCalendar,
                icon: Icon(Icons.calendar_today),
                label: Text('Add to Calendar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onShareBooking,
                icon: Icon(Icons.share),
                label: Text('Share'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        // Secondary actions
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  // Navigate to booking details
                  Navigator.pushNamed(
                    context,
                    '/booking-details',
                    arguments: bookingData,
                  );
                },
                icon: Icon(Icons.info_outline),
                label: Text('View Details'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  // Navigate to modify booking
                  Navigator.pushNamed(
                    context,
                    '/modify-booking',
                    arguments: bookingData,
                  );
                },
                icon: Icon(Icons.edit),
                label: Text('Modify'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImportantInfo() {
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
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  'Important Information',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoItem('Arrive 10 minutes early for check-in'),
            _buildInfoItem('Bring a valid ID for verification'),
            _buildInfoItem('Cancellation policy applies as per terms'),
            _buildInfoItem('Contact support for any changes or questions'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reminder: You\'ll receive notifications 24 hours and 1 hour before your booking',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName(String? method) {
    switch (method) {
      case 'card':
        return 'Credit/Debit Card';
      case 'paypal':
        return 'PayPal';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      case 'bank_transfer':
        return 'Bank Transfer';
      default:
        return 'Unknown';
    }
  }

  String _getRecurringDescription() {
    Map<String, dynamic>? pattern = bookingData['recurringPattern'];
    if (pattern == null) return 'Weekly';

    switch (pattern['type']) {
      case 'weekly':
        return 'Weekly';
      case 'biweekly':
        return 'Bi-weekly';
      case 'monthly':
        return 'Monthly';
      default:
        return 'Custom';
    }
  }

  double _calculateTotalAmount() {
    // This would calculate based on actual pricing
    return 75.00; // Mock total
  }
}
