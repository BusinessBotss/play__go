import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final String? facilityId;

  const BookingCalendarWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    this.facilityId,
  }) : super(key: key);

  @override
  State<BookingCalendarWidget> createState() => _BookingCalendarWidgetState();
}

class _BookingCalendarWidgetState extends State<BookingCalendarWidget> {
  late DateTime currentMonth;
  Map<DateTime, String> availabilityMap = {};

  @override
  void initState() {
    super.initState();
    currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _loadAvailability();
  }

  void _loadAvailability() {
    // Simulate loading availability data from booking microservice
    // This would be replaced with actual API call
    setState(() {
      availabilityMap = _generateMockAvailability();
    });
  }

  Map<DateTime, String> _generateMockAvailability() {
    Map<DateTime, String> availability = {};
    DateTime now = DateTime.now();

    for (int i = 0; i < 30; i++) {
      DateTime date = now.add(Duration(days: i));
      if (date.weekday == DateTime.sunday) {
        availability[date] = 'unavailable';
      } else if (i % 4 == 0) {
        availability[date] = 'limited';
      } else if (i % 7 == 0) {
        availability[date] = 'booked';
      } else {
        availability[date] = 'available';
      }
    }

    return availability;
  }

  Color _getAvailabilityColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'limited':
        return Colors.orange;
      case 'booked':
        return Colors.red;
      case 'unavailable':
        return Colors.grey;
      default:
        return Colors.grey.shade300;
    }
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
                  'Select Date',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: _showLegend,
                  icon: Icon(Icons.info_outline, size: 20),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentMonth =
                          DateTime(currentMonth.year, currentMonth.month - 1);
                    });
                    _loadAvailability();
                  },
                  icon: Icon(Icons.chevron_left),
                ),
                Text(
                  '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentMonth =
                          DateTime(currentMonth.year, currentMonth.month + 1);
                    });
                    _loadAvailability();
                  },
                  icon: Icon(Icons.chevron_right),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Calendar grid
            _buildCalendarGrid(),

            SizedBox(height: 16),

            // Availability legend
            _buildAvailabilityLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    List<Widget> dayHeaders = [];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    for (String day in days) {
      dayHeaders.add(
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    List<Widget> calendarDays = [];

    // Get first day of month and calculate starting position
    DateTime firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    int startingWeekday = firstDay.weekday % 7;

    // Add empty cells for days before first day of month
    for (int i = 0; i < startingWeekday; i++) {
      calendarDays.add(Container());
    }

    // Add days of the month
    int daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      String availability = availabilityMap[date] ?? 'available';
      bool isSelected = date.year == widget.selectedDate.year &&
          date.month == widget.selectedDate.month &&
          date.day == widget.selectedDate.day;
      bool isPast = date.isBefore(DateTime.now().subtract(Duration(days: 1)));

      calendarDays.add(
        GestureDetector(
          onTap: isPast || availability == 'unavailable'
              ? null
              : () {
                  widget.onDateSelected(date);
                },
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              border: Border.all(
                color: _getAvailabilityColor(availability),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : isPast
                          ? Colors.grey.shade400
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      children: [...dayHeaders, ...calendarDays],
    );
  }

  Widget _buildAvailabilityLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Available', Colors.green),
        _buildLegendItem('Limited', Colors.orange),
        _buildLegendItem('Booked', Colors.red),
        _buildLegendItem('Unavailable', Colors.grey),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _showLegend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Availability Legend'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendRow(
                'Available', Colors.green, 'Multiple time slots available'),
            _buildLegendRow(
                'Limited', Colors.orange, 'Few time slots remaining'),
            _buildLegendRow('Booked', Colors.red, 'Fully booked'),
            _buildLegendRow('Unavailable', Colors.grey, 'Facility closed'),
          ],
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

  Widget _buildLegendRow(String label, Color color, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
