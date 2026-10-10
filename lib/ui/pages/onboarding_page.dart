import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../theme.dart';
import '../widgets/forms.dart';

/// First launch: profile → routine connection → optional supplements. The profile is saved at the end, which
/// switches the app to the home screen.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _draft = ProfileDraft();
  final _formKey = GlobalKey<FormState>();
  int _step = 0;

  Future<void> _next() async {
    if (_step == 0) {
      if (!_formKey.currentState!.validate()) return;
      _formKey.currentState!.save();
    }
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    await ref.read(dbProvider).saveProfile(_draft.toCompanion());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Stepper(
        currentStep: _step,
        onStepContinue: _next,
        onStepCancel: _step == 0 ? null : () => setState(() => _step--),
        onStepTapped: (i) => i < _step ? setState(() => _step = i) : null,
        controlsBuilder: (context, details) => Padding(
          padding: EdgeInsets.only(top: context.tokens.spaceL),
          child: Row(children: [
            FilledButton(
              onPressed: details.onStepContinue,
              child: Text(_step == 2 ? 'Finish' : (_step == 1 ? 'Next (or set up later)' : 'Next')),
            ),
            if (details.onStepCancel != null)
              TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
          ]),
        ),
        steps: [
          Step(
            title: const Text('Your profile'),
            subtitle: const Text('Used for your personal reference values'),
            isActive: _step >= 0,
            content: ProfileForm(draft: _draft, formKey: _formKey),
          ),
          Step(
            title: const Text('Routine connection'),
            subtitle: const Text('See SETUP.md in the routine repo'),
            isActive: _step >= 1,
            content: const ConnectionForm(),
          ),
          Step(
            title: const Text('Daily supplements (optional)'),
            isActive: _step >= 2,
            content: const SupplementsEditor(),
          ),
        ],
      ),
    );
  }
}
