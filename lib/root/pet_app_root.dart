import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../views/register_pet_view.dart';
import '../views/pet_list_view.dart';
import '../views/edit_pet_view.dart';
import '../widgets/pet_profile_cards.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PetAppRoot extends StatefulWidget {
  const PetAppRoot({Key? key}) : super(key: key);
  @override
  State<PetAppRoot> createState() => _PetAppRootState();
}

class _PetAppRootState extends State<PetAppRoot> {
  List<Pet> _pets = [];
  Pet? _selectedPet;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final petsJson = prefs.getString('pets_data');
    final selectedId = prefs.getString('selected_pet_id');
    if (petsJson != null) {
      final petsList = (jsonDecode(petsJson) as List)
          .map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList();
      Pet? selectedPet;
      if (selectedId != null) {
        final found = petsList.where((p) => p.id == selectedId);
        selectedPet = found.isNotEmpty
            ? found.first
            : (petsList.isNotEmpty ? petsList.first : null);
      } else {
        selectedPet = petsList.isNotEmpty ? petsList.first : null;
      }
      setState(() {
        _pets = petsList;
        _selectedPet = selectedPet;
        _loading = false;
      });
    } else {
      setState(() {
        _pets = [];
        _selectedPet = null;
        _loading = false;
      });
    }
  }

  Future<void> _savePets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'pets_data',
      jsonEncode(_pets.map((e) => e.toJson()).toList()),
    );
    if (_selectedPet != null) {
      await prefs.setString('selected_pet_id', _selectedPet!.id);
    }
  }

  void _addPet(Pet pet) async {
    setState(() {
      _pets.add(pet);
      _selectedPet = pet;
    });
    await _savePets();
  }

  void _editPet(Pet updatedPet) async {
    setState(() {
      final idx = _pets.indexWhere((p) => p.id == updatedPet.id);
      if (idx != -1) {
        _pets[idx] = updatedPet;
        _selectedPet = updatedPet;
      }
    });
    await _savePets();
  }

  void _deletePet(Pet pet) async {
    setState(() {
      _pets.removeWhere((p) => p.id == pet.id);
      if (_selectedPet?.id == pet.id) {
        _selectedPet = _pets.isNotEmpty ? _pets.first : null;
      }
    });
    await _savePets();
  }

  void _selectPet(Pet pet) async {
    setState(() {
      _selectedPet = pet;
    });
    await _savePets();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_pets.isEmpty) {
      return RegisterPetView(
        onPetRegistered: (pet) {
          _addPet(pet);
        },
      );
    }
    if (_selectedPet == null) {
      // Si no hay mascota seleccionada, mostrar lista
      return PetListView(
        pets: _pets,
        onSelectPet: (pet) => _selectPet(pet),
        onDeletePet: (pet) => _deletePet(pet),
        onAddPet: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RegisterPetView(
                onPetRegistered: (pet) {
                  Navigator.of(context).pop();
                  _addPet(pet);
                },
              ),
            ),
          );
        },
      );
    }
    // Pantalla de perfil de mascota seleccionada
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Mascota'),
        backgroundColor: const Color(0xFFF7F8FC),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar mascota',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditPetView(
                    pet: _selectedPet!,
                    onPetEdited: (updatedPet) {
                      Navigator.of(context).pop();
                      _editPet(updatedPet);
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.pets),
            tooltip: 'Cambiar mascota',
            onPressed: () {
              setState(() {
                _selectedPet = null;
              });
            },
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F8FC),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // Foto de perfil destacada
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade50,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _selectedPet!.imageUrl.isNotEmpty
                          ? Image.file(File(_selectedPet!.imageUrl)).image
                          : null,
                      backgroundColor: Colors.transparent,
                      child: _selectedPet!.imageUrl.isEmpty
                          ? const Icon(
                              Icons.pets,
                              size: 60,
                              color: Colors.blueGrey,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Card de info básica
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 12,
                      ),
                      child: Column(
                        children: [
                          Text(
                            _selectedPet!.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_selectedPet!.species} | ${_selectedPet!.age} años',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Peso: ${_selectedPet!.weight} kg',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Raza: Mestizo',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ...rest of the profile UI...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
