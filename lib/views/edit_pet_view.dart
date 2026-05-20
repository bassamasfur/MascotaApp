import 'dart:io';
import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'package:image_picker/image_picker.dart';

class EditPetView extends StatefulWidget {
  final Pet pet;
  final void Function(Pet) onPetEdited;
  const EditPetView({super.key, required this.pet, required this.onPetEdited});

  @override
  State<EditPetView> createState() => _EditPetViewState();
}

class _EditPetViewState extends State<EditPetView> {
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
    _nameController = TextEditingController(text: pet.name);
    _breedController = TextEditingController(text: pet.breed);
    _weightController = TextEditingController(text: pet.weight.toString());
    _colorController = TextEditingController(text: pet.color);
    _descriptionController = TextEditingController(text: pet.description);
    _microchipController = TextEditingController(text: pet.microchip ?? '');
    _registrationController = TextEditingController(
      text: pet.registrationNumber ?? '',
    );
    _species = pet.species;
    _gender = pet.gender;
    _isPureBreed = pet.isPureBreed;
    _age = pet.age;
    _birthDate = pet.birthDate;
    if (pet.imageUrl.isNotEmpty) {
      _imageFile = File(pet.imageUrl);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _submit() {
    final pet = Pet(
      id: widget.pet.id,
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
    widget.onPetEdited(pet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Mascota')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: const Icon(Icons.pets, color: Color(0xFF2196F3)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _species,
                      items: const [
                        DropdownMenuItem(value: 'Gato', child: Text('Gato')),
                        DropdownMenuItem(value: 'Perro', child: Text('Perro')),
                      ],
                      onChanged: (v) => setState(() => _species = v ?? 'Gato'),
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
              SwitchListTile(
                value: _isPureBreed,
                onChanged: (v) => setState(() => _isPureBreed = v),
                title: const Text('¿Raza pura?'),
                activeColor: Color(0xFF2196F3),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
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
                      value: _gender,
                      items: const [
                        DropdownMenuItem(
                          value: 'Hembra',
                          child: Text('Hembra'),
                        ),
                        DropdownMenuItem(value: 'Macho', child: Text('Macho')),
                      ],
                      onChanged: (v) => setState(() => _gender = v ?? 'Hembra'),
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
                      onChanged: (v) =>
                          setState(() => _age = int.tryParse(v) ?? 1),
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
                            ? _birthDate!.toLocal().toString().split(' ')[0]
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
                        if (picked != null) setState(() => _birthDate = picked);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _microchipController,
                      decoration: InputDecoration(
                        labelText: 'Microchip (opcional)',
                        prefixIcon: const Icon(
                          Icons.qr_code,
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
                      controller: _registrationController,
                      decoration: InputDecoration(
                        labelText: 'N° de registro (opcional)',
                        prefixIcon: const Icon(
                          Icons.confirmation_number,
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
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, size: 26),
                  label: const Text(
                    'Guardar Cambios',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}
