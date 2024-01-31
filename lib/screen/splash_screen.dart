import 'package:divisas/screen/home_screen.dart';
import 'package:divisas/screen/switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 4500), () async {
      final nav = Navigator.of(context);

      AndroidOptions _getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
      final String prefsValueStr =
          await storage.read(key: 'splash_value_enc') ?? 'false';

      final bool prefsValue = bool.parse(prefsValueStr);
      if (prefsValue) {
        nav.pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen(dinero: 0.0)),
        );
      } else {
        nav.pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen(dinero: 0.0)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/vicko.gif',
              width: 500,
              height: 500,
            ),
            const SwitchWidget(),
          ],
        ),
      ),
    );
  }
}
