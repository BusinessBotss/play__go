import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingHistoryWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onModifyBooking;
  final Function(Map<String, dynamic>) onCancelBooking;
  final Function(Map<String, dynamic>) onViewBookingDetails;

  const BookingHistoryWidget({
    Key? key,
    required this.onModifyBooking,
    required this.onCancelBooking,
    required this.onViewBookingDetails,
  }) : super(key: key);

  @override
  State<BookingHistoryWidget> createState() => _BookingHistoryWidgetState();
}

class _BookingHistoryWidgetState extends State<BookingHistoryWidget>
    with TickerProviderStateMixin {
  late TabController _historyTabController;
  List<BookingHistoryItem> upcomingBookings = [];
  List<BookingHistoryItem> pastBookings = [];
  List<BookingHistoryItem> cancelledBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _historyTabController = TabController(length: 3, vsync: this);
    _loadBookingHistory();
  }

  void _loadBookingHistory() {
    // Simulate loading booking history from API
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        upcomingBookings = _generateUpcomingBookings();
        pastBookings = _generatePastBookings();
        cancelledBookings = _generateCancelledBookings();
        isLoading = false;
      });
    });
  }

  List<BookingHistoryItem> _generateUpcomingBookings() {
    return [
      BookingHistoryItem(
        id: 'BK-001',
        facilityName: 'Tennis Court A',
        date: DateTime.now().add(Duration(days: 2)),
        timeSlot: '14:00 - 15:00',
        participants: 2,
        status: BookingStatus.confirmed,
        totalAmount: 45.00,
        paymentStatus: PaymentStatus.paid,
        isRecurring: false,
      ),
      BookingHistoryItem(
        id: 'BK-002',
        facilityName: 'Basketball Court',
        date: DateTime.now().add(Duration(days: 5)),
        timeSlot: '18:00 - 19:00',
        participants: 8,
        status: BookingStatus.confirmed,
        totalAmount: 60.00,
        paymentStatus: PaymentStatus.pending,
        isRecurring: true,
      ),
      BookingHistoryItem(
        id: 'BK-003',
        facilityName: 'Swimming Pool',
        date: DateTime.now().add(Duration(days: 7)),
        timeSlot: '09:00 - 10:00',
        participants: 4,
        status: BookingStatus.confirmed,
        totalAmount: 80.00,
        paymentStatus: PaymentStatus.paid,
        isRecurring: false,
      ),
    ];
  }

  List<BookingHistoryItem> _generatePastBookings() {
    return [
      BookingHistoryItem(
        id: 'BK-004',
        facilityName: 'Tennis Court B',
        date: DateTime.now().subtract(Duration(days: 3)),
        timeSlot: '16:00 - 17:00',
        participants: 2,
        status: BookingStatus.completed,
        totalAmount: 45.00,
        paymentStatus: PaymentStatus.paid,
        isRecurring: false,
      ),
      BookingHistoryItem(
        id: 'BK-005',
        facilityName: 'Football Field',
        date: DateTime.now().subtract(Duration(days: 10)),
        timeSlot: '19:00 - 20:00',
        participants: 12,
        status: BookingStatus.completed,
        totalAmount: 100.00,
        paymentStatus: PaymentStatus.paid,
        isRecurring: false,
      ),
    ];
  }

  List<BookingHistoryItem> _generateCancelledBookings() {
    return [
      BookingHistoryItem(
        id: 'BK-006',
        facilityName: 'Volleyball Court',
        date: DateTime.now().subtract(Duration(days: 1)),
        timeSlot: '15:00 - 16:00',
        participants: 6,
        status: BookingStatus.cancelled,
        totalAmount: 55.00,
        paymentStatus: PaymentStatus.refunded,
        isRecurring: false,
      ),
    ];
  }

  @override
  void dispose() {
    _historyTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _historyTabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _historyTabController,
            children: [
              _buildBookingList(upcomingBookings, BookingListType.upcoming),
              _buildBookingList(pastBookings, BookingListType.past),
              _buildBookingList(cancelledBookings, BookingListType.cancelled),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingList(
      List<BookingHistoryItem> bookings, BookingListType type) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyIcon(type),
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              _getEmptyMessage(type),
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _getEmptySubMessage(type),
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index], type);
      },
    );
  }

  Widget _buildBookingCard(BookingHistoryItem booking, BookingListType type) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with facility name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.facilityName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildStatusBadge(booking.status),
              ],
            ),

            SizedBox(height: 12),

            // Booking details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(Icons.calendar_today, 'Date',
                          booking.date.toString().split(' ')[0]),
                      _buildDetailRow(
                          Icons.access_time, 'Time', booking.timeSlot),
                      _buildDetailRow(Icons.people, 'Participants',
                          '${booking.participants} people'),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$${booking.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    _buildPaymentStatusBadge(booking.paymentStatus),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12),

            // Booking ID and recurring indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${booking.id}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (booking.isRecurring)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Recurring',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 12),

            // Action buttons
            _buildActionButtons(booking, type),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
    Color color;
    String text;

    switch (status) {
      case BookingStatus.confirmed:
        color = Colors.green;
        text = 'Confirmed';
        break;
      case BookingStatus.completed:
        color = Colors.blue;
        text = 'Completed';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
      case BookingStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusBadge(PaymentStatus status) {
    Color color;
    String text;

    switch (status) {
      case PaymentStatus.paid:
        color = Colors.green;
        text = 'Paid';
        break;
      case PaymentStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case PaymentStatus.refunded:
        color = Colors.blue;
        text = 'Refunded';
        break;
      case PaymentStatus.failed:
        color = Colors.red;
        text = 'Failed';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BookingHistoryItem booking, BookingListType type) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              widget.onViewBookingDetails(booking.toMap());
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: Text(
              'View Details',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (type == BookingListType.upcoming) ...[
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onModifyBooking(booking.toMap());
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                'Modify',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                widget.onCancelBooking(booking.toMap());
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getEmptyIcon(BookingListType type) {
    switch (type) {
      case BookingListType.upcoming:
        return Icons.schedule;
      case BookingListType.past:
        return Icons.history;
      case BookingListType.cancelled:
        return Icons.cancel;
    }
  }

  String _getEmptyMessage(BookingListType type) {
    switch (type) {
      case BookingListType.upcoming:
        return 'No Upcoming Bookings';
      case BookingListType.past:
        return 'No Past Bookings';
      case BookingListType.cancelled:
        return 'No Cancelled Bookings';
    }
  }

  String _getEmptySubMessage(BookingListType type) {
    switch (type) {
      case BookingListType.upcoming:
        return 'Book your first facility to get started!';
      case BookingListType.past:
        return 'Your completed bookings will appear here';
      case BookingListType.cancelled:
        return 'Any cancelled bookings will be shown here';
    }
  }
}

class BookingHistoryItem {
  final String id;
  final String facilityName;
  final DateTime date;
  final String timeSlot;
  final int participants;
  final BookingStatus status;
  final double totalAmount;
  final PaymentStatus paymentStatus;
  final bool isRecurring;

  BookingHistoryItem({
    required this.id,
    required this.facilityName,
    required this.date,
    required this.timeSlot,
    required this.participants,
    required this.status,
    required this.totalAmount,
    required this.paymentStatus,
    required this.isRecurring,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'facilityName': facilityName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'participants': participants,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus.toString(),
      'isRecurring': isRecurring,
    };
  }
}

enum BookingStatus {
  confirmed,
  completed,
  cancelled,
  pending,
}

enum PaymentStatus {
  paid,
  pending,
  refunded,
  failed,
}

enum BookingListType {
  upcoming,
  past,
  cancelled,
}
