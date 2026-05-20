import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/pet_controller.dart';
import '../models/pet.dart';

/// Diálogo para agregar una nueva mascota
class AddPetDialog extends StatefulWidget {
  final PetController controller;

  const AddPetDialog({super.key, required this.controller});

  @override
  State<AddPetDialog> createState() => _AddPetDialogState();
}

class _AddPetDialogState extends State<AddPetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedSpecies = 'Perro';
  String _selectedEmoji = '🐕';

  final Map<String, String> _speciesEmojis = {
    'Perro': '🐕',
    'Gato': '🐱',
    'Loro': '🦜',
    'Pez': '🐠',
    'Conejo': '🐰',
    'Hámster': '🐹',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Mascota'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selector de emoji
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    _selectedEmoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Campo de nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Selector de especie
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: const InputDecoration(
                  labelText: 'Especie',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _speciesEmojis.keys.map((species) {
                  return DropdownMenuItem(
                    value: species,
                    child: Row(
                      children: [
                        Text(_speciesEmojis[species]!),
                        const SizedBox(width: 8),
                        Text(species),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecies = value!;
                    _selectedEmoji = _speciesEmojis[value]!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Campo de edad
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Edad (años)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la edad';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 0 || age > 50) {
                    return 'Ingresa una edad válida (0-50)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo de descripción
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _savePet, child: const Text('Guardar')),
      ],
    );
  }

  /// Guarda la nueva mascota
  Future<void> _savePet() async {
    if (_formKey.currentState!.validate()) {
      final newPet = Pet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        species: _selectedSpecies,
        breed: 'Mestizo', // o puedes agregar un campo de raza en el formulario
        isPureBreed: false, // o puedes agregar un switch en el formulario
        age: int.parse(_ageController.text),
        weight: 0.0, // puedes agregar un campo de peso en el formulario
        birthDate: null, // puedes agregar un selector de fecha
        gender: 'Desconocido', // puedes agregar un campo de género
        color: '', // puedes agregar un campo de color
        microchip: null,
        registrationNumber: null,
        imageUrl: _selectedEmoji,
        description: _descriptionController.text.trim(),
      );

      await widget.controller.addPet(newPet);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newPet.name} ha sido agregado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
