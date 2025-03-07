import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/screens/add_medicine_screens/add_medicine_screen.dart';
import 'package:sickle_cell_app/screens/tabs_screens/tabs_screen.dart';
import 'package:sickle_cell_app/screens/auth_screens/login_screen.dart';
import 'package:sickle_cell_app/screens/tabs_screens/tabs_screen_doctor.dart';
import 'package:sickle_cell_app/services/user_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isLoggedIn = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loginSuccess = prefs.getBool('loginSuccess') ?? false;
    String? userId = prefs.getString('userId');
    String? medicineId = prefs.getString('medicineId');
    String? userType = prefs.getString('userType');

    if (loginSuccess && userId != null && userType == 'Patient') {
      try {
        UserService userService = UserService();
        var user = await userService.getUserDetails(userId);

        if (user != null && medicineId != null) {
          ref.read(userProvider.notifier).setUser(user);
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => TabsScreen()),
            );
          });
        } else if (user != null && medicineId == null) {
          ref.read(userProvider.notifier).setUser(user);
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (_) => AddMedicineScreen(
                        user: user,
                      )),
            );
          });
        } else {
          await prefs.clear();
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          });
        }
      } catch (e) {
        Future.delayed(const Duration(seconds: 3), () {
          _showDialog();
        });
      }
    } else if (loginSuccess && userId != null && userType == 'Doctor') {
      try {
        UserService userService = UserService();
        var user = await userService.getUserDetails(userId);

        if (user != null) {
          ref.read(userProvider.notifier).setUser(user);
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => TabsScreenDoctor()),
            );
          });
        } else {
          await prefs.clear();
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          });
        }
      } catch (e) {
        Future.delayed(const Duration(seconds: 3), () {
          _showDialog();
        });
      }
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    }
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: Text('Maintenance Issue'),
                content: Text(
                    'The system is currently under maintenance. Please try again later.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        exit(0);
                      },
                      child: Text('Okay'))
                ],
              ));
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Maintenance Issue'),
          content: const Text(
              'The system is currently under maintenance. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const TabsScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: GoogleFonts.patrickHand(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 40,
                ),
              ),
            ),
            Text(
              'SICKLE CARE',
              style: GoogleFonts.patrickHand(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
