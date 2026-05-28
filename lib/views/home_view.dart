import 'package:flutter/material.dart';
import '../controllers/pet_controller.dart';
import '../widgets/pet_card.dart';
import '../widgets/add_pet_dialog.dart';

/// Vista principal de la aplicación que muestra la lista de mascotas
class HomeView extends StatelessWidget {
  final PetController controller;

  const HomeView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mascotas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfo(context),
            tooltip: 'Información',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          if (controller.isLoading && controller.pets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.clearError,
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            );
          }

          if (controller.pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay mascotas registradas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Presiona el botón + para agregar una',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.pets, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.pets.length} ${controller.pets.length == 1 ? 'mascota' : 'mascotas'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.pets.length,
                  itemBuilder: (context, index) {
                    final pet = controller.pets[index];
                    return PetCard(
                      pet: pet,
                      onDelete: () => _confirmDelete(context, pet.id, pet.name),
                      onEdit: () {
                        // Aquí puedes abrir el formulario de edición o navegar a la vista de edición
                        // Por ejemplo:
                        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterPetView(...)));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPetDialog(context),
        tooltip: 'Agregar Mascota',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Muestra el diálogo para agregar una nueva mascota
  void _showAddPetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPetDialog(controller: controller),
    );
  }

  /// Confirma la eliminación de una mascota
  Future<void> _confirmDelete(
    BuildContext context,
    String petId,
    String petName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar a $petName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await controller.deletePet(petId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$petName ha sido eliminado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Muestra información sobre la aplicación
  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información'),
        content: const Text(
          'Pet App v1.0\n\n'
          'Aplicación para gestionar información de tus mascotas.\n\n'
          'Desarrollada con Flutter siguiendo el patrón MVC.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
