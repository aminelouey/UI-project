import 'package:flutter/material.dart';
import 'package:projet_8016586/Rendez_vous.dart';
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
                          // Action
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Rendyvous(),
                            ),
                          );
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
                  SizedBox(
                    width: double.infinity,
                    height: 550,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
