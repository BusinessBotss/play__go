import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EditProfileModalWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onSave;

  const EditProfileModalWidget({
    Key? key,
    required this.userData,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditProfileModalWidget> createState() => _EditProfileModalWidgetState();
}

class _EditProfileModalWidgetState extends State<EditProfileModalWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  List<String> _selectedSports = [];
  String? _selectedProfileImage;

  final List<String> _availableSports = [
    'Football',
    'Tennis',
    'Basketball',
    'Swimming',
    'Volleyball',
    'Running',
    'Cycling',
    'Padel',
    'Golf',
    'Fitness',
    'Yoga',
    'Boxing'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController =
        TextEditingController(text: widget.userData["name"] as String);
    _locationController =
        TextEditingController(text: widget.userData["location"] as String);
    _bioController =
        TextEditingController(text: widget.userData["bio"] as String? ?? '');
    _selectedSports =
        List<String>.from(widget.userData["sportPreferences"] as List);
    _selectedProfileImage = widget.userData["profileImage"] as String;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cambiar foto de perfil',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  'Cámara',
                  'camera_alt',
                  () {
                    Navigator.pop(context);
                    _selectImageFromCamera();
                  },
                ),
                _buildImageOption(
                  'Galería',
                  'photo_library',
                  () {
                    Navigator.pop(context);
                    _selectImageFromGallery();
                  },
                ),
                _buildImageOption(
                  'Eliminar',
                  'delete',
                  () {
                    Navigator.pop(context);
                    _removeProfileImage();
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(String label, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _selectImageFromCamera() {
    // Simulate camera selection
    setState(() {
      _selectedProfileImage =
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Foto tomada desde la cámara')),
    );
  }

  void _selectImageFromGallery() {
    // Simulate gallery selection
    setState(() {
      _selectedProfileImage =
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Foto seleccionada de la galería')),
    );
  }

  void _removeProfileImage() {
    setState(() {
      _selectedProfileImage =
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Foto de perfil eliminada')),
    );
  }

  void _showSportsSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Seleccionar Deportes',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Listo'),
                  ),
                ],
              ),
            ),

            Divider(),

            // Sports List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _availableSports.length,
                itemBuilder: (context, index) {
                  final sport = _availableSports[index];
                  final isSelected = _selectedSports.contains(sport);

                  return CheckboxListTile(
                    title: Text(sport),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedSports.add(sport);
                        } else {
                          _selectedSports.remove(sport);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedData = {
        "name": _nameController.text.trim(),
        "location": _locationController.text.trim(),
        "bio": _bioController.text.trim(),
        "sportPreferences": _selectedSports,
        "profileImage": _selectedProfileImage,
      };

      widget.onSave(updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                Text(
                  'Editar Perfil',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: _saveProfile,
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),

          Divider(),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo Section
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 8.h,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.primaryContainer,
                            child: CircleAvatar(
                              radius: 7.5.h,
                              child: _selectedProfileImage != null
                                  ? CustomImageWidget(
                                      imageUrl: _selectedProfileImage!,
                                      width: 15.h,
                                      height: 15.h,
                                      fit: BoxFit.cover,
                                    )
                                  : CustomIconWidget(
                                      iconName: 'person',
                                      size: 8.h,
                                      color: AppTheme.lightTheme.colorScheme
                                          .onPrimaryContainer,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showImagePicker,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    width: 2,
                                  ),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'edit',
                                  size: 16,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Name Field
                    Text(
                      'Nombre',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu nombre completo',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'person',
                            size: 20,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        if (value.trim().length < 2) {
                          return 'El nombre debe tener al menos 2 caracteres';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Location Field
                    Text(
                      'Ubicación',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Ciudad, País',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'location_on',
                            size: 20,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La ubicación es requerida';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Bio Field
                    Text(
                      'Biografía',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 4,
                      maxLength: 200,
                      decoration: InputDecoration(
                        hintText:
                            'Cuéntanos sobre ti y tus intereses deportivos...',
                        alignLabelWithHint: true,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Sports Preferences
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deportes Favoritos',
                          style: AppTheme.lightTheme.textTheme.titleSmall,
                        ),
                        TextButton(
                          onPressed: _showSportsSelector,
                          child: Text('Editar'),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),

                    _selectedSports.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.lightTheme.dividerColor,
                              ),
                            ),
                            child: Text(
                              'Selecciona tus deportes favoritos',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Wrap(
                            spacing: 2.w,
                            runSpacing: 1.h,
                            children: _selectedSports
                                .map((sport) => _buildSportChip(sport))
                                .toList(),
                          ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportChip(String sport) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sport,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedSports.remove(sport);
              });
            },
            child: CustomIconWidget(
              iconName: 'close',
              size: 16,
              color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
