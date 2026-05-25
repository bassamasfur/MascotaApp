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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Razas de Perros y Gatos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2196F3), Color(0xFF90CAF9)],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<Breed>>(
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
                    (b) =>
                        b.especie.toLowerCase() == _selectedType.toLowerCase(),
                  )
                  .toList();
              return ListView.builder(
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
                          contentPadding: const EdgeInsets.all(0),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Imagen principal mejorada
                                SizedBox(
                                  height: 140,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: Image.network(
                                      breed.imagenUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (c, e, s) => Container(
                                        height: 120,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.pets,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        breed.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      // Características
                                      Card(
                                        color: const Color(0xFFFFF8E1),
                                        margin: const EdgeInsets.only(
                                          bottom: 6,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.info,
                                                color: Colors.amber,
                                                size: 22,
                                              ),
                                              const SizedBox(width: 7),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Tamaño: ${breed.caracteristicas['tamano'] ?? '-'}',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Peso: ${breed.caracteristicas['peso'] ?? '-'}',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Vida: ${breed.caracteristicas['vida'] ?? '-'}',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Temperamento
                                      Card(
                                        color: const Color(0xFFE3F2FD),
                                        margin: const EdgeInsets.only(
                                          bottom: 6,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.emoji_emotions,
                                                color: Colors.orange,
                                                size: 22,
                                              ),
                                              const SizedBox(width: 7),
                                              Expanded(
                                                child: Wrap(
                                                  spacing: 4,
                                                  runSpacing: 2,
                                                  children: breed.temperamento
                                                      .map(
                                                        (t) => Chip(
                                                          label: Text(
                                                            t,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                          backgroundColor:
                                                              Colors
                                                                  .blue
                                                                  .shade50,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Cuidados
                                      if (breed.cuidados.isNotEmpty)
                                        Card(
                                          color: const Color(0xFFE1F5FE),
                                          margin: const EdgeInsets.only(
                                            bottom: 6,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.restaurant,
                                                  color: Colors.blue,
                                                  size: 22,
                                                ),
                                                const SizedBox(width: 7),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: breed.cuidados
                                                        .map(
                                                          (c) => Text(
                                                            '• $c',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      // Salud
                                      if (breed.salud.isNotEmpty)
                                        Card(
                                          color: const Color(0xFFFFEBEE),
                                          margin: const EdgeInsets.only(
                                            bottom: 6,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.health_and_safety,
                                                  color: Colors.red,
                                                  size: 22,
                                                ),
                                                const SizedBox(width: 7),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: breed.salud
                                                        .map(
                                                          (s) => Text(
                                                            '• $s',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      // Curiosidades
                                      if (breed.curiosidades.isNotEmpty)
                                        Card(
                                          color: const Color(0xFFF3E5F5),
                                          margin: const EdgeInsets.only(
                                            bottom: 6,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.lightbulb,
                                                  color: Colors.purple,
                                                  size: 22,
                                                ),
                                                const SizedBox(width: 7),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: breed.curiosidades
                                                        .map(
                                                          (c) => Text(
                                                            '• $c',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
