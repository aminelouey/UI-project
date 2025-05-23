import 'package:flutter/material.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';

class RendezvousPrincipale extends StatefulWidget {
  const RendezvousPrincipale({super.key});

  @override
  _RendezVousPageState createState() => _RendezVousPageState();
}

class _RendezVousPageState extends State<RendezvousPrincipale> {
  final TextEditingController _searchController = TextEditingController();

  bool _isSidebarOpen = true;
  TextEditingController nomController = TextEditingController();
  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  TextEditingController dateController = TextEditingController();
  List<Map<String, String>> rendezVousList = [];
  final TextEditingController titreController = TextEditingController();
  final TextEditingController heureController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final double screen = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Button Dark Mode:
        _buildAppBar(themeService),

        const SizedBox(
          height: 40,
        ),
        const Row(
          children: [
            SizedBox(
              width: 100,
            ),
            Text(
              'Rendez-vous',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Row(
          children: [
            SizedBox(
              width: 100,
            ),
            Text(
              'Gérez vos rendez-vous ici',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
            ),
          ],
        ),
        const SizedBox(height: 40),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 80),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildSearchBar(themeService),
                      buildSizedBox2(screen),
                      //Button d'Ajoute Rendez-vous:
                      Container(
                        width: 220,
                        height: 43,
                        decoration: BoxDecoration(
                          color: themeService.isDarkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 0, 64, 255)
                                  .withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _showAppointmentDialog(context);
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Color.fromARGB(255, 0, 0, 0),
                                size: 22,
                              ),
                              SizedBox(width: 13),
                              Text(
                                'Nouveau Rendy-vous',
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      buildSizedBox3(screen),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Table des Rendez-vous:
                  Container(
                    width: (screen <= 900) ? 810 : 900,
                    height: 700,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 214, 214, 214)),
                      borderRadius: BorderRadius.circular(8),
                      color: themeService.isDarkMode
                          ? const Color.fromARGB(255, 0, 10, 27)
                              .withOpacity(0.6)
                          : const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Rendez-vous d'aujourd'hui",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Mardi 15 Avril 2025 ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w100),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: rendezVousList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 220, 220, 220),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 138, 138, 138)
                                            .withOpacity(0.1),
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        const Text(
                                          "Nom et Prénom:   ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                        Text(
                                          rendezVousList[index]['nom'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Date : ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                          Text(
                                            rendezVousList[index]['date'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("Détails du Rendez-vous"),
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    "Nom et Prénom: ${rendezVousList[index]['nom'] ?? ''}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    "Date : ${rendezVousList[index]['date'] ?? ''}"),
                                                // Ajoute plus de détails si nécessaire
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Fermer"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void ajouterRendezVous() {
    setState(() {
      rendezVousList.add({
        'nom': nomController.text, // Stocke le nom et le prénom
        'date': dateController.text,
      });
      nomController.clear();
      dateController.clear();
    });
  }

  void _showAppointmentDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: 600, // Largeur personnalisée
            height: 700, // Hauteur personnalisée
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Nov rendez-vous
                  const Row(
                    children: [
                      Text(
                        "Nouveau rendez-vous",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ), //intr form:
                  const Row(
                    children: [
                      Text(
                        "Planifiez un nouveau rendez-vous dans votre calendrier.",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        "Nom de patient",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextField(
                    controller: nomController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        "Genre",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: ["Homme", "Femme"].map((String genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        "Note",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Row(
                    children: [
                      Text(
                        'informations supplémentaires, préparation nécessaire....',
                        style: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: 16),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 70,
                      ),
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          style: const ButtonStyle(
                              minimumSize:
                                  WidgetStatePropertyAll(Size(130, 50))),
                          onPressed: () {
                            // Enregistrer le rendez-vous ici
                            ajouterRendezVous();
                            Navigator.pop(context);
                          },
                          child: const Text("Confirmer"),
                        ),
                      ),
                      const SizedBox(
                        width: 230,
                      ),
                      TextButton(
                        style: const ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(130, 50)),

                          // backgroundColor: WidgetStateProperty.all(
                          //     const Color.fromARGB(
                          //         255, 255, 182, 182)), // ✅ Correction
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? selectedGenre;
  Widget _buildSearchBar(ThemeService themeService) {
    return Container(
      decoration: BoxDecoration(
        color: themeService.isDarkMode
            ? const Color.fromARGB(255, 0, 10, 27)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width > 900
          ? 350
          : MediaQuery.of(context).size.width,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            // Filtrer la liste des rendez-vous en fonction du texte saisi
            rendezVousList = rendezVousList
                .where((appointment) =>
                    appointment['nom']
                        ?.toLowerCase()
                        .contains(value.toLowerCase()) ??
                    false)
                .toList();
          });
        },
        decoration: InputDecoration(
          hintText: 'Rechercher un rendez-vous par nom...',
          hintStyle: const TextStyle(fontWeight: FontWeight.w100),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  } // Stocke la valeur sélectionnée
}

// Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           TextField(
//             controller: nomController,
//             decoration: InputDecoration(labelText: "Nom du patient"),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => _selectDate(context),
//             child: Text("Choisir une date"),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => _showAppointmentDialog(context),
//             child: Text("Ajouter un rendy-vous ! "),
//           ),
//         ],
//       ),
//     );
Widget _buildAppBar(ThemeService themeService) {
  return Container(
    color: themeService.isDarkMode
        ? const Color.fromARGB(255, 0, 10, 27)
        : const Color.fromARGB(255, 242, 251, 255),
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Bouton thème
        IconButton(
          icon: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => themeService.toggleTheme(),
          tooltip: 'Changer de thème',
        ),
      ],
    ),
  );
}

Widget buildSizedBox(double screen) {
  if (screen < 1100) {
    return SizedBox(width: 300);
  } else {
    return Container(); // Ou un autre widget
  }
}

Widget buildSizedBox2(double screen) {
  if (screen > 1100) {
    return SizedBox(width: 320);
  } else {
    return Container(); // Ou un autre widget
  }
}

Widget buildSizedBox3(double screen) {
  if (screen < 1100) {
    return SizedBox(width: 100);
  } else {
    return Container(); // Ou un autre widget
  }
}
