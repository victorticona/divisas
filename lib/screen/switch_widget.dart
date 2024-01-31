import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({super.key});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool swValue = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      swValue = prefs.getBool('splash_value') ?? false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: swValue,
      onChanged: (newValue) async {
        swValue = newValue;
        AndroidOptions _getAndroidOptions() => const AndroidOptions(
              encryptedSharedPreferences: true,
            );
        final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
        await storage.write(key: 'splash_value_enc', value: newValue.toString());
        setState(() {});
      },
    );
  }
}
