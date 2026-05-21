import 'package:flutter/material.dart';
import '../models/breed.dart';

class BreedCard extends StatelessWidget {
  final Breed breed;
  const BreedCard({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                breed.imagenUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[200],
                  child: const Icon(Icons.pets, size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    breed.especie,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tamaño: ${breed.caracteristicas['tamano'] ?? '-'} | Peso: ${breed.caracteristicas['peso'] ?? '-'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Vida: ${breed.caracteristicas['vida'] ?? '-'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Temperamento: ${breed.temperamento.join(", ")}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
