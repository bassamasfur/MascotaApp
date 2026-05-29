import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/pet.dart';

/// Vista unificada para registrar o editar una mascota
class RegisterEditPetView extends StatefulWidget {
  final void Function(Pet) onPetSaved;
  final Pet? pet;
  final bool isEdit;
  const RegisterEditPetView({
    super.key,
    required this.onPetSaved,
    this.pet,
    this.isEdit = false,
  });

  @override
  State<RegisterEditPetView> createState() => _RegisterEditPetViewState();
}

class _RegisterEditPetViewState extends State<RegisterEditPetView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _weightController;
  late TextEditingController _colorController;
  late TextEditingController _descriptionController;
  late TextEditingController _microchipController;
  late TextEditingController _registrationController;
  late String _species;
  late String _gender;
  late bool _isPureBreed;
  late int _age;
  DateTime? _birthDate;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final pet = widget.pet;
    _nameController = TextEditingController(text: pet?.name ?? '');
    _breedController = TextEditingController(text: pet?.breed ?? '');
    _weightController = TextEditingController(
      text: pet?.weight.toString() ?? '',
    );
    _colorController = TextEditingController(text: pet?.color ?? '');
    _descriptionController = TextEditingController(
      text: pet?.description ?? '',
    );
    _microchipController = TextEditingController(text: pet?.microchip ?? '');
    _registrationController = TextEditingController(
      text: pet?.registrationNumber ?? '',
    );
    _species = pet?.species ?? 'Gato';
    _gender = pet?.gender ?? 'Hembra';
    _isPureBreed = pet?.isPureBreed ?? false;
    _age = pet?.age ?? 1;
    _birthDate = pet?.birthDate;
    if (pet != null && pet.imageUrl.isNotEmpty) {
      _imageFile = File(pet.imageUrl);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    while (true) {
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked == null) return;
      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('¿Usar esta foto?'),
          content: Image.file(File(picked.path), height: 220),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Repetir'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        // Guardar la imagen en el directorio de documentos de la app
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            'pet_${DateTime.now().millisecondsSinceEpoch}${path.extension(picked.path)}';
        final savedImage = await File(
          picked.path,
        ).copy(path.join(appDir.path, fileName));
        setState(() {
          _imageFile = savedImage;
        });
        break;
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final pet = Pet(
        id: widget.pet?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        species: _species,
        breed: _breedController.text.trim(),
        isPureBreed: _isPureBreed,
        age: _age,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        birthDate: _birthDate,
        gender: _gender,
        color: _colorController.text.trim(),
        microchip: _microchipController.text.trim().isEmpty
            ? null
            : _microchipController.text.trim(),
        registrationNumber: _registrationController.text.trim().isEmpty
            ? null
            : _registrationController.text.trim(),
        imageUrl: _imageFile?.path ?? '',
        description: _descriptionController.text.trim(),
      );
      widget.onPetSaved(pet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Editar Mascota' : 'Registrar Mascota'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      widget.isEdit ? 'Editar Mascota' : 'Registrar Mascota',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 54,
                                  backgroundColor: const Color(0xFFBBDEFB),
                                  backgroundImage: _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : null,
                                  child: _imageFile == null
                                      ? const Icon(
                                          Icons.add_a_photo,
                                          size: 44,
                                          color: Color(0xFF2196F3),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color(0xFF2196F3),
                                          width: 2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Color(0xFF2196F3),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Nombre
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              prefixIcon: const Icon(
                                Icons.pets,
                                color: Color(0xFF2196F3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'Ingrese el nombre'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          // Especie y Raza
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _species,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Gato',
                                      child: Text('Gato'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Perro',
                                      child: Text('Perro'),
                                    ),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _species = v ?? 'Gato'),
                                  decoration: InputDecoration(
                                    labelText: 'Especie',
                                    prefixIcon: const Icon(
                                      Icons.pets,
                                      color: Color(0xFF2196F3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _breedController,
                                  decoration: InputDecoration(
                                    labelText: 'Raza',
                                    prefixIcon: const Icon(
                                      Icons.category,
                                      color: Color(0xFF2196F3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Raza pura
                          SwitchListTile(
                            value: _isPureBreed,
                            onChanged: (v) => setState(() => _isPureBreed = v),
                            title: const Text('¿Raza pura?'),
                            activeThumbColor: const Color(0xFF2196F3),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 12),
                          // Peso y Género
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  decoration: InputDecoration(
                                    labelText: 'Peso (kg)',
                                    prefixIcon: const Icon(
                                      Icons.monitor_weight,
                                      color: Color(0xFF2196F3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _gender,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Hembra',
                                      child: Text('Hembra'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Macho',
                                      child: Text('Macho'),
                                    ),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _gender = v ?? 'Hembra'),
                                  decoration: InputDecoration(
                                    labelText: 'Género',
                                    prefixIcon: const Icon(
                                      Icons.wc,
                                      color: Color(0xFF2196F3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Color
                          TextFormField(
                            controller: _colorController,
                            decoration: InputDecoration(
                              labelText: 'Color',
                              prefixIcon: const Icon(
                                Icons.palette,
                                color: Color(0xFF2196F3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Edad y Fecha de nacimiento
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Edad (años)',
                                    prefixIcon: const Icon(
                                      Icons.cake,
                                      color: Color(0xFF2196F3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  initialValue: _age.toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => setState(
                                    () => _age = int.tryParse(v) ?? 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Fecha de nacimiento (opcional)',
                                    prefixIcon: const Icon(
                                      Icons.event,
                                      color: Color(0xFF2196F3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: _birthDate != null
                                        ? _birthDate!
                                              .toLocal()
                                              .toString()
                                              .split(' ')[0]
                                        : '',
                                  ),
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().subtract(
                                        Duration(days: 365 * _age),
                                      ),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      setState(() => _birthDate = picked);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Microchip y registro (ocultos por ahora)
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: TextFormField(
                          //         controller: _microchipController,
                          //         decoration: InputDecoration(
                          //           labelText: 'Microchip (opcional)',
                          //           prefixIcon: const Icon(
                          //             Icons.qr_code,
                          //             color: Color(0xFF2196F3),
                          //           ),
                          //           border: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           ),
                          //           filled: true,
                          //           fillColor: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 10),
                          //     Expanded(
                          //       child: TextFormField(
                          //         controller: _registrationController,
                          //         decoration: InputDecoration(
                          //           labelText: 'N° de registro (opcional)',
                          //           prefixIcon: const Icon(
                          //             Icons.confirmation_number,
                          //             color: Color(0xFF2196F3),
                          //           ),
                          //           border: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           ),
                          //           filled: true,
                          //           fillColor: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 12),
                          // Descripción
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Descripción',
                              prefixIcon: const Icon(
                                Icons.description,
                                color: Color(0xFF2196F3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 24),
                          // Botón grande
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle, size: 26),
                              label: Text(
                                widget.isEdit
                                    ? 'Guardar Cambios'
                                    : 'Registrar Mascota',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              onPressed: _submit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
