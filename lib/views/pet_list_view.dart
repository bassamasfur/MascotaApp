import 'package:flutter/material.dart';
import '../models/pet.dart';

import '../widgets/pet_card.dart';
import 'pet_detail_view.dart';
import 'register_edit_pet_view.dart';

class PetListView extends StatelessWidget {
  final List<Pet> pets;
  final void Function(Pet) onDeletePet;
  final VoidCallback onAddPet;
  final void Function(Pet) onEditPet;

  const PetListView({
    super.key,
    required this.pets,
    required this.onDeletePet,
    required this.onAddPet,
    required this.onEditPet,
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
                    onEdit: () => onEditPet(pet),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RegisterEditPetView(
                onPetSaved: (newPet) {
                  // Aquí deberías agregar la nueva mascota a la lista principal
                  // Este callback debe ser manejado en el widget padre (PetAppRoot)
                  Navigator.of(context).pop();
                },
                isEdit: false,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Añadir Mascota'),
      ),
    );
  }
}
