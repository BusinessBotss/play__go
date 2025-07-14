import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/event_form_widget.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/privacy_toggle_widget.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedSport;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double _participantLimit = 10;
  bool _isPrivateEvent = false;
  bool _hasUnsavedChanges = false;
  bool _isLoading = false;
  List<String> _uploadedPhotos = [];

  // Mock data for sports
  final List<Map<String, dynamic>> _sportsData = [
    {"name": "Fútbol", "icon": "sports_soccer", "popular": true},
    {"name": "Baloncesto", "icon": "sports_basketball", "popular": true},
    {"name": "Tenis", "icon": "sports_tennis", "popular": true},
    {"name": "Pádel", "icon": "sports_tennis", "popular": true},
    {"name": "Natación", "icon": "pool", "popular": false},
    {"name": "Ciclismo", "icon": "directions_bike", "popular": false},
    {"name": "Running", "icon": "directions_run", "popular": false},
    {"name": "Voleibol", "icon": "sports_volleyball", "popular": false},
    {"name": "Golf", "icon": "sports_golf", "popular": false},
    {"name": "Escalada", "icon": "terrain", "popular": false},
  ];

  // Mock facilities data
  final List<Map<String, dynamic>> _facilitiesData = [
    {
      "name": "Centro Deportivo Calvià",
      "price": "25€/hora",
      "rating": 4.5,
      "distance": "0.8 km",
      "image":
          "https://images.pexels.com/photos/3621104/pexels-photo-3621104.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "name": "Polideportivo Palma",
      "price": "20€/hora",
      "rating": 4.2,
      "distance": "1.2 km",
      "image":
          "https://images.pexels.com/photos/1552252/pexels-photo-1552252.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
  ];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
    _locationController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  bool get _isFormValid {
    return _titleController.text.isNotEmpty &&
        _selectedSport != null &&
        _selectedDate != null &&
        _selectedTime != null &&
        _locationController.text.isNotEmpty;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Cambios sin guardar',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            content: Text(
              '¿Estás seguro de que quieres salir? Se perderán todos los cambios.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Salir'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _hasUnsavedChanges = true;
      });
    }
  }

  void _showSportSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Seleccionar Deporte',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Text(
                    'Deportes Populares',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._sportsData
                      .where((sport) => sport["popular"] as bool)
                      .map((sport) => _buildSportTile(sport)),
                  const SizedBox(height: 16),
                  Text(
                    'Otros Deportes',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._sportsData
                      .where((sport) => !(sport["popular"] as bool))
                      .map((sport) => _buildSportTile(sport)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportTile(Map<String, dynamic> sport) {
    final isSelected = _selectedSport == sport["name"];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppTheme.lightTheme.colorScheme.primary)
            : null,
      ),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: sport["icon"] as String,
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
        title: Text(
          sport["name"] as String,
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: isSelected ? AppTheme.lightTheme.colorScheme.primary : null,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedSport = sport["name"] as String;
            _hasUnsavedChanges = true;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Seleccionar Ubicación',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Mock GPS location
                      _locationController.text = "Mi ubicación actual";
                      setState(() {
                        _hasUnsavedChanges = true;
                      });
                      Navigator.pop(context);
                    },
                    icon: CustomIconWidget(
                      iconName: 'my_location',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar ubicación...',
                  prefixIcon: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
                onChanged: (value) {
                  // Mock search functionality
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'map',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vista previa del mapa',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_locationController.text.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Instalaciones Disponibles',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _facilitiesData.length,
                  itemBuilder: (context, index) {
                    final facility = _facilitiesData[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl: facility["image"] as String,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          facility["name"] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              facility["price"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${facility["rating"]} • ${facility["distance"]}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: OutlinedButton(
                          onPressed: () {
                            // Mock booking functionality
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(60, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text('Reservar'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _createEvent() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Mock API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasUnsavedChanges = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Evento Creado',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          content: Text(
            'Tu evento "${_titleController.text}" ha sido creado exitosamente.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Ver Eventos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/event-details');
              },
              child: const Text('Ver Evento'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Crear Evento'),
          leading: IconButton(
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isFormValid && !_isLoading ? _createEvent : null,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Crear',
                      style: TextStyle(
                        color: _isFormValid
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Form Widget
                EventFormWidget(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  locationController: _locationController,
                  selectedSport: _selectedSport,
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  participantLimit: _participantLimit,
                  onSportTap: _showSportSelector,
                  onDateTap: _selectDate,
                  onTimeTap: _selectTime,
                  onLocationTap: _showLocationPicker,
                  onParticipantLimitChanged: (value) {
                    setState(() {
                      _participantLimit = value;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Photo Upload Widget
                PhotoUploadWidget(
                  uploadedPhotos: _uploadedPhotos,
                  onPhotosChanged: (photos) {
                    setState(() {
                      _uploadedPhotos = photos;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Privacy Toggle Widget
                PrivacyToggleWidget(
                  isPrivate: _isPrivateEvent,
                  onChanged: (value) {
                    setState(() {
                      _isPrivateEvent = value;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        _isFormValid && !_isLoading ? _createEvent : null,
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text('Creando Evento...'),
                            ],
                          )
                        : const Text('Crear Evento'),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
