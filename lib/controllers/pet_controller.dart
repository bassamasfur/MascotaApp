import 'package:flutter/material.dart';
import '../models/pet.dart';

/// Controlador que maneja la lógica de negocio de las mascotas
class PetController extends ChangeNotifier {
  List<Pet> _pets = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Lista de mascotas
  List<Pet> get pets => List.unmodifiable(_pets);

  /// Indica si se está cargando información
  bool get isLoading => _isLoading;

  /// Mensaje de error si existe
  String? get errorMessage => _errorMessage;

  /// Constructor que inicializa con datos de ejemplo
  PetController() {
    _initializeSampleData();
  }

  /// Inicializa datos de ejemplo
  void _initializeSampleData() {
    _pets = [
      Pet(
        id: '1',
        name: 'Max',
        species: 'Perro',
        breed: 'Labrador',
        isPureBreed: false,
        age: 3,
        weight: 25.0,
        birthDate: DateTime(2023, 5, 1),
        gender: 'Macho',
        color: 'Marrón',
        microchip: '123456789',
        registrationNumber: 'REG001',
        imageUrl: '', // Aquí podrías poner una ruta de imagen local si tienes
        description: 'Un perro amigable y juguetón',
      ),
      Pet(
        id: '2',
        name: 'Luna',
        species: 'Gato',
        breed: 'Mestizo',
        isPureBreed: false,
        age: 2,
        weight: 4.2,
        birthDate: DateTime(2024, 1, 10),
        gender: 'Hembra',
        color: 'Gris',
        microchip: null,
        registrationNumber: null,
        imageUrl: '',
        description: 'Una gata cariñosa y tranquila',
      ),
      Pet(
        id: '3',
        name: 'Coco',
        species: 'Loro',
        breed: 'Amazonas',
        isPureBreed: true,
        age: 5,
        weight: 0.5,
        birthDate: DateTime(2021, 7, 20),
        gender: 'Macho',
        color: 'Verde',
        microchip: null,
        registrationNumber: null,
        imageUrl: '',
        description: 'Un loro parlanchín y colorido',
      ),
    ];
    notifyListeners();
  }

  /// Agrega una nueva mascota
  Future<void> addPet(Pet pet) async {
    _setLoading(true);
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simula una operación async
      _pets.add(pet);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al agregar mascota: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza una mascota existente
  Future<void> updatePet(Pet updatedPet) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _pets.indexWhere((pet) => pet.id == updatedPet.id);
      if (index != -1) {
        _pets[index] = updatedPet;
        _errorMessage = null;
        notifyListeners();
      } else {
        throw Exception('Mascota no encontrada');
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar mascota: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina una mascota
  Future<void> deletePet(String petId) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _pets.removeWhere((pet) => pet.id == petId);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al eliminar mascota: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene una mascota por su ID
  Pet? getPetById(String petId) {
    try {
      return _pets.firstWhere((pet) => pet.id == petId);
    } catch (e) {
      return null;
    }
  }

  /// Filtra mascotas por especie
  List<Pet> filterBySpecies(String species) {
    return _pets
        .where((pet) => pet.species.toLowerCase() == species.toLowerCase())
        .toList();
  }

  /// Método privado para cambiar el estado de carga
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Limpia el mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
