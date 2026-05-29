import 'package:flutter/material.dart';
import '../models/pet.dart';

class AgendaScreen extends StatelessWidget {
  final List<Pet> pets;
  final void Function(Pet) onSelectPet;

  const AgendaScreen({
    super.key,
    required this.pets,
    required this.onSelectPet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda de Mascotas')),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return ListTile(
            leading: CircleAvatar(child: Text(pet.name[0])),
            title: Text(pet.name),
            subtitle: Text(pet.species),
            onTap: () => onSelectPet(pet),
          );
        },
      ),
    );
  }
}
