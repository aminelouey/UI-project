import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projet_8016586/Add_Apointment.dart';
import 'package:projet_8016586/database.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';
import 'AssistantHost.dart';

class RendezvousPrincipaleASS extends StatefulWidget {
  const RendezvousPrincipaleASS({
    super.key,
  });

  @override
  _RendezVousPageASSState createState() => _RendezVousPageASSState();
}

class _RendezVousPageASSState extends State<RendezvousPrincipaleASS> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Appointmentee>> appointmentListFuture = Future.value([]);

  AppDatabase adb = AppDatabase();

  late AssitantHost host;

  late Future<AssitantHost> _hostFuture;

  void Appoint() {
    /*adb.getAppointments();
    adb.getAppointments().then((list) {
      print("Nombre de rendez-vous dans la base : ${list.length}");
      for (var a in list) {
        print("RDV: ${a.name} - ${a.phoneNumber}");
      }
    });

    print("adb est bien executer !");
    return;*/
  }

  @override
  void initState() {
    super.initState();
    _hostFuture = initServer();
  }

  Future<AssitantHost> initServer() async {
    final host = await AssitantHost.create(Platform.localHostname, adb);
    await host.start();
    return host;
  }

  TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  TextEditingController dateController = TextEditingController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final double screen = MediaQuery.of(context).size.width;

    return FutureBuilder<AssitantHost>(
      future: _hostFuture,
      builder: (context, hostSnapshot) {
        if (hostSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (hostSnapshot.hasError) {
          return Center(child: Text('Error: ${hostSnapshot.error}'));
        } else if (hostSnapshot.hasData) {
          final host = hostSnapshot.data!;
          print('Host: ${host.hostname}  Port: ${host.port}');

          final appointmentList = adb.getAppointments(); // Synchronously get appointments
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(themeService),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Appointments',
                        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('Manage your appointments here',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildSearchBar(themeService),
                          buildSizedBox2(screen),
                          Container(
                            width: 220,
                            height: 43,
                            decoration: BoxDecoration(
                              color: themeService.isDarkMode
                                  ? Colors.white
                                  : const Color.fromARGB(255, 0, 64, 255).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddApointment(
                                            adb: adb,
                                            host: host,
                                            key: null,
                                          )),
                                ).then((value) {
                                  if (value == true) {
                                    setState(() {
                                      // trigger rebuild if appointments are reloaded
                                    });
                                  }
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.black, size: 22),
                                  SizedBox(width: 13),
                                  Text('New Appointment',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                          buildSizedBox3(screen),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: (screen <= 900) ? 810 : 900,
                        height: 700,
                        decoration: BoxDecoration(
                          color: themeService.isDarkMode
                              ? const Color.fromARGB(255, 0, 10, 27).withOpacity(0.6)
                              : Colors.white.withOpacity(0.6),
                          border: Border.all(color: const Color.fromARGB(255, 214, 214, 214)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text("Today's Appointments",
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: appointmentList.length,
                                  itemBuilder: (context, index) {
                                    final appointment = appointmentList[index];
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: themeService.foregroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(255, 0, 0, 0)
                                                .withOpacity(0.1),
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            const Text("Full Name: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black)),
                                            Text(
                                              appointment.name ?? '',
                                              style: const TextStyle(
                                                  fontSize: 15, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Row(
                                            children: [
                                              const Text("Date: ",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black)),
                                              Text(
                                                appointment.date ?? '',
                                                style: const TextStyle(
                                                    fontSize: 15, color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios,
                                            color: Colors.black),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Appointment Details"),
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        "Full Name: ${appointment.name ?? ''}",
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold)),
                                                    Text("Date: ${appointment.date ?? ''}"),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text("Close"),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const Center(child: Text("Unknown Error"));
      },
    );
  }
  // void addAppointment() {
  //   setState(() {
  //     appointmentList.add({
  //       'name': nameController.text,
  //       'date': dateController.text,
  //     });
  //     nameController.clear();
  //     dateController.clear();
  //   });
  // }

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
          // setState(() {
          //   appointmentList = appointmentList
          //       .where((appointment) =>
          //           appointment['name']
          //               ?.toLowerCase()
          //               .contains(value.toLowerCase()) ??
          //           false)
          //       .toList();
          // });
        },
        decoration: InputDecoration(
          hintText: 'Search appointment by name...',
          hintStyle: const TextStyle(fontWeight: FontWeight.w100),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

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
        IconButton(
          icon: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => themeService.toggleTheme(),
          tooltip: 'Change theme',
        ),
      ],
    ),
  );
}

Widget buildSizedBox(double screen) {
  if (screen < 1100) {
    return SizedBox(width: 300);
  } else {
    return Container();
  }
}

Widget buildSizedBox2(double screen) {
  if (screen > 1100) {
    return SizedBox(width: 320);
  } else {
    return Container();
  }
}

Widget buildSizedBox3(double screen) {
  if (screen < 1100) {
    return SizedBox(width: 100);
  } else {
    return Container();
  }
}
