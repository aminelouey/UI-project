import 'package:flutter/material.dart';
import 'package:projet_8016586/DataBaseHelper.dart';
import 'package:projet_8016586/theme_service.dart';
import 'patient.dart';

class PatientTable extends StatelessWidget {
  final ThemeService themeService;
  final List<Patient> patients;
  final VoidCallback onRefresh; // To reload data

  const PatientTable({
    super.key,
    required this.themeService,
    required this.patients,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      width: isWide ? 900 : MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 80,
          columns: const [
            DataColumn(
                label: Text(
              'ID',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text('Name',
                    style: TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Age',
                    style: TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Diagnosis',
                    style: TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Last Visit',
                    style: TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Actions',
                    style: TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.bold))),
          ],
          rows: patients.map((patient) {
            return DataRow(
              cells: [
                DataCell(Text(
                  patient.id.toString(),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                )),
                DataCell(Text(
                  patient.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                )),
                DataCell(Text(
                  patient.age.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                )),
                DataCell(Text(
                  patient.diagnosis.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                )),
                DataCell(Text(
                  patient.lastVisit,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                )),
                DataCell(
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final nameController =
                              TextEditingController(text: patient.name);
                          final phoneController = TextEditingController(
                              text: patient.phone ?? "hello");
                          final treatmentController = TextEditingController(
                              text: patient.treatment ?? "trararararara");

                          await showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: Container(
                                width: 400,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Edit Patient',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        labelText: 'Name',
                                        labelStyle: TextStyle(
                                          color: themeService.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        labelText: 'phone',
                                        labelStyle: TextStyle(
                                          color: themeService.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      keyboardType: TextInputType.phone,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 300,
                                      width: 500,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        controller: treatmentController,
                                        expands: true,
                                        maxLines: null,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          labelText: "Treatment",
                                          labelStyle: TextStyle(
                                            color: themeService.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 40),
                                        TextButton(
                                          onPressed: () async {
                                            final db = DatabaseHelper();
                                            await db.updatePatientName(
                                                patient.name,
                                                nameController.text);
                                            await db.updatePhone(
                                                patient.phone ?? "",
                                                phoneController.text);
                                            Navigator.of(context).pop();
                                            onRefresh();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text("Patient updated")),
                                            );
                                          },
                                          child: const Text("Save"),
                                        ),
                                        const SizedBox(width: 170),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Confirm deletion"),
                              content: Text("Delete patient ${patient.name}?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final db = DatabaseHelper();
                            await db.deletePatient(patient.name);
                            onRefresh();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Patient ${patient.name} deleted.")),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
