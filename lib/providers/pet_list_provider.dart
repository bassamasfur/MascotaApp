import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import '../models/pet_activity.dart';

class PetListProvider extends ChangeNotifier {
  List<Pet> _pets = [];
  bool _loading = true;

  List<Pet> get pets => _pets;
  bool get loading => _loading;

  PetListProvider() {
    loadPets();
  }

  Future<void> loadPets() async {
    _loading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final petsJson = prefs.getString('pets_data');
    if (petsJson != null) {
      final petsList = (jsonDecode(petsJson) as List)
          .map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList();
      _pets = petsList;
    } else {
      _pets = [];
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> savePets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'pets_data',
      jsonEncode(_pets.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> addPet(Pet pet) async {
    _pets.add(pet);
    await savePets();
    notifyListeners();
  }

  Future<void> deletePet(Pet pet) async {
    _pets.removeWhere((p) => p.id == pet.id);
    await savePets();
    notifyListeners();
  }

  Future<void> editPet(Pet pet) async {
    final idx = _pets.indexWhere((p) => p.id == pet.id);
    if (idx != -1) {
      _pets[idx] = pet;
      await savePets();
      notifyListeners();
    }
  }

  Future<void> updatePetActivities(
    String petId,
    List<PetActivity> activities,
  ) async {
    final idx = _pets.indexWhere((p) => p.id == petId);
    if (idx != -1) {
      _pets[idx] = _pets[idx].copyWith(activities: activities);
      await savePets();
      notifyListeners();
    }
  }
}
