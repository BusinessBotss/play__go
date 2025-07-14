import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/booking_calendar_widget.dart';
import './widgets/booking_confirmation_widget.dart';
import './widgets/booking_details_form_widget.dart';
import './widgets/booking_history_widget.dart';
import './widgets/cancellation_policy_widget.dart';
import './widgets/payment_options_widget.dart';
import './widgets/recurring_booking_widget.dart';
import './widgets/time_slot_selection_widget.dart';

class AdvancedBookingManagement extends StatefulWidget {
  const AdvancedBookingManagement({Key? key}) : super(key: key);

  @override
  State<AdvancedBookingManagement> createState() =>
      _AdvancedBookingManagementState();
}

class _AdvancedBookingManagementState extends State<AdvancedBookingManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  int participantCount = 1;
  double totalPrice = 0.0;
  bool isConnected = true;
  bool isLoading = false;

  // Booking data
  Map<String, dynamic> bookingData = {
    'facilityId': null,
    'date': null,
    'timeSlot': null,
    'participants': 1,
    'equipment': <String>[],
    'specialRequirements': '',
    'paymentMethod': 'card',
    'isRecurring': false,
    'recurringPattern': null,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeBookingData();
    _setupWebSocketConnection();
  }

  void _initializeBookingData() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      bookingData.addAll(args);
    }
  }

  void _setupWebSocketConnection() {
    // WebSocket connection setup for real-time availability updates
    // This would connect to the booking microservice
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isConnected = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Advanced Booking',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: isConnected ? Colors.green : Colors.red,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isConnected
                        ? 'Connected - Real-time updates active'
                        : 'Disconnected - Limited functionality',
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Book Now'),
            Tab(text: 'Confirmation'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingTab(),
          _buildConfirmationTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildBookingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Real-time availability indicator
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isConnected
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isConnected ? Colors.green : Colors.orange,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isConnected ? Icons.check_circle : Icons.warning,
                  color: isConnected ? Colors.green : Colors.orange,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  isConnected
                      ? 'Real-time availability active'
                      : 'Limited availability updates',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isConnected ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Calendar widget
          BookingCalendarWidget(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
                bookingData['date'] = date;
                selectedTimeSlot = null; // Reset time slot when date changes
              });
            },
            facilityId: bookingData['facilityId'],
          ),
          SizedBox(height: 20),

          // Time slot selection
          TimeSlotSelectionWidget(
            selectedDate: selectedDate,
            selectedTimeSlot: selectedTimeSlot,
            onTimeSlotSelected: (timeSlot, price) {
              setState(() {
                selectedTimeSlot = timeSlot;
                totalPrice = price;
                bookingData['timeSlot'] = timeSlot;
              });
            },
            facilityId: bookingData['facilityId'],
          ),
          SizedBox(height: 20),

          // Booking details form
          BookingDetailsFormWidget(
            participantCount: participantCount,
            onParticipantCountChanged: (count) {
              setState(() {
                participantCount = count;
                bookingData['participants'] = count;
              });
            },
            onEquipmentChanged: (equipment) {
              bookingData['equipment'] = equipment;
            },
            onSpecialRequirementsChanged: (requirements) {
              bookingData['specialRequirements'] = requirements;
            },
          ),
          SizedBox(height: 20),

          // Recurring booking setup
          RecurringBookingWidget(
            isRecurring: bookingData['isRecurring'] ?? false,
            onRecurringChanged: (isRecurring, pattern) {
              setState(() {
                bookingData['isRecurring'] = isRecurring;
                bookingData['recurringPattern'] = pattern;
              });
            },
          ),
          SizedBox(height: 20),

          // Payment options
          PaymentOptionsWidget(
            totalPrice: totalPrice,
            selectedPaymentMethod: bookingData['paymentMethod'],
            onPaymentMethodChanged: (method) {
              setState(() {
                bookingData['paymentMethod'] = method;
              });
            },
          ),
          SizedBox(height: 20),

          // Cancellation policy
          CancellationPolicyWidget(
            facilityId: bookingData['facilityId'],
            bookingDate: selectedDate,
            totalPrice: totalPrice,
          ),
          SizedBox(height: 30),

          // Book now button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedTimeSlot != null && !isLoading
                  ? _processBooking
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Book Now - \$${totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationTab() {
    return BookingConfirmationWidget(
      bookingData: bookingData,
      onShareBooking: _shareBooking,
      onAddToCalendar: _addToCalendar,
      onViewQRCode: _viewQRCode,
    );
  }

  Widget _buildHistoryTab() {
    return BookingHistoryWidget(
      onModifyBooking: _modifyBooking,
      onCancelBooking: _cancelBooking,
      onViewBookingDetails: _viewBookingDetails,
    );
  }

  Future<void> _processBooking() async {
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Unable to process booking. Please check your connection.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate booking API call to booking microservice
      await Future.delayed(Duration(seconds: 2));

      // Check for conflicts one more time
      bool hasConflict = false; // This would come from the API

      if (hasConflict) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Booking conflict detected. Please select a different time.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Success - move to confirmation tab
      _tabController.animateTo(1);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking confirmed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Setup push notification for booking reminder
      _setupBookingReminder();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _setupBookingReminder() {
    // This would integrate with FCM for push notifications
    // Setup reminder notifications based on user preferences
  }

  void _shareBooking() {
    // Share booking details
    final bookingDetails =
        'Booking confirmed for ${selectedDate.toString().split(' ')[0]} at $selectedTimeSlot';
    // Implement sharing functionality
  }

  void _addToCalendar() {
    // Add booking to device calendar
    // This would integrate with calendar plugins
  }

  void _viewQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Check-in QR Code'),
        content: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              Icons.qr_code,
              size: 100,
              color: Colors.grey,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _modifyBooking(Map<String, dynamic> booking) {
    // Navigate to modify booking flow
    Navigator.pushNamed(
      context,
      '/modify-booking',
      arguments: booking,
    );
  }

  void _cancelBooking(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Process cancellation
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _viewBookingDetails(Map<String, dynamic> booking) {
    // Navigate to booking details view
    Navigator.pushNamed(
      context,
      '/booking-details',
      arguments: booking,
    );
  }
}
