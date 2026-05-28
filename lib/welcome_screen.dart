// Popup juvenil y atractivo para info de especie
import 'package:flutter/material.dart';

// Popup juvenil y atractivo para info de especie
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header compacto y moderno
              Container(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 0,
                  right: 0,
                  bottom: 18,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2196F3), Color(0xFF90CAF9)],
                  ),
                ),
                child: Center(
                  child: Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Accesos rápidos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _HomeCard(
                    title: 'Mis Mascotas',
                    subtitle: 'Gestiona el perfil de tus mascotas',
                    color: Color(0xFF4FC3F7),
                    image: 'assets/icons/cat.png',
                    onTap: () => Navigator.pushNamed(context, '/pets'),
                    cardWidth: 140,
                    cardHeight: 140,
                    imageSize: 64,
                  ),
                  const SizedBox(width: 20),
                  _HomeCard(
                    title: 'Razas',
                    subtitle: 'Explora razas de perros y gatos',
                    color: Color(0xFF81C784),
                    image: 'assets/icons/dog.png',
                    onTap: () => Navigator.pushNamed(context, '/breeds'),
                    cardWidth: 140,
                    cardHeight: 140,
                    imageSize: 64,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Botones de especie
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    _SpeciesButton(
                      icon: Icons.pets,
                      label: 'Perros',
                      color: Color(0xFFFFECB3),
                      textColor: Color(0xFF1976D2),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              _SpeciesInfoDialog(species: 'Perro'),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _SpeciesButton(
                      icon: Icons.pets,
                      label: 'Gatos',
                      color: Color(0xFFFFCCBC),
                      textColor: Color(0xFFD84315),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              _SpeciesInfoDialog(species: 'Gato'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Consejos destacados
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
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black26,
                            endIndent: 8,
                          ),
                        ),
                        Text(
                          'Consejos Destacados',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black26,
                            indent: 8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100.withAlpha(
                              (0.3 * 255).toInt(),
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/icons/bowl.png',
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 4.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '¿Cómo elegir el mejor alimento para tu mascota?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Descúbrelo aquí',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 12,
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
              const SizedBox(height: 16),

              // Consejos rápidos para el cuidado
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
                    _QuickTipCard(
                      icon: Icons.shower,
                      title: '¿Cada cuánto debo bañar a mi mascota?',
                      tip:
                          'En general, los perros cada 1-2 meses y los gatos solo si están muy sucios.',
                    ),
                    const SizedBox(height: 8),
                    _QuickTipCard(
                      icon: Icons.monitor_heart,
                      title: '¿Cómo detectar si mi mascota está enferma?',
                      tip:
                          'Observa cambios en apetito, energía, pelaje o comportamiento. Ante dudas, consulta al veterinario.',
                    ),
                    const SizedBox(height: 8),
                    _QuickTipCard(
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
          onTap: (index) {},
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

// Tarjeta principal de acceso rápido
class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String image;
  final VoidCallback onTap;
  final double cardWidth;
  final double cardHeight;
  final double imageSize;
  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.image,
    required this.onTap,
    this.cardWidth = 110,
    this.cardHeight = 110,
    this.imageSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.18 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                image,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tarjeta de consejo rápido
class _QuickTipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String tip;
  const _QuickTipCard({
    required this.icon,
    required this.title,
    required this.tip,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withAlpha((0.08 * 255).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: Colors.orange, size: 22),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 2.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    tip,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Botón de especie
class _SpeciesButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  const _SpeciesButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha((0.13 * 255).toInt()),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
