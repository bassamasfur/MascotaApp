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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar con emoji
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getColorForSpecies(pet.species),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(pet.imageUrl, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 16),
            // Información de la mascota
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getIconForSpecies(pet.species),
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pet.species,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.cake, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${pet.age} ${pet.age == 1 ? 'año' : 'años'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet.description,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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

  /// Obtiene un icono basado en la especie
  IconData _getIconForSpecies(String species) {
    switch (species.toLowerCase()) {
      case 'perro':
        return Icons.pets;
      case 'gato':
        return Icons.pets;
      case 'loro':
      case 'ave':
        return Icons.flutter_dash;
      case 'pez':
        return Icons.water;
      case 'conejo':
        return Icons.cruelty_free;
      default:
        return Icons.pets;
    }
  }
}
