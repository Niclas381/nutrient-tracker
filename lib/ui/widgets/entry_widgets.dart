import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../format.dart';
import '../providers.dart';
import '../theme.dart';

const inputSourceIcons = {
  'text': Icons.keyboard_outlined,
  'voice': Icons.mic_none,
  'photo': Icons.photo_camera_outlined,
  'barcode': Icons.qr_code_scanner,
  'supplement_auto': Icons.medication_outlined,
};

/// Asks for an amount. Returns null when cancelled.
Future<double?> askAmount(BuildContext context, {required String title, double? initial, required String unit}) {
  final c = TextEditingController(text: initial == null ? '' : fmtAmount(initial));
  return showDialog<double>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: c,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(suffixText: unit == 'piece' ? 'pieces' : unit),
        onSubmitted: (_) => Navigator.pop(ctx, double.tryParse(c.text.replaceAll(',', '.'))),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, double.tryParse(c.text.replaceAll(',', '.'))),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// Local food search (English and German names). Returns the chosen food or null.
Future<FoodRow?> pickFood(BuildContext context) =>
    showDialog<FoodRow>(context: context, builder: (_) => const _FoodSearchDialog());

class _FoodSearchDialog extends ConsumerStatefulWidget {
  const _FoodSearchDialog();

  @override
  ConsumerState<_FoodSearchDialog> createState() => _FoodSearchDialogState();
}

class _FoodSearchDialogState extends ConsumerState<_FoodSearchDialog> {
  List<FoodRow> _results = const [];
  Timer? _debounce;

  void _search(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final r = await ref.read(dbProvider).searchFoods(q);
      if (mounted) setState(() => _results = r);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return AlertDialog(
      title: const Text('Choose food'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * 0.6,
        child: Column(children: [
          TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Search (English or German)', prefixIcon: Icon(Icons.search)),
            onChanged: _search,
          ),
          SizedBox(height: t.spaceS),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, i) {
                final f = _results[i];
                return ListTile(
                  dense: true,
                  title: Text(f.name),
                  subtitle: Text([if (f.nameDe != null) f.nameDe!, f.source.toUpperCase()].join(' · ')),
                  onTap: () => Navigator.pop(context, f),
                );
              },
            ),
          ),
        ]),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
    );
  }
}

/// One log entry with one-tap amount edit, food change and delete (with undo).
class EntryTile extends ConsumerWidget {
  const EntryTile({super.key, required this.entry, this.showTime = false});

  final LogEntryRow entry;
  final bool showTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final food = ref.watch(foodProvider(entry.foodId)).value;
    final unit = food?.amountUnit ?? 'g';
    final db = ref.read(dbProvider);
    final messenger = ScaffoldMessenger.of(context);

    Future<void> editAmount() async {
      final v = await askAmount(context, title: food?.name ?? 'Amount', initial: entry.grams, unit: unit);
      if (v == null || v <= 0) return;
      final old = entry.grams;
      await db.updateEntry(entry.id, LogEntriesCompanion(grams: Value(v)));
      messenger.showSnackBar(SnackBar(
        content: Text('Amount changed to ${fmtQuantity(v, unit)}'),
        action: SnackBarAction(
            label: 'Undo', onPressed: () => db.updateEntry(entry.id, LogEntriesCompanion(grams: Value(old)))),
      ));
    }

    Future<void> changeFood() async {
      final f = await pickFood(context);
      if (f == null) return;
      final old = entry.foodId;
      await db.updateEntry(entry.id, LogEntriesCompanion(foodId: Value(f.id)));
      await ref.read(servicesProvider).foods.ensureEnriched(f.id);
      messenger.showSnackBar(SnackBar(
        content: Text('Changed to ${f.name}'),
        action: SnackBarAction(
            label: 'Undo', onPressed: () => db.updateEntry(entry.id, LogEntriesCompanion(foodId: Value(old)))),
      ));
    }

    Future<void> remove() async {
      await db.deleteEntry(entry.id);
      messenger.showSnackBar(SnackBar(
        content: Text('Deleted ${food?.name ?? 'entry'}'),
        action: SnackBarAction(label: 'Undo', onPressed: () => db.addEntry(entry.toCompanion(true))),
      ));
    }

    final lowConfidence = (entry.confidence ?? 1) < 0.5;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: t.spaceXs),
      leading: Icon(inputSourceIcons[entry.inputSource] ?? Icons.edit_note),
      title: Text(food?.name ?? '…'),
      subtitle: Text([
        if (showTime) timeFmt.format(entry.timestamp),
        if (lowConfidence) 'uncertain',
      ].join(' · ')),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        TextButton(onPressed: editAmount, child: Text(fmtQuantity(entry.grams, unit))),
        PopupMenuButton<String>(
          onSelected: (v) => v == 'food' ? changeFood() : remove(),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'food', child: Text('Change food')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ]),
    );
  }
}
