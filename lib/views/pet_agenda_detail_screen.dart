import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../models/pet_activity.dart';
import '../models/activity_type.dart';
import '../models/activity_schedule.dart';
import 'package:provider/provider.dart';
import '../providers/pet_list_provider.dart';

class PetAgendaDetailScreen extends StatefulWidget {
  final Pet pet;
  const PetAgendaDetailScreen({super.key, required this.pet});

  @override
  State<PetAgendaDetailScreen> createState() => _PetAgendaDetailScreenState();
}

class _PetAgendaDetailScreenState extends State<PetAgendaDetailScreen> {
  void _deleteActivity(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar actividad'),
        content: const Text('¿Seguro que deseas eliminar esta actividad?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        _activities.removeAt(index);
      });
      // Usar el provider para actualizar y persistir
      await Provider.of<PetListProvider>(
        context,
        listen: false,
      ).updatePetActivities(widget.pet.id, _activities);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Actividad eliminada')));
      }
    }
  }

  late List<PetActivity> _activities;

  @override
  void initState() {
    super.initState();
    // Copia local para edición en memoria
    _activities = List<PetActivity>.from(widget.pet.activities);
  }

  String _activityTypeLabel(ActivityType type) {
    switch (type) {
      case ActivityType.comida:
        return 'Comida';
      case ActivityType.agua:
        return 'Agua';
      case ActivityType.medicamento:
        return 'Medicamento';
      case ActivityType.necesidades:
        return widget.pet.species.toLowerCase() == 'gato'
            ? 'Limpieza de arenero'
            : 'Paseo';
    }
  }

  void _showActivityModal({PetActivity? activity, int? index}) {
    ActivityType? selectedType = activity?.type;
    TimeOfDay? selectedTime = activity != null && activity.schedules.isNotEmpty
        ? TimeOfDay(
            hour: activity.schedules.first.time.hour,
            minute: activity.schedules.first.time.minute,
          )
        : null;
    final notesController = TextEditingController(text: activity?.notes ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity == null ? 'Nueva Actividad' : 'Editar Actividad',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Tipo de actividad
                  const Text('Tipo de actividad'),
                  DropdownButtonFormField<ActivityType>(
                    initialValue: selectedType,
                    items: ActivityType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() => selectedType = value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Hora
                  const Text('Hora'),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setModalState(() => selectedTime = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: selectedTime == null
                              ? 'Selecciona la hora'
                              : selectedTime!.format(context),
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Notas
                  const Text('Notas (opcional)'),
                  TextFormField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Notas adicionales',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedType != null && selectedTime != null) {
                            final now = DateTime.now();
                            final scheduleId =
                                activity?.schedules.first.id ??
                                now.microsecondsSinceEpoch.toString();
                            final today = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );
                            final editedActivity = PetActivity(
                              id:
                                  activity?.id ??
                                  now.millisecondsSinceEpoch.toString(),
                              type: selectedType!,
                              schedules: [
                                ActivitySchedule(
                                  id: scheduleId,
                                  time: today,
                                  details: '',
                                ),
                              ],
                              notes: notesController.text,
                              enabled: true,
                            );
                            setState(() {
                              if (activity == null) {
                                _activities.add(editedActivity);
                              } else if (index != null) {
                                _activities[index] = editedActivity;
                              }
                            });
                            // Usar el provider para actualizar y persistir
                            await Provider.of<PetListProvider>(
                              context,
                              listen: false,
                            ).updatePetActivities(widget.pet.id, _activities);
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Text(
                          activity == null ? 'Guardar' : 'Actualizar',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agenda de ${widget.pet.name}')),
      body: _activities.isEmpty
          ? const Center(child: Text('No hay actividades configuradas'))
          : ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _activityTypeLabel(activity.type),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Editar',
                              onPressed: () {
                                _showActivityModal(
                                  activity: activity,
                                  index: index,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Eliminar',
                              color: Colors.red,
                              onPressed: () => _deleteActivity(index),
                            ),
                          ],
                        ),
                        if (activity.notes != null &&
                            activity.notes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(
                              activity.notes!,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ...activity.schedules.map(
                          (s) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.schedule),
                            title: Text(
                              '${s.time.hour.toString().padLeft(2, '0')}:${s.time.minute.toString().padLeft(2, '0')}',
                            ),
                            subtitle: s.details != null
                                ? Text(s.details!)
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              onPressed: () {
                                // Aquí se podría marcar como realizada (futuro)
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showActivityModal(),
        tooltip: 'Agregar actividad',
        child: const Icon(Icons.add),
      ),
    );
  }
}
