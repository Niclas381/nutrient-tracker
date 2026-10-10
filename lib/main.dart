import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/app_services.dart';
import 'ui/app.dart';
import 'ui/providers.dart';
import 'ui/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Bootstrap());
}

/// Starts the services (first launch imports the bundled nutrient DB), then shows the app.
class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  final _tokens = buildTheme().extension<AppTokens>()!;
  AppServices? _services;
  String _status = 'Starting…';
  Object? _error;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final s = await AppServices.start(onProgress: (m) => setState(() => _status = m));
      setState(() => _services = s);
    } catch (e) {
      setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = _services;
    if (services != null) {
      return ProviderScope(
        overrides: [servicesProvider.overrideWithValue(services)],
        child: const NutrientApp(),
      );
    }
    return MaterialApp(
      theme: buildTheme(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_error == null) const CircularProgressIndicator(),
              SizedBox(height: _tokens.spaceL),
              Text(_error == null ? _status : 'Could not start: $_error', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
