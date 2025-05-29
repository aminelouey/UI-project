import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projet_8016586/AssistantHost.dart';
import 'package:projet_8016586/DoctorClient.dart';

import 'package:projet_8016586/Rendez_vous.dart';
import 'package:projet_8016586/database.dart';
import 'package:projet_8016586/home_screen%20(5).dart';
import 'package:projet_8016586/theme_service.dart';

class RecommendationDialog extends StatefulWidget {
  final ThemeService themeService;
  const RecommendationDialog({super.key, required this.themeService});

  @override
  State<RecommendationDialog> createState() => _RecommendationDialogState();
}

class _RecommendationDialogState extends State<RecommendationDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAppointmentDialog(context);
    });
  }

  Future<void> Server() async {
    /* Open database (check the class to customize its use) */
    AppDatabase ad = AppDatabase(
        //sqlite3.open('rendez_vous.db')
        );
    try {
      /* Host local server with the assistant IP Address & database */
      final host = await AssitantHost.create(Platform.localHostname, ad);
      /* Start the local server */
      await host.start();
      // Sooo, you're all good to go now
      /* Whenever you update in the database like:
    ad.insert(77, "2024-11-03", "Name Surname", ...);
    host.kepler();
    */
      /* Always call host.kepler(); 
    because it tells all doctors that database got updated ;)
    */
      print('Server started on port ${host.port}');
    } catch (e) {
      print('Failed to start host: $e');
    }
  }

  Future<void> Client() async {
    /* Create a client to communicate with the assistant */
    DoctorClient dc = DoctorClient();
    /* Discover all available assistants */
    Map<String, HostInfo> assistants = await dc.gaussDiscover();
    for (var entry in assistants.entries) {
      print(
          "Host: ${entry.key} IP: ${entry.value.ip} Port: ${entry.value.port}");

      await for (var message in dc.galileoStream(entry.value)) {
        /*
	for each update that happens like new 
    rendez-vous, your code gets here and message is table holding all
    rendez-vous with the added one
    */
        print('Received: $message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
        themeService: widget.themeService); // or other background widget
  }

  void showAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          backgroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
                color: Color.fromARGB(255, 214, 214, 214), width: 1),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 549, maxWidth: 549, minHeight: 350, maxHeight: 350),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quel compte les choisissez-vous ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      _accountButton(
                        context,
                        icon: Icons.person,
                        label: 'Doctore',
                        onTap: () {
                          _showAppointmentDialog(context);
                        },
                        foregroundColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      _accountButton(
                        context,
                        icon: Icons.group,
                        label: 'Assistant',
                        onTap: () {
                          Client();
                          Server();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Rendyvous()));
                        },
                        foregroundColor: Colors.black,
                      ),
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

  Widget _accountButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      required Color foregroundColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: Container(
        width: 442,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(125, 0, 0, 0),
          ),
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.blueGrey,
            //   blurRadius: 12,
            //   offset: const Offset(0, 6),
            // ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 24),
            Icon(icon, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: foregroundColor,
              ),
            ),
            const Spacer(),
            Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Color(0xFF7CFF7C),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
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
            height: 750, // Hauteur personnalisée
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.black,
                        iconSize: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'searching...',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  //Nov rendez-vous
                  Container(
                    width: double.infinity,
                    height: 550,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                // Text("Host : ${assistants.keys.first}"),
                                // const SizedBox(width: 10),
                                // Text("IP : ${assistants.values.first.ip}"),
                                // const SizedBox(width: 10),
                                // Text("Port : ${assistants.values.first.port}"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
