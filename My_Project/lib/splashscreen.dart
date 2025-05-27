import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet_8016586/home_screen%20(5).dart';
import 'package:projet_8016586/theme_service.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late final ThemeService themeService;

  // @override
  // void initState() {
  //   super.initState();
  //   Timer(const Duration(seconds: 3), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => HomeScreen(
  //                 themeService: themeService,
  //               )),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('lib/assets/images/logooo.svg'),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(
                minHeight: 8,
                backgroundColor: Colors.white,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
