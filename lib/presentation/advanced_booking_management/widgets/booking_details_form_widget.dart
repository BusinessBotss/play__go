import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailsFormWidget extends StatefulWidget {
  final int participantCount;
  final Function(int) onParticipantCountChanged;
  final Function(List<String>) onEquipmentChanged;
  final Function(String) onSpecialRequirementsChanged;

  const BookingDetailsFormWidget({
    Key? key,
    required this.participantCount,
    required this.onParticipantCountChanged,
    required this.onEquipmentChanged,
    required this.onSpecialRequirementsChanged,
  }) : super(key: key);

  @override
  State<BookingDetailsFormWidget> createState() =>
      _BookingDetailsFormWidgetState();
}

class _BookingDetailsFormWidgetState extends State<BookingDetailsFormWidget> {
  final TextEditingController _specialRequirementsController =
      TextEditingController();
  List<String> selectedEquipment = [];

  final List<EquipmentItem> availableEquipment = [
    EquipmentItem(name: 'Tennis Racket', price: 5.0, icon: Icons.sports_tennis),
    EquipmentItem(
        name: 'Basketball', price: 3.0, icon: Icons.sports_basketball),
    EquipmentItem(name: 'Soccer Ball', price: 3.0, icon: Icons.sports_soccer),
    EquipmentItem(
        name: 'Volleyball', price: 3.0, icon: Icons.sports_volleyball),
    EquipmentItem(name: 'Badminton Set', price: 7.0, icon: Icons.sports_tennis),
    EquipmentItem(name: 'Cones (Set of 10)', price: 2.0, icon: Icons.traffic),
    EquipmentItem(name: 'Whistle', price: 1.0, icon: Icons.music_note),
    EquipmentItem(
        name: 'First Aid Kit', price: 0.0, icon: Icons.medical_services),
  ];

  @override
  void dispose() {
    _specialRequirementsController.dispose();
    super.dispose();
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
            Text(
              'Booking Details',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),

            // Participant count slider
            _buildParticipantCountSection(),

            SizedBox(height: 20),

            // Equipment rental section
            _buildEquipmentSection(),

            SizedBox(height: 20),

            // Special requirements section
            _buildSpecialRequirementsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Number of Participants',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.participantCount.toString(),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Slider(
          value: widget.participantCount.toDouble(),
          min: 1,
          max: 20,
          divisions: 19,
          onChanged: (value) {
            widget.onParticipantCountChanged(value.round());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 person',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '20 people',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEquipmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Equipment Rental',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (selectedEquipment.isNotEmpty)
              Text(
                'Total: \$${_calculateEquipmentTotal().toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
        SizedBox(height: 12),

        // Equipment grid
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: availableEquipment.length,
          itemBuilder: (context, index) {
            EquipmentItem item = availableEquipment[index];
            bool isSelected = selectedEquipment.contains(item.name);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedEquipment.remove(item.name);
                  } else {
                    selectedEquipment.add(item.name);
                  }
                });
                widget.onEquipmentChanged(selectedEquipment);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : null,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade600,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.price > 0)
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            )
                          else
                            Text(
                              'Free',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSpecialRequirementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Requirements',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Any special needs, accessibility requirements, or additional notes',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 12),

        TextField(
          controller: _specialRequirementsController,
          maxLines: 3,
          maxLength: 500,
          decoration: InputDecoration(
            hintText:
                'Enter any special requirements, accessibility needs, or additional notes...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            counterText: '',
          ),
          onChanged: (value) {
            widget.onSpecialRequirementsChanged(value);
          },
        ),

        SizedBox(height: 12),

        // Quick requirement tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildRequirementTag('Wheelchair Access'),
            _buildRequirementTag('Beginner Friendly'),
            _buildRequirementTag('Quiet Environment'),
            _buildRequirementTag('Photo/Video Allowed'),
            _buildRequirementTag('Coaching Available'),
          ],
        ),
      ],
    );
  }

  Widget _buildRequirementTag(String label) {
    return GestureDetector(
      onTap: () {
        String currentText = _specialRequirementsController.text;
        if (currentText.contains(label)) {
          _specialRequirementsController.text =
              currentText.replaceAll(label, '').trim();
        } else {
          _specialRequirementsController.text =
              currentText.isEmpty ? label : '$currentText, $label';
        }
        widget
            .onSpecialRequirementsChanged(_specialRequirementsController.text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _specialRequirementsController.text.contains(label)
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _specialRequirementsController.text.contains(label)
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _specialRequirementsController.text.contains(label)
                ? Theme.of(context).primaryColor
                : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  double _calculateEquipmentTotal() {
    double total = 0;
    for (String equipmentName in selectedEquipment) {
      EquipmentItem? item = availableEquipment.firstWhere(
        (e) => e.name == equipmentName,
        orElse: () => EquipmentItem(name: '', price: 0, icon: Icons.error),
      );
      total += item.price;
    }
    return total;
  }
}

class EquipmentItem {
  final String name;
  final double price;
  final IconData icon;

  EquipmentItem({
    required this.name,
    required this.price,
    required this.icon,
  });
}
