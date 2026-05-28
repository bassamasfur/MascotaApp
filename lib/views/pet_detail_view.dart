import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetDetailView extends StatelessWidget {
  final Pet pet;
  const PetDetailView({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        backgroundColor: Colors.blue[100],
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F8FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto grande
            Container(
              color: Colors.blue[100],
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: pet.imageUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.asset(
                            pet.imageUrl,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          '🐾',
                          style: TextStyle(
                            fontSize: 56,
                            color: Colors.blue[200],
                          ),
                        ),
                ),
              ),
            ),
            // Nombre y especie
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pets, color: Colors.blueGrey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        pet.species,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.cake, color: Colors.blueGrey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${pet.age} ${pet.age == 1 ? 'año' : 'años'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Características
            _SectionCard(
              color: Colors.yellow[50],
              icon: Icons.info_outline,
              title: 'Características',
              children: [
                _InfoRow(
                  icon: Icons.monitor_weight,
                  label: 'Peso',
                  value: '${pet.weight} kg',
                ),
                _InfoRow(icon: Icons.category, label: 'Raza', value: pet.breed),
                _InfoRow(
                  icon: Icons.color_lens,
                  label: 'Color',
                  value: pet.color,
                ),
                if (pet.birthDate != null)
                  _InfoRow(
                    icon: Icons.cake,
                    label: 'Nacimiento',
                    value:
                        '${pet.birthDate!.day}/${pet.birthDate!.month}/${pet.birthDate!.year}',
                  ),
              ],
            ),
            // Temperamento
            _SectionCard(
              color: Colors.orange[50],
              icon: Icons.emoji_emotions,
              title: 'Temperamento',
              children: [
                _BulletRow(emoji: '😊', text: 'Amigable y juguetón'),
                _BulletRow(emoji: '🤓', text: 'Inteligente y leal'),
                _BulletRow(emoji: '⚡', text: 'Activo y curioso'),
              ],
            ),
            // Cuidados
            _SectionCard(
              color: Colors.blue[50],
              icon: Icons.health_and_safety,
              title: 'Cuidados',
              children: [
                _BulletRow(emoji: '🏃‍♂️', text: 'Ejercicio diario'),
                _BulletRow(emoji: '🍽️', text: 'Dieta balanceada'),
                _BulletRow(emoji: '🩺', text: 'Revisiones veterinarias'),
              ],
            ),
            // Salud
            _SectionCard(
              color: Colors.red[50],
              icon: Icons.favorite,
              title: 'Salud',
              children: [
                _BulletRow(emoji: '⚠️', text: 'Propenso a ciertas condiciones'),
                _BulletRow(emoji: '⚖️', text: 'Control de peso recomendado'),
              ],
            ),
            // Curiosidades
            _SectionCard(
              color: Colors.green[50],
              icon: Icons.lightbulb_outline,
              title: 'Curiosidades',
              children: [
                _BulletRow(emoji: '🌍', text: 'Origen: Desconocido'),
                _BulletRow(emoji: '⭐', text: 'Mascota muy querida'),
              ],
            ),
            // Descripción
            if (pet.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  pet.description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String title;
  final List<Widget> children;
  const _SectionCard({
    this.color,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey[300]),
          const SizedBox(width: 6),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String emoji;
  final String text;
  const _BulletRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
