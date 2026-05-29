import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../welcome_screen.dart';
import '../views/register_edit_pet_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// InheritedWidget para exponer la lista de mascotas a descendientes
class PetListProvider extends InheritedWidget {
  final List<Pet> pets;
  const PetListProvider({required this.pets, required super.child, super.key});
  static PetListProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PetListProvider>();
  @override
  bool updateShouldNotify(PetListProvider oldWidget) => pets != oldWidget.pets;
}

class PetAppRoot extends StatefulWidget {
  const PetAppRoot({super.key});
  @override
  State<PetAppRoot> createState() => PetAppRootState();
}

class PetAppRootState extends State<PetAppRoot> {
  List<Pet> _pets = [];
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

  void addPet(Pet pet) async {
    setState(() {
      _pets.add(pet);
    });
    await _savePets();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void deletePet(Pet pet) async {
    setState(() {
      _pets.removeWhere((p) => p.id == pet.id);
    });
    await _savePets();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void editPet(Pet pet) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterEditPetView(
          pet: pet,
          isEdit: true,
          onPetSaved: (editedPet) async {
            setState(() {
              final idx = _pets.indexWhere((p) => p.id == editedPet.id);
              if (idx != -1) {
                _pets[idx] = editedPet;
              }
            });
            await _savePets();
            if (!mounted) return;
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return PetListProvider(pets: _pets, child: const WelcomeScreen());
  }
}
