import 'package:flutter/material.dart';
import '../models/pet.dart';

import '../widgets/pet_card.dart';
import 'pet_detail_view.dart';

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
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Eliminar mascota'),
                          content: const Text(
                            '¿Seguro que deseas eliminar esta mascota?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        onDeletePet(pet);
                      }
                    },
                    onEdit: () => onEditPet(pet),
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
