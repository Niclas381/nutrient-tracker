import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../theme.dart';
import '../widgets/forms.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  ProfileDraft? _draft;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;
    final profile = ref.watch(profileProvider).value;
    if (profile != null) _draft ??= ProfileDraft.fromRow(profile);
    final services = ref.read(servicesProvider);

    Widget section(String title, Widget child) => Padding(
          padding: EdgeInsets.only(bottom: t.spaceL),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, style: text.titleMedium),
            SizedBox(height: t.spaceS),
            child,
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: EdgeInsets.all(t.spaceL), children: [
        if (_draft != null)
          section(
            'Profile',
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              ProfileForm(draft: _draft!, formKey: _formKey),
              SizedBox(height: t.spaceS),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();
                    await services.db.saveProfile(_draft!.toCompanion());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile saved. Targets and bars are updated.')));
                    }
                  },
                  child: const Text('Save profile'),
                ),
              ),
            ]),
          ),
        section('Routine connection', const ConnectionForm()),
        section('Daily supplements', const SupplementsEditor()),
        section(
          'Data',
          Text(
            'Nutrient database ${services.dbVersion}.\n'
            'BLS 4.0: Max Rubner-Institut (2025), Bundeslebensmittelschlüssel (BLS), Version 4.0 – Deutsche '
            'Nährstoffdatenbank, Karlsruhe. DOI 10.25826/Data20251217-134202-0. Licence CC BY 4.0.\n'
            'USDA FoodData Central (SR Legacy, Foundation Foods), public domain.\n'
            'Product data: Open Food Facts (ODbL).\n'
            'Reference values: DGE/ÖGE (3rd ed. 2025), EFSA (DRVs, ULs), WHO healthy diet fact sheet.',
            style: text.bodySmall?.copyWith(color: t.mutedText),
          ),
        ),
      ]),
    );
  }
}
