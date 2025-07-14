import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeSlotSelectionWidget extends StatefulWidget {
  final DateTime selectedDate;
  final String? selectedTimeSlot;
  final Function(String timeSlot, double price) onTimeSlotSelected;
  final String? facilityId;

  const TimeSlotSelectionWidget({
    Key? key,
    required this.selectedDate,
    this.selectedTimeSlot,
    required this.onTimeSlotSelected,
    this.facilityId,
  }) : super(key: key);

  @override
  State<TimeSlotSelectionWidget> createState() =>
      _TimeSlotSelectionWidgetState();
}

class _TimeSlotSelectionWidgetState extends State<TimeSlotSelectionWidget> {
  List<TimeSlot> timeSlots = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTimeSlots();
  }

  @override
  void didUpdateWidget(TimeSlotSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadTimeSlots();
    }
  }

  void _loadTimeSlots() {
    setState(() {
      isLoading = true;
    });

    // Simulate API call to booking microservice
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          timeSlots = _generateTimeSlots();
          isLoading = false;
        });
      }
    });
  }

  List<TimeSlot> _generateTimeSlots() {
    List<TimeSlot> slots = [];
    DateTime now = DateTime.now();
    bool isToday = widget.selectedDate.year == now.year &&
        widget.selectedDate.month == now.month &&
        widget.selectedDate.day == now.day;

    for (int hour = 6; hour < 22; hour++) {
      String timeRange =
          '${hour.toString().padLeft(2, '0')}:00 - ${(hour + 1).toString().padLeft(2, '0')}:00';

      // Skip past time slots for today
      if (isToday && hour <= now.hour) {
        continue;
      }

      // Dynamic pricing based on time and demand
      double basePrice = 30.0;
      double multiplier = 1.0;

      // Peak hours (6-9 PM) cost more
      if (hour >= 18 && hour <= 21) {
        multiplier = 1.5;
      }
      // Morning hours (6-9 AM) cost less
      else if (hour >= 6 && hour <= 9) {
        multiplier = 0.8;
      }
      // Weekend premium
      if (widget.selectedDate.weekday == DateTime.saturday ||
          widget.selectedDate.weekday == DateTime.sunday) {
        multiplier *= 1.2;
      }

      double price = basePrice * multiplier;

      // Simulate availability
      SlotStatus status = SlotStatus.available;
      if (hour == 12 || hour == 19) {
        status = SlotStatus.booked;
      } else if (hour == 15 || hour == 20) {
        status = SlotStatus.limited;
      }

      slots.add(TimeSlot(
        timeRange: timeRange,
        price: price,
        originalPrice: hour >= 18 && hour <= 21 ? basePrice : null,
        status: status,
        participants: status == SlotStatus.limited ? 2 : 8,
        maxParticipants: 8,
      ));
    }

    return slots;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Time Slot',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Prices shown include dynamic pricing based on demand and time',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 16),
            if (isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (timeSlots.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No time slots available for selected date',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              _buildTimeSlotGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        TimeSlot slot = timeSlots[index];
        bool isSelected = widget.selectedTimeSlot == slot.timeRange;
        bool isAvailable = slot.status == SlotStatus.available ||
            slot.status == SlotStatus.limited;

        return GestureDetector(
          onTap: isAvailable
              ? () {
                  widget.onTimeSlotSelected(slot.timeRange, slot.price);
                }
              : null,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isAvailable
                      ? Colors.transparent
                      : Colors.grey.shade100,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : slot.status == SlotStatus.available
                        ? Colors.green
                        : slot.status == SlotStatus.limited
                            ? Colors.orange
                            : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.timeRange,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : isAvailable
                            ? Colors.black
                            : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    if (slot.originalPrice != null)
                      Text(
                        '\$${slot.originalPrice!.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      '\$${slot.price.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : slot.originalPrice != null
                                ? Colors.green
                                : Colors.black,
                      ),
                    ),
                  ],
                ),
                if (slot.status == SlotStatus.limited)
                  Text(
                    '${slot.participants}/${slot.maxParticipants} spots',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: isSelected ? Colors.white70 : Colors.orange,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimeSlot {
  final String timeRange;
  final double price;
  final double? originalPrice;
  final SlotStatus status;
  final int participants;
  final int maxParticipants;

  TimeSlot({
    required this.timeRange,
    required this.price,
    this.originalPrice,
    required this.status,
    required this.participants,
    required this.maxParticipants,
  });
}

enum SlotStatus {
  available,
  limited,
  booked,
}
