import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecurringBookingWidget extends StatefulWidget {
  final bool isRecurring;
  final Function(bool isRecurring, Map<String, dynamic>? pattern)
      onRecurringChanged;

  const RecurringBookingWidget({
    Key? key,
    required this.isRecurring,
    required this.onRecurringChanged,
  }) : super(key: key);

  @override
  State<RecurringBookingWidget> createState() => _RecurringBookingWidgetState();
}

class _RecurringBookingWidgetState extends State<RecurringBookingWidget> {
  String recurringType = 'weekly';
  int interval = 1;
  List<int> selectedWeekdays = [DateTime.now().weekday];
  DateTime? endDate;
  int? maxOccurrences;
  bool useEndDate = true;

  final List<RecurringPattern> recurringPatterns = [
    RecurringPattern(
      id: 'weekly',
      name: 'Weekly',
      description: 'Repeat every week',
      icon: Icons.calendar_view_week,
    ),
    RecurringPattern(
      id: 'biweekly',
      name: 'Bi-weekly',
      description: 'Repeat every 2 weeks',
      icon: Icons.calendar_today,
    ),
    RecurringPattern(
      id: 'monthly',
      name: 'Monthly',
      description: 'Repeat every month',
      icon: Icons.calendar_view_month,
    ),
  ];

  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

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
                  'Recurring Booking',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch(
                  value: widget.isRecurring,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        _updateRecurringPattern();
                      }
                    });
                    widget.onRecurringChanged(
                        value, value ? _getRecurringPattern() : null);
                  },
                ),
              ],
            ),
            if (widget.isRecurring) ...[
              SizedBox(height: 16),
              _buildRecurringOptions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecurringOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recurring pattern selection
        _buildPatternSelection(),

        SizedBox(height: 16),

        // Weekday selection for weekly/bi-weekly
        if (recurringType == 'weekly' || recurringType == 'biweekly')
          _buildWeekdaySelection(),

        SizedBox(height: 16),

        // End date or occurrence limit
        _buildEndCondition(),

        SizedBox(height: 16),

        // Conflict detection and preview
        _buildConflictDetection(),

        SizedBox(height: 12),

        // Booking preview
        _buildBookingPreview(),
      ],
    );
  }

  Widget _buildPatternSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat Pattern',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: recurringPatterns
              .map((pattern) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          recurringType = pattern.id;
                          if (pattern.id == 'biweekly') {
                            interval = 2;
                          } else {
                            interval = 1;
                          }
                        });
                        _updateRecurringPattern();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: recurringType == pattern.id
                              ? Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1)
                              : null,
                          border: Border.all(
                            color: recurringType == pattern.id
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              pattern.icon,
                              size: 24,
                              color: recurringType == pattern.id
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade600,
                            ),
                            SizedBox(height: 4),
                            Text(
                              pattern.name,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: recurringType == pattern.id
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildWeekdaySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Days',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            int weekday = index + 1;
            bool isSelected = selectedWeekdays.contains(weekday);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedWeekdays.remove(weekday);
                  } else {
                    selectedWeekdays.add(weekday);
                  }
                });
                _updateRecurringPattern();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(
                    weekdays[index].substring(0, 1),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEndCondition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'End Condition',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: Text(
                  'End Date',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                value: true,
                groupValue: useEndDate,
                onChanged: (value) {
                  setState(() {
                    useEndDate = value!;
                  });
                  _updateRecurringPattern();
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: Text(
                  'Occurrences',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                value: false,
                groupValue: useEndDate,
                onChanged: (value) {
                  setState(() {
                    useEndDate = value!;
                  });
                  _updateRecurringPattern();
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (useEndDate)
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: endDate ?? DateTime.now().add(Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (picked != null) {
                setState(() {
                  endDate = picked;
                });
                _updateRecurringPattern();
              }
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    endDate?.toString().split(' ')[0] ?? 'Select End Date',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  Icon(Icons.calendar_today, size: 20),
                ],
              ),
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Number of occurrences',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      maxOccurrences = int.tryParse(value);
                    });
                    _updateRecurringPattern();
                  },
                ),
              ),
              SizedBox(width: 8),
              Text(
                'times',
                style: GoogleFonts.inter(fontSize: 14),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildConflictDetection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.info, size: 20, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conflict Detection',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'We\'ll check for conflicts and suggest alternatives',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingPreview() {
    List<DateTime> previewDates = _generatePreviewDates();

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
            'Booking Preview',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          if (previewDates.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: previewDates
                  .take(5)
                  .map((date) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• ${date.toString().split(' ')[0]}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          if (previewDates.length > 5)
            Text(
              '... and ${previewDates.length - 5} more',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  List<DateTime> _generatePreviewDates() {
    List<DateTime> dates = [];
    DateTime startDate = DateTime.now();
    DateTime maxDate = useEndDate
        ? (endDate ?? DateTime.now().add(Duration(days: 365)))
        : DateTime.now().add(Duration(days: 365));

    int occurrences = 0;
    int maxOcc = maxOccurrences ?? 10;

    DateTime currentDate = startDate;
    while (currentDate.isBefore(maxDate) && occurrences < maxOcc) {
      if (recurringType == 'weekly' || recurringType == 'biweekly') {
        if (selectedWeekdays.contains(currentDate.weekday)) {
          dates.add(currentDate);
          occurrences++;
        }
        currentDate = currentDate.add(Duration(days: 1));
      } else if (recurringType == 'monthly') {
        dates.add(currentDate);
        occurrences++;
        currentDate =
            DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
      }
    }

    return dates;
  }

  void _updateRecurringPattern() {
    widget.onRecurringChanged(widget.isRecurring, _getRecurringPattern());
  }

  Map<String, dynamic> _getRecurringPattern() {
    return {
      'type': recurringType,
      'interval': interval,
      'selectedWeekdays': selectedWeekdays,
      'endDate': endDate?.toIso8601String(),
      'maxOccurrences': maxOccurrences,
      'useEndDate': useEndDate,
    };
  }
}

class RecurringPattern {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  RecurringPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}
