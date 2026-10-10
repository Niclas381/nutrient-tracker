import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../claude/routine_backend.dart';
import '../../data/database.dart';
import '../../nutrition/models.dart';
import '../format.dart';
import '../providers.dart';
import '../theme.dart';

/// Editable copy of the profile.
class ProfileDraft {
  ProfileDraft({
    this.sex = Sex.female,
    this.age,
    this.heightCm,
    this.weightKg,
    this.pal = Pal.pal14,
    this.ironStatus = IronStatus.menstruating,
    this.phytate = Phytate.medium,
  });

  factory ProfileDraft.fromRow(ProfileRow r) => ProfileDraft(
        sex: Sex.fromCode(r.sex),
        age: r.age,
        heightCm: r.heightCm,
        weightKg: r.weightKg,
        pal: Pal.fromCode(r.activityLevel),
        ironStatus: IronStatus.fromCode(r.ironStatus),
        phytate: Phytate.fromCode(r.phytate),
      );

  Sex sex;
  int? age;
  double? heightCm;
  double? weightKg;
  Pal pal;
  IronStatus ironStatus;
  Phytate phytate;

  ProfilesCompanion toCompanion() => ProfilesCompanion.insert(
        sex: sex.code,
        age: age!,
        heightCm: heightCm!,
        weightKg: weightKg!,
        activityLevel: pal.code,
        ironStatus: Value(ironStatus.code),
        phytate: Value(phytate.code),
        updatedAt: DateTime.now(),
      );
}

/// Profile fields. Reference values are transcribed for adults (19+), so younger ages are rejected.
class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key, required this.draft, required this.formKey});

  final ProfileDraft draft;
  final GlobalKey<FormState> formKey;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  ProfileDraft get d => widget.draft;

  String? _number(String? v, {required double min, required double max}) {
    final n = double.tryParse((v ?? '').replaceAll(',', '.'));
    if (n == null) return 'Required';
    if (n < min || n > max) return 'Between ${fmtAmount(min)} and ${fmtAmount(max)}';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final gap = SizedBox(height: t.spaceM);
    return Form(
      key: widget.formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SegmentedButton<Sex>(
          segments: const [
            ButtonSegment(value: Sex.female, label: Text('Female')),
            ButtonSegment(value: Sex.male, label: Text('Male')),
          ],
          selected: {d.sex},
          onSelectionChanged: (s) => setState(() => d.sex = s.first),
        ),
        gap,
        TextFormField(
          initialValue: d.age?.toString(),
          decoration: const InputDecoration(labelText: 'Age (years)'),
          keyboardType: TextInputType.number,
          validator: (v) => _number(v, min: 19, max: 120),
          onSaved: (v) => d.age = int.parse(v!.trim()),
        ),
        gap,
        TextFormField(
          initialValue: d.heightCm == null ? null : fmtAmount(d.heightCm!),
          decoration: const InputDecoration(labelText: 'Height (cm)'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) => _number(v, min: 100, max: 250),
          onSaved: (v) => d.heightCm = double.parse(v!.replaceAll(',', '.')),
        ),
        gap,
        TextFormField(
          initialValue: d.weightKg == null ? null : fmtAmount(d.weightKg!),
          decoration: const InputDecoration(labelText: 'Weight (kg)'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) => _number(v, min: 30, max: 300),
          onSaved: (v) => d.weightKg = double.parse(v!.replaceAll(',', '.')),
        ),
        gap,
        DropdownButtonFormField<Pal>(
          initialValue: d.pal,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Activity level (DGE PAL)'),
          items: [for (final p in Pal.values) DropdownMenuItem(value: p, child: Text(p.label))],
          onChanged: (v) => setState(() => d.pal = v!),
        ),
        if (d.sex == Sex.female) ...[
          gap,
          DropdownButtonFormField<IronStatus>(
            initialValue: d.ironStatus,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Menstruation (for iron)'),
            items: [for (final s in IronStatus.values) DropdownMenuItem(value: s, child: Text(s.label))],
            onChanged: (v) => setState(() => d.ironStatus = v!),
          ),
        ],
        gap,
        DropdownButtonFormField<Phytate>(
          initialValue: d.phytate,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Diet type (for zinc, phytate intake)'),
          items: [for (final p in Phytate.values) DropdownMenuItem(value: p, child: Text(p.label))],
          onChanged: (v) => setState(() => d.phytate = v!),
        ),
      ]),
    );
  }
}

/// Routine fire URL + token, GitHub token, repo, and an end-to-end "test connection".
class ConnectionForm extends ConsumerStatefulWidget {
  const ConnectionForm({super.key});

  @override
  ConsumerState<ConnectionForm> createState() => _ConnectionFormState();
}

class _ConnectionFormState extends ConsumerState<ConnectionForm> {
  final _fireUrl = TextEditingController();
  final _fireToken = TextEditingController();
  final _github = TextEditingController();
  final _repo = TextEditingController();
  String? _status;
  bool _testing = false;
  StreamSubscription<RequestRow?>? _pingSub;

