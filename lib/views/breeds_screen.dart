import 'package:flutter/material.dart';
import '../controllers/breed_controller.dart';
import '../widgets/breed_card.dart';
import '../models/breed.dart';

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  State<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  String _selectedType = 'Perro';
  final BreedController _controller = BreedController();
  late Future<List<Breed>> _futureBreeds;

  @override
  void initState() {
    super.initState();
    _futureBreeds = _controller.getBreeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Razas de Perros y Gatos')),
      body: FutureBuilder<List<Breed>>(
        future: _futureBreeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay razas disponibles.'));
          }
          final breeds = snapshot.data!;
          final filtered = breeds
              .where(
                (b) => b.especie.toLowerCase() == _selectedType.toLowerCase(),
              )
              .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Mostrar:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(value: 'Perro', child: Text('Perros')),
                        DropdownMenuItem(value: 'Gato', child: Text('Gatos')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedType = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final breed = filtered[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              breed.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        breed.imagenUrl,
                                        width: 140,
                                        height: 140,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          width: 140,
                                          height: 140,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.pets,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Especie: \\${breed.especie}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tamaño: \\${breed.caracteristicas['tamano'] ?? '-'}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    'Peso: \\${breed.caracteristicas['peso'] ?? '-'}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    'Esperanza de vida: \\${breed.caracteristicas['vida'] ?? '-'}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Temperamento:',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    breed.temperamento.join(", "),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  if (breed.descripcion != null &&
                                      breed.descripcion!.isNotEmpty)
                                    Text(
                                      'Descripción: \\${breed.descripcion}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: BreedCard(breed: breed),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
