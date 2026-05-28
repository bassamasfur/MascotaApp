import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../views/register_pet_view.dart';
import '../views/pet_list_view.dart';
import '../views/edit_pet_view.dart';

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PetAppRoot extends StatefulWidget {
  const PetAppRoot({super.key});
  @override
  State<PetAppRoot> createState() => _PetAppRootState();
}

class _PetAppRootState extends State<PetAppRoot> {
  List<Pet> _pets = [];
  // Pet? _selectedPet;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final petsJson = prefs.getString('pets_data');
    if (petsJson != null) {
      final petsList = (jsonDecode(petsJson) as List)
          .map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        _pets = petsList;
        _loading = false;
      });
    } else {
      setState(() {
        _pets = [];
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
  }

  void _addPet(Pet pet) async {
    setState(() {
      _pets.add(pet);
    });
    await _savePets();
  }

  void _editPet(Pet updatedPet) async {
    setState(() {
      final idx = _pets.indexWhere((p) => p.id == updatedPet.id);
      if (idx != -1) {
        _pets[idx] = updatedPet;
      }
    });
    await _savePets();
  }

  void _deletePet(Pet pet) async {
    setState(() {
      _pets.removeWhere((p) => p.id == pet.id);
    });
    await _savePets();
  }

  // Ya no se necesita _selectPet

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
    // Siempre mostrar la lista de mascotas
    return PetListView(
      pets: _pets,
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
}
