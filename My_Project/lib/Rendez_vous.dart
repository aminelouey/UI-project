import 'package:flutter/material.dart';
import 'package:projet_8016586/RendezvousPrincipale.dart';
import 'package:projet_8016586/sidebar.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';

class Rendyvous extends StatefulWidget {
  const Rendyvous({super.key});

  @override
  State<Rendyvous> createState() => _MyRendyvousState();
}

class _MyRendyvousState extends State<Rendyvous> {
  bool _isSidebarOpen = true;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
        backgroundColor: themeService.isDarkMode
            ? const Color.fromARGB(255, 0, 10, 27)
            : const Color.fromARGB(255, 242, 251, 255),
        body: Row(
          children: [
            Sidebar(
              isOpen: _isSidebarOpen,
              onToggle: _toggleSidebar,
            ),
            const Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RendezvousPrincipale(),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
