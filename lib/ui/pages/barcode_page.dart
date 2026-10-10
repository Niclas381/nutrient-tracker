import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../data/database.dart';
import '../../input/open_food_facts.dart';
import '../../input/photo_input.dart';
import '../format.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/entry_widgets.dart';

/// Camera view that returns the first barcode it reads.
class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({super.key});

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan barcode')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_done) return;
          final code = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
          if (code == null) return;
          _done = true;
          Navigator.pop(context, code);
        },
      ),
    );
  }
}

/// Scan → Open Food Facts → confirm amount → log immediately with label values → queue enrich_food.
/// [logAt] puts the entry on a past day.
Future<void> scanAndLogBarcode(BuildContext context, WidgetRef ref, {DateTime? logAt}) async {
  final code = await Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => const BarcodeScanPage()));
  if (code == null || !context.mounted) return;
  final services = ref.read(servicesProvider);
  final messenger = ScaffoldMessenger.of(context);

  // Repeat scans skip the lookup.
  var food = await services.db.foodByBarcode(code);
  OffProduct? product;
  if (food == null) {
    try {
      product = await OpenFoodFactsClient().lookup(code);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Open Food Facts not reachable: $e')));
      return;
    }
    if (product == null) {
      if (!context.mounted) return;
      final takePhoto = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unknown product'),
          content: Text('Barcode $code is not in Open Food Facts. Take a photo of the nutrition label instead?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Take photo')),
          ],
        ),
      );
      if (takePhoto != true) return;
      final id = services.requests.newId();
      final path = await PhotoInput().capture(id);
      if (path == null) return;
      await services.requests.logPhoto(id, path, kind: 'label', barcode: code, logAt: logAt);
      return;
    }
    food = await services.db.foodById(await services.foods.foodForProduct(product));
  }
  if (food == null || !context.mounted) return;

  final amount = await showModalBottomSheet<double>(
    context: context,
    builder: (_) => _AmountSheet(food: food!, product: product),
  );
  if (amount == null) return;
  final entryId = await services.db.addEntry(LogEntriesCompanion.insert(
    timestamp: logAt ?? DateTime.now(),
    foodId: food.id,
    grams: amount,
    inputSource: 'barcode',
    rawInput: Value('${food.name} ($code)'),
  ));
  await services.foods.ensureEnriched(food.id, product: product);
  messenger.showSnackBar(SnackBar(
    content: Text('Logged ${food.name}: ${fmtQuantity(amount, food.amountUnit)}'),
    action: SnackBarAction(label: 'Undo', onPressed: () => services.db.deleteEntry(entryId)),
  ));
}

class _AmountSheet extends StatelessWidget {
  const _AmountSheet({required this.food, this.product});

  final FoodRow food;
  final OffProduct? product;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final unit = food.amountUnit;
    final pkg = product?.package;
    final whole = food.packageQuantity;
    final unitAmount = (pkg?.isMultipack ?? false) ? pkg!.unitAmount : null;
    final options = <(String, double)>[
      if (unitAmount != null) ('One unit (${fmtQuantity(unitAmount, unit)})', unitAmount),
      if (whole != null) ('Whole package (${fmtQuantity(whole, unit)})', whole),
      if (whole != null) ('Half (${fmtQuantity(whole / 2, unit)})', whole / 2),
      if (food.defaultServingG != null)
        ('One serving (${fmtQuantity(food.defaultServingG!, unit)})', food.defaultServingG!),
    ];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(t.spaceL),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(food.name, style: Theme.of(context).textTheme.titleMedium),
          if (options.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: t.spaceS),
              child: const Text('Package size unknown — please enter the amount.'),
            ),
          SizedBox(height: t.spaceM),
          for (final (i, o) in options.indexed)
            Padding(
              padding: EdgeInsets.only(bottom: t.spaceS),
              child: i == 0
                  ? FilledButton(onPressed: () => Navigator.pop(context, o.$2), child: Text(o.$1))
                  : OutlinedButton(onPressed: () => Navigator.pop(context, o.$2), child: Text(o.$1)),
            ),
          TextButton(
            onPressed: () async {
              final v = await askAmount(context, title: 'Amount', unit: unit);
              if (v != null && v > 0 && context.mounted) Navigator.pop(context, v);
            },
            child: Text('Custom ${unit == 'ml' ? 'ml' : 'grams'}'),
          ),
        ]),
      ),
    );
  }
}
