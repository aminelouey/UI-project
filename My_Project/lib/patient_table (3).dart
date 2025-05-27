import 'package:flutter/material.dart';
import 'package:projet_8016586/Data_Helper.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';
import 'Patients_Model.dart';

class PatientTable extends StatefulWidget {
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
  State<PatientTable> createState() => _PatientTableState();
}

class _PatientTableState extends State<PatientTable> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
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
          rows: widget.patients.map((patient) {
            return DataRow(
              cells: [
                DataCell(Text(
                  patient.id.toString(),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                )),
                DataCell(Text(
                  patient.fullName,
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
                  patient.appointmentDate,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                )),
                DataCell(
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final nameController =
                              TextEditingController(text: patient.fullName);
                          final phoneController =
                              TextEditingController(text: patient.phoneNumber);
                          final treatmentController =
                              TextEditingController(text: patient.treatment);

                          final DiagnosisController = TextEditingController();

                          await showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: Container(
                                width: 600,
                                height: 700,
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Edit patient
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Edit Patient',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ///////////////////////////////////////

                                    const SizedBox(
                                      height: 6,
                                    ),
///////////////////////////////////////

                                    //Modifier vous rendez vous ici.
                                    const Row(
                                      children: [
                                        Text(
                                          "Modifier vous rendez vous ici.",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
///////////////////////////////////////

                                    // Texte full name and phone number
                                    const Row(
                                      children: [
                                        Text(
                                          "1-Full name ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 195,
                                        ),
                                        Text(
                                          "2-phone number",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    ///////////////////////////////////////
                                    const SizedBox(height: 4),
                                    ///////////////////////////////////////
                                    // inputs full name and phone number
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 260,
                                          child: TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 260,
                                          child: TextField(
                                            controller: phoneController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    ///////////////////////////////////////
                                    const SizedBox(height: 16),
                                    ///////////////////////////////////////
                                    ///text cons_date and Diagnosis
                                    const Row(
                                      children: [
                                        Text(
                                          "3-consultation date ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 150,
                                        ),
                                        Text(
                                          "4-Diagnosis",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    ///////////////////////////////////////
                                    const SizedBox(height: 4),
                                    //inputs cons_date and Diagnosis
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 260,
                                          child: TextField(
                                            controller: dateController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            readOnly: true,
                                            onTap: () => _selectDate(context),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 260,
                                          child: TextField(
                                            controller: DiagnosisController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),
                                    ///////////////////////////////////////
                                    //text and inputs traitment
                                    const Row(
                                      children: [
                                        Text(
                                          "5-Traitment ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 250,
                                      child: TextField(
                                        controller: treatmentController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        maxLines: null,
                                        expands: true,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                      ),
                                    ),

                                    ///////////////////////////////////////
                                    const SizedBox(height: 16),
                                    ///////////////////////////////////////
                                    // save and cancel buttons
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // save button
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50.0, top: 30.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: themeService.isDarkMode
                                                  ? Colors.white
                                                  : const Color(0xFF90CAF9),
                                            ),
                                            width: 180,
                                            height: 40,
                                            child: TextButton(
                                              onPressed: () async {
                                                final db = DataHelper();
                                                await db.updatePatientName(
                                                    patient.fullName,
                                                    nameController.text);
                                                await db.updatePhone(
                                                    patient.phoneNumber,
                                                    phoneController.text);
                                                Navigator.of(context).pop();
                                                widget.onRefresh();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Patient updated")),
                                                );
                                              },
                                              child: const Text(
                                                "Save",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 50),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50.0, top: 30.0),
                                          child: Container(
                                            width: 180,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: themeService.isDarkMode
                                                  ? const Color.fromARGB(
                                                      255, 250, 88, 88)
                                                  : const Color.fromARGB(
                                                      255, 179, 179, 179),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins',
                                                  color: themeService.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
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

                      ///////////////////////////////////////
                      // delete button
                      TextButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Confirm deletion"),
                              content:
                                  Text("Delete patient ${patient.fullName}?"),
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
                            final db = DataHelper();
                            await db.deletePatient(patient.fullName);
                            widget.onRefresh();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Patient ${patient.fullName} deleted.")),
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
