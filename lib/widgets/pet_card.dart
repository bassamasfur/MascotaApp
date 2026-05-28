import 'package:flutter/material.dart';
import '../models/pet.dart';

/// Widget que muestra la información de una mascota en forma de tarjeta
class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onDelete;

  const PetCard({super.key, required this.pet, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Row(
          children: [
            // Avatar con emoji
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getColorForSpecies(pet.species),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(pet.imageUrl, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 18),
            // Solo nombre
            Expanded(
              child: Text(
                pet.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            // Botón de eliminar
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red[400],
              onPressed: onDelete,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }

  /// Obtiene un color basado en la especie
  Color _getColorForSpecies(String species) {
    switch (species.toLowerCase()) {
      case 'perro':
        return Colors.blue[100]!;
      case 'gato':
        return Colors.orange[100]!;
      case 'loro':
      case 'ave':
        return Colors.green[100]!;
      case 'pez':
        return Colors.cyan[100]!;
      case 'conejo':
        return Colors.pink[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  // ...existing code...
}
