import 'package:flutter/material.dart';
import 'views/register_pet_view.dart';
import 'views/pet_list_view.dart';
import 'views/edit_pet_view.dart';
import 'models/pet.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'widgets/pet_profile_cards.dart';

/// Clase principal de la aplicación
class PetApp extends StatelessWidget {
  const PetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: _PetAppRoot(),
    );
  }
}

/// Widget raíz que decide si mostrar registro o perfil
class _PetAppRoot extends StatefulWidget {
  @override
  State<_PetAppRoot> createState() => _PetAppRootState();
}

class _PetAppRootState extends State<_PetAppRoot> {
  List<Pet> _pets = [];
  Pet? _selectedPet;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final petsJson = prefs.getString('pets_data');
    final selectedId = prefs.getString('selected_pet_id');
    if (petsJson != null) {
      final petsList = (jsonDecode(petsJson) as List)
          .map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList();
      Pet? selectedPet;
      if (selectedId != null) {
        final found = petsList.where((p) => p.id == selectedId);
        selectedPet = found.isNotEmpty
            ? found.first
            : (petsList.isNotEmpty ? petsList.first : null);
      } else {
        selectedPet = petsList.isNotEmpty ? petsList.first : null;
      }
      setState(() {
        _pets = petsList;
        _selectedPet = selectedPet;
        _loading = false;
      });
    } else {
      setState(() {
        _pets = [];
        _selectedPet = null;
        _loading = false;
      });
    }
  }

  Future<void> _savePets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'pets_data',
      jsonEncode(_pets.map((e) => e.toJson()).toList()),
    );
    if (_selectedPet != null) {
      await prefs.setString('selected_pet_id', _selectedPet!.id);
    }
  }

  void _addPet(Pet pet) async {
    setState(() {
      _pets.add(pet);
      _selectedPet = pet;
    });
    await _savePets();
  }

  void _editPet(Pet updatedPet) async {
    setState(() {
      final idx = _pets.indexWhere((p) => p.id == updatedPet.id);
      if (idx != -1) {
        _pets[idx] = updatedPet;
        _selectedPet = updatedPet;
      }
    });
    await _savePets();
  }

  void _deletePet(Pet pet) async {
    setState(() {
      _pets.removeWhere((p) => p.id == pet.id);
      if (_selectedPet?.id == pet.id) {
        _selectedPet = _pets.isNotEmpty ? _pets.first : null;
      }
    });
    await _savePets();
  }

  void _selectPet(Pet pet) async {
    setState(() {
      _selectedPet = pet;
    });
    await _savePets();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_pets.isEmpty) {
      return RegisterPetView(
        onPetRegistered: (pet) {
          _addPet(pet);
        },
      );
    }
    if (_selectedPet == null) {
      // Si no hay mascota seleccionada, mostrar lista
      return PetListView(
        pets: _pets,
        onSelectPet: (pet) => _selectPet(pet),
        onDeletePet: (pet) => _deletePet(pet),
        onAddPet: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RegisterPetView(
                onPetRegistered: (pet) {
                  Navigator.of(context).pop();
                  _addPet(pet);
                },
              ),
            ),
          );
        },
      );
    }
    // Pantalla de perfil de mascota seleccionada
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Mascota'),
        backgroundColor: const Color(0xFFF7F8FC),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar mascota',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditPetView(
                    pet: _selectedPet!,
                    onPetEdited: (updatedPet) {
                      Navigator.of(context).pop();
                      _editPet(updatedPet);
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.pets),
            tooltip: 'Cambiar mascota',
            onPressed: () {
              setState(() {
                _selectedPet = null;
              });
            },
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F8FC),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // Foto de perfil destacada
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade50,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _selectedPet!.imageUrl.isNotEmpty
                          ? Image.file(File(_selectedPet!.imageUrl)).image
                          : null,
                      backgroundColor: Colors.transparent,
                      child: _selectedPet!.imageUrl.isEmpty
                          ? const Icon(
                              Icons.pets,
                              size: 60,
                              color: Colors.blueGrey,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Card de info básica
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 12,
                      ),
                      child: Column(
                        children: [
                          Text(
                            _selectedPet!.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_selectedPet!.species} | ${_selectedPet!.age} años',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Peso: ${_selectedPet!.weight} kg',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Raza: Mestizo',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sección Datos de Salud (cards horizontales)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos de Salud',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      IntrinsicHeight(
                        child: SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              HealthCard(
                                icon: Icons.restaurant,
                                color: Colors.orange.shade100,
                                title: 'Dieta & Alimentación',
                                subtitle: 'Comida seca 2 veces al día',
                              ),
                              const SizedBox(width: 12),
                              HealthCard(
                                icon: Icons.medication,
                                color: Colors.purple.shade100,
                                title: 'Medicamentos',
                                subtitle: 'Antiparasitario cada mes',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Sección Recordatorios destacados
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recordatorios',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ReminderCard(
                        icon: Icons.vaccines,
                        color: Colors.red.shade100,
                        title: 'Vacuna antirrábica',
                        subtitle: 'Próxima dosis: 15 Jun',
                      ),
                      const SizedBox(height: 10),
                      ReminderCard(
                        icon: Icons.local_hospital,
                        color: Colors.blue.shade100,
                        title: 'Visita al Veterinario',
                        subtitle: 'Chequeo general el 20 Jun',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Sección Sugerencias con ilustración
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withAlpha(
                            (0.15 * 255).toInt(),
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.pets, size: 40, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Sugerencias para Tom',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '• Juega con Tom al menos 15 minutos al día.',
                              ),
                              Text(
                                '• Ofrece rascadores para que tu gato pueda arañar.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Cards informativas de alimentación, ejercicio, salud y sabías que
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      InfoCard(
                        icon: Icons.restaurant_menu,
                        color: Colors.green.shade100,
                        title: 'Alimentación Recomendada',
                        content: [
                          '• Proporciónale comida seca alta en proteínas',
                          '• Sirve 2 porciones pequeñas al día para evitar el sobrepeso',
                        ],
                      ),
                      const SizedBox(height: 10),
                      InfoCard(
                        icon: Icons.directions_run,
                        color: Colors.blue.shade100,
                        title: 'Ejercicio y Actividad',
                        content: [
                          '• Juega con Tom al menos 15 minutos al día.',
                          '• Usa rascadores y juguetes interactivos para estimular su mente.',
                        ],
                      ),
                      const SizedBox(height: 10),
                      InfoCard(
                        icon: Icons.health_and_safety,
                        color: Colors.orange.shade100,
                        title: 'Cuidados de Salud',
                        content: [
                          '• Limpia sus orejas una vez por semana',
                          '• Agenda un chequeo veterinario cada 6 meses',
                        ],
                      ),
                      const SizedBox(height: 10),
                      InfoCard(
                        icon: Icons.lightbulb,
                        color: Colors.yellow.shade100,
                        title: 'Sabías que:',
                        content: [
                          'Los gatos mestizos suelen ser muy curiosos y activos. ¡Bríndale un entorno enriquecido para mantenerlo feliz!',
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Botón grande fijo al pie
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Añade Mascota',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
