import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/notification_center_provider.dart';
import 'providers/pet_list_provider.dart' as global_prov;
import 'views/pet_list_view.dart';
import 'views/register_edit_pet_view.dart';
import 'views/register_pet_view.dart';
import 'widgets/agenda_launcher.dart';
import 'widgets/home_card.dart';
import 'widgets/quick_tip_card.dart';
import 'widgets/species_button.dart';

class _SpeciesInfoDialog extends StatelessWidget {
  final String species;

  const _SpeciesInfoDialog({required this.species});

  @override
  Widget build(BuildContext context) {
    final isDog = species.toLowerCase().contains('perro');
    final color = isDog ? const Color(0xFF1976D2) : const Color(0xFFD84315);
    final emoji = isDog ? '🐶' : '🐱';
    final title = isDog ? '¡Sobre los Perros!' : '¡Sobre los Gatos!';
    final desc = isDog
        ? 'Los perros son leales, sociales y juguetones. Disfrutan de la compañía humana, los paseos y los juegos al aire libre.'
        : 'Los gatos son curiosos, independientes y cariñosos a su manera. Les encanta explorar, dormir y jugar con objetos pequeños.';
    final tips = isDog
        ? [
            ['🌳', 'Aman los paseos y explorar nuevos lugares.'],
            ['🎾', 'Disfrutan de juegos como buscar la pelota.'],
            ['🦴', 'El refuerzo positivo y las rutinas los hacen felices.'],
          ]
        : [
            ['🪴', 'Les gusta trepar y observar desde lugares altos.'],
            ['🧹', 'Prefieren la limpieza y el arenero limpio.'],
            ['🧶', 'Son muy juguetones con objetos pequeños.'],
          ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              desc,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tip[0], style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip[1],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '¡Entendido!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _showNotificationsSheet(BuildContext context) async {
    final notificationProvider = Provider.of<NotificationCenterProvider>(
      context,
      listen: false,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 10, 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Notificaciones',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: notificationProvider.items.isEmpty
                              ? null
                              : () => notificationProvider.clearAll(),
                          child: const Text('Limpiar todo'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: notificationProvider,
                      builder: (context, _) {
                        if (notificationProvider.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (notificationProvider.items.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'No hay notificaciones aún.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          itemCount: notificationProvider.items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final notification =
                                notificationProvider.items[index];
                            return Card(
                              color: const Color(0xFFFFF8E1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.notifications,
                                      color: Colors.orange,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notification.title,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (notification.body.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              notification.body,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 6),
                                          Text(
                                            TimeOfDay.fromDateTime(
                                              notification.receivedAt,
                                            ).format(context),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => notificationProvider
                                          .removeNotification(notification.id),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final petListProvider = Provider.of<global_prov.PetListProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 16,
                  right: 16,
                  bottom: 18,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2196F3), Color(0xFF90CAF9)],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      '¡Bienvenido!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Consumer<NotificationCenterProvider>(
                        builder: (context, notificationProvider, _) {
                          return IconButton(
                            onPressed: () => _showNotificationsSheet(context),
                            icon: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                if (notificationProvider.items.isNotEmpty)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            tooltip: 'Ver notificaciones',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: HomeCard(
                        title: 'Mis Mascotas',
                        subtitle: 'Gestiona el perfil de tus mascotas',
                        color: const Color(0xFF4FC3F7),
                        image: 'assets/icons/mascotas.png',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PetListView(
                                pets: petListProvider.pets,
                                onDeletePet: (pet) async {
                                  await petListProvider.deletePet(pet);
                                  Navigator.of(context).pop();
                                },
                                onAddPet: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => RegisterPetView(
                                        onPetRegistered: (pet) async {
                                          Navigator.of(
                                            context,
                                          ).popUntil((route) => route.isFirst);
                                          await petListProvider.addPet(pet);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                onEditPet: (pet) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => RegisterEditPetView(
                                        pet: pet,
                                        isEdit: true,
                                        onPetSaved: (editedPet) async {
                                          Navigator.of(
                                            context,
                                          ).popUntil((route) => route.isFirst);
                                          await petListProvider.editPet(
                                            editedPet,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        cardWidth: double.infinity,
                        cardHeight: 188,
                        imageSize: 116,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HomeCard(
                        title: 'Razas',
                        subtitle: 'Explora razas de perros y gatos',
                        color: const Color(0xFF81C784),
                        image: 'assets/icons/razas.png',
                        onTap: () => Navigator.pushNamed(context, '/breeds'),
                        cardWidth: double.infinity,
                        cardHeight: 188,
                        imageSize: 116,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SpeciesButton(
                        icon: Icons.pets,
                        label: 'Perros',
                        color: const Color(0xFFFFECB3),
                        textColor: const Color(0xFF1976D2),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                const _SpeciesInfoDialog(species: 'Perro'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SpeciesButton(
                        icon: Icons.pets,
                        label: 'Gatos',
                        color: const Color(0xFFFFCCBC),
                        textColor: const Color(0xFFD84315),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                const _SpeciesInfoDialog(species: 'Gato'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.tips_and_updates,
                          color: Colors.orange,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Consejos Rápidos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    QuickTipCard(
                      icon: Icons.shower,
                      title: '¿Cada cuánto debo bañar a mi mascota?',
                      tip:
                          'En general, los perros cada 1-2 meses y los gatos solo si están muy sucios.',
                    ),
                    const SizedBox(height: 8),
                    QuickTipCard(
                      icon: Icons.monitor_heart,
                      title: '¿Cómo detectar si mi mascota está enferma?',
                      tip:
                          'Observa cambios en apetito, energía, pelaje o comportamiento. Ante dudas, consulta al veterinario.',
                    ),
                    const SizedBox(height: 8),
                    QuickTipCard(
                      icon: Icons.directions_run,
                      title: '¿Cuánto ejercicio necesita?',
                      tip:
                          'Perros: mínimo 30 min diarios. Gatos: juega con ellos al menos 15 min al día.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withAlpha((0.3 * 255).toInt()),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => AgendaLauncher()));
            }
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              label: 'Agenda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety),
              label: 'Salud',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
