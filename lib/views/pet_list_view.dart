import 'package:flutter/material.dart';
import '../models/pet.dart';

import '../widgets/pet_card.dart';
import 'pet_detail_view.dart';
import 'register_pet_view.dart';

class PetListView extends StatelessWidget {
  final List<Pet> pets;
  // final void Function(Pet) onSelectPet;
  final void Function(Pet) onDeletePet;
  final VoidCallback onAddPet;

  const PetListView({
    super.key,
    required this.pets,
    // required this.onSelectPet,
    required this.onDeletePet,
    required this.onAddPet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Mascotas')),
      body: pets.isEmpty
          ? const Center(child: Text('No hay mascotas registradas'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PetDetailView(pet: pet),
                      ),
                    );
                  },
                  child: PetCard(
                    pet: pet,
                    onDelete: () => onDeletePet(pet),
                    onEdit: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RegisterPetView(
                            onPetRegistered: (editedPet) {
                              // Aquí deberías actualizar la mascota editada en la lista principal
                              // Este callback debe ser manejado en el widget padre (PetAppRoot)
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAddPet,
        icon: const Icon(Icons.add),
        label: const Text('Añadir Mascota'),
      ),
    );
  }
}
