import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentSchedule extends StatefulWidget {
  const AppointmentSchedule({Key? key}) : super(key: key);

  @override
  State<AppointmentSchedule> createState() => _AppointmentScheduleState();
}

class _AppointmentScheduleState extends State<AppointmentSchedule> {
  bool _showAllAppointments = false;
  final List<Appointment> _appointments = [
    Appointment(
      patientName: 'Jean Dupont',
      patientInitials: 'JD',
      startTime: '09:00',
      endTime: '09:30',
      status: AppointmentStatus.scheduled,
      description: 'Consultation de routine',
    ),
    Appointment(
      patientName: 'Marie Martin',
      patientInitials: 'MM',
      startTime: '10:00',
      endTime: '10:45',
      status: AppointmentStatus.inProgress,
      description: 'Examen post-opératoire',
    ),
    Appointment(
      patientName: 'Pierre Durand',
      patientInitials: 'PD',
      startTime: '11:15',
      endTime: '11:45',
      status: AppointmentStatus.completed,
      description: 'Contrôle de la vision',
    ),
    Appointment(
      patientName: 'Sophie Bernard',
      patientInitials: 'SB',
      startTime: '14:00',
      endTime: '14:30',
      status: AppointmentStatus.scheduled,
      description: 'Examen de la rétine',
    ),
    Appointment(
      patientName: 'Thomas Moreau',
      patientInitials: 'TM',
      startTime: '15:30',
      endTime: '16:00',
      status: AppointmentStatus.cancelled,
      description: 'Consultation pour lentilles',
    ),
    // Ajoutez d'autres rendez-vous ici qui seront affichés uniquement lorsque "Voir tous" est cliqué
    Appointment(
      patientName: 'Lucie Petit',
      patientInitials: 'LP',
      startTime: '16:30',
      endTime: '17:00',
      status: AppointmentStatus.scheduled,
      description: 'Consultation annuelle',
    ),
    Appointment(
      patientName: 'Michel Dubois',
      patientInitials: 'MD',
      startTime: '17:15',
      endTime: '17:45',
      status: AppointmentStatus.scheduled,
      description: 'Suivi glaucome',
    ),
  ];

  void _addNewAppointment() {
    // Afficher une boîte de dialogue pour ajouter un nouveau rendez-vous
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un rendez-vous'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: const InputDecoration(labelText: 'Nom du patient'),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration:
                    InputDecoration(labelText: 'Heure de début (HH:MM)'),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(labelText: 'Heure de fin (HH:MM)'),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<AppointmentStatus>(
                decoration: const InputDecoration(labelText: 'Statut'),
                items: AppointmentStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(getStatusText(status)),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Ici, vous ajouteriez la logique pour sauvegarder le nouveau rendez-vous
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rendez-vous ajouté')),
              );
              setState(() {}); // Rafraîchir l'interface
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la date d'aujourd'hui
    final now = DateTime.now();
    final dateFormat = DateFormat.yMMMMEEEEd('fr_FR');
    final formattedDate = dateFormat.format(now);

    // Filtrer les rendez-vous à afficher
    final displayedAppointments =
        _showAllAppointments ? _appointments : _appointments.take(5).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rendez-vous d\'aujourd\'hui',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewAppointment,
                  tooltip: 'Ajouter un rendez-vous',
                ),
              ],
            ),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: displayedAppointments.map((appointment) {
                    return AppointmentTile(appointment: appointment);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showAllAppointments = !_showAllAppointments;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(_showAllAppointments
                    ? 'Afficher moins'
                    : 'Voir tous les rendez-vous'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const AppointmentTile({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Initiales du patient
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue[100],
            child: Text(
              appointment.patientInitials,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Informations du rendez-vous
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${appointment.startTime} - ${appointment.endTime}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildStatusChip(appointment.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  appointment.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Menu d'options
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Modifier'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Supprimer'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Reprogrammer'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color backgroundColor;
    Color textColor;
    String text = getStatusText(status);

    switch (status) {
      case AppointmentStatus.scheduled:
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        break;
      case AppointmentStatus.inProgress:
        backgroundColor = Colors.amber[50]!;
        textColor = Colors.amber[700]!;
        break;
      case AppointmentStatus.completed:
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        break;
      case AppointmentStatus.cancelled:
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

enum AppointmentStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}

String getStatusText(AppointmentStatus status) {
  switch (status) {
    case AppointmentStatus.scheduled:
      return 'Planifié';
    case AppointmentStatus.inProgress:
      return 'En cours';
    case AppointmentStatus.completed:
      return 'Terminé';
    case AppointmentStatus.cancelled:
      return 'Annulé';
  }
}

class Appointment {
  final String patientName;
  final String patientInitials;
  final String startTime;
  final String endTime;
  final AppointmentStatus status;
  final String description;

  Appointment({
    required this.patientName,
    required this.patientInitials,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.description,
  });
}
