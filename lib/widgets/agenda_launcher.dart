import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_list_provider.dart' as global_prov;
import '../views/agenda_screen.dart';

import '../views/pet_agenda_detail_screen.dart';

class AgendaLauncher extends StatelessWidget {
  const AgendaLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    final petListProvider = Provider.of<global_prov.PetListProvider>(context);
    return AgendaScreen(
      pets: petListProvider.pets,
      onSelectPet: (pet) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PetAgendaDetailScreen(pet: pet)),
        );
      },
    );
  }
}