  @override
  void initState() {
    super.initState();
    ref.read(servicesProvider).secrets.read().then((c) {
      if (!mounted) return;
      _fireUrl.text = c.fireUrl;
      _fireToken.text = c.fireToken;
      _github.text = c.githubToken;
      _repo.text = c.repo;
    });
  }

  @override
  void dispose() {
    _pingSub?.cancel();
    for (final c in [_fireUrl, _fireToken, _github, _repo]) {
      c.dispose();
    }
    super.dispose();
  }

  RoutineConfig get _config => RoutineConfig(
      fireUrl: _fireUrl.text, fireToken: _fireToken.text, githubToken: _github.text, repo: _repo.text);

  Future<void> _save() async {
    await ref.read(servicesProvider).saveConfig(_config);
    setState(() => _status = _config.isComplete ? 'Saved.' : 'Saved (incomplete — requests wait until it is).');
  }

  Future<void> _test() async {
    if (!_config.isComplete) {
      setState(() => _status = 'Fill in all four fields first.');
      return;
    }
    final services = ref.read(servicesProvider);
    await services.saveConfig(_config);
    setState(() {
      _testing = true;
      _status = 'Sent a ping request. Waiting for the routine (this can take a few minutes)…';
    });
    final id = await services.requests.ping();
    await _pingSub?.cancel();
    _pingSub = (services.db.select(services.db.requests)..where((r) => r.id.equals(id)))
        .watchSingleOrNull()
        .listen((r) {
      if (!mounted || r == null) return;
      setState(() {
        switch (r.status) {
          case 'done':
            _testing = false;
            _status = 'Connection works. The routine answered.';
          case 'failed':
            _testing = false;
            _status = 'Test failed: ${r.lastError ?? 'unknown error'}';
          case 'fired':
            _status = 'Routine started. Waiting for the result…';
          default:
            if (r.lastError != null) _status = r.lastError;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final gap = SizedBox(height: t.spaceM);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(controller: _fireUrl, decoration: const InputDecoration(labelText: 'Routine fire URL')),
      gap,
      TextField(
          controller: _fireToken, obscureText: true, decoration: const InputDecoration(labelText: 'Routine token')),
      gap,
      TextField(
          controller: _github,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'GitHub fine-grained token (contents read/write)')),
      gap,
      TextField(controller: _repo, decoration: const InputDecoration(labelText: 'Repository (owner/name)')),
      gap,
      Wrap(spacing: t.spaceS, children: [
        OutlinedButton(onPressed: _save, child: const Text('Save')),
        FilledButton(onPressed: _testing ? null : _test, child: const Text('Test connection')),
      ]),
      if (_status != null) Padding(padding: EdgeInsets.only(top: t.spaceS), child: Text(_status!)),
      if (_testing) Padding(padding: EdgeInsets.only(top: t.spaceS), child: const LinearProgressIndicator()),
    ]);
  }
}

/// Daily supplements: add by description (Claude resolves the nutrients), pause or remove.
class SupplementsEditor extends ConsumerStatefulWidget {
  const SupplementsEditor({super.key});

  @override
  ConsumerState<SupplementsEditor> createState() => _SupplementsEditorState();
}

class _SupplementsEditorState extends ConsumerState<SupplementsEditor> {
  final _name = TextEditingController();
  final _amount = TextEditingController(text: '1');
  final _unit = TextEditingController(text: 'tablet');

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _unit.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final text = '$name, ${_amount.text.trim()} ${_unit.text.trim()} daily';
    await ref.read(servicesProvider).requests.supplementPlan(text);
    _name.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sent. The supplement appears here when the routine has resolved it.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final plans = ref.watch(supplementPlansProvider).value ?? const [];
    final db = ref.read(dbProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final p in plans)
        Consumer(builder: (context, ref, _) {
          final food = ref.watch(foodProvider(p.foodId)).value;
          return SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(food?.name ?? '…'),
            subtitle: Text('${fmtQuantity(p.amount, p.unit)} daily · since ${dayFmt.format(p.startDate)}'),
            value: p.active,
            onChanged: (v) => db.updateSupplementPlan(p.id, SupplementPlansCompanion(active: Value(v))),
            secondary: IconButton(
              tooltip: 'Remove',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => db.deleteSupplementPlan(p.id),
            ),
          );
        }),
      TextField(controller: _name, decoration: const InputDecoration(labelText: 'Supplement (e.g. Vitamin D3 1000 IU)')),
      SizedBox(height: t.spaceS),
      Row(children: [
        Expanded(
          child: TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
        ),
        SizedBox(width: t.spaceS),
        Expanded(child: TextField(controller: _unit, decoration: const InputDecoration(labelText: 'Unit'))),
        SizedBox(width: t.spaceS),
        FilledButton(onPressed: _add, child: const Text('Add')),
      ]),
    ]);
  }
}
