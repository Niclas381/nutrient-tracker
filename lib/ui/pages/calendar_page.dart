import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/database.dart';
import '../../nutrition/aggregation.dart';
import '../format.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/entry_widgets.dart';
import '../widgets/nutrient_list.dart';
import 'barcode_page.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focused = dayOf(DateTime.now());
  DateTime _selected = dayOf(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final marked = ref.watch(markedDaysProvider(DateTime(_focused.year, _focused.month))).value ?? const {};
    final entries = ref.watch(dayEntriesProvider(_selected)).value ?? const [];
    final report = ref.watch(dayReportProvider(_selected)).value;
    final text = Theme.of(context).textTheme;

    return ListView(padding: EdgeInsets.all(t.spaceS), children: [
      TableCalendar<void>(
        firstDay: DateTime(2020),
        lastDay: DateTime(2100),
        focusedDay: _focused,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        selectedDayPredicate: (d) => isSameDay(d, _selected),
        eventLoader: (d) => marked.contains(dayOf(d)) ? const [null] : const [],
        calendarStyle: CalendarStyle(
          markerDecoration: BoxDecoration(color: t.calendarMarker, shape: BoxShape.circle),
        ),
        onDaySelected: (sel, foc) => setState(() {
          _selected = dayOf(sel);
          _focused = dayOf(foc);
        }),
        onPageChanged: (foc) => setState(() => _focused = dayOf(foc)),
      ),
      SizedBox(height: t.spaceM),
      Row(children: [
        Expanded(child: Text(dayFmt.format(_selected), style: text.titleMedium)),
        FilledButton.tonalIcon(onPressed: _add, icon: const Icon(Icons.add), label: const Text('Add')),
      ]),
      if (entries.isEmpty)
        Padding(padding: EdgeInsets.all(t.spaceM), child: const Text('Nothing logged on this day.')),
      for (final e in entries) EntryTile(entry: e, showTime: true),
      if (report != null && !report.averages.isEmpty) ...[
        SizedBox(height: t.spaceM),
        Text('Day totals', style: text.titleMedium),
        for (final s in report.rows) NutrientTile(status: s),
      ],
    ]);
  }

  /// Adding for a past day: describe it (Claude), pick from the database, or scan a barcode.
  Future<void> _add() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('Describe it'),
              onTap: () => Navigator.pop(ctx, 'text')),
          ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search the food database'),
              onTap: () => Navigator.pop(ctx, 'search')),
          ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan barcode'),
              onTap: () => Navigator.pop(ctx, 'barcode')),
        ]),
      ),
    );
    if (choice == null || !mounted) return;
    final now = DateTime.now();
    final logAt = isSameDay(_selected, now)
        ? now
        : _selected.add(const Duration(hours: 12));
    final services = ref.read(servicesProvider);
    switch (choice) {
      case 'text':
        final c = TextEditingController();
        final input = await showDialog<String>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('What did you eat on ${dayFmt.format(_selected)}?'),
            content: TextField(controller: c, autofocus: true, maxLines: 3),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Send')),
            ],
          ),
        );
        if (input == null || input.isEmpty) return;
        await services.requests.logText(input, inputSource: 'text', logAt: logAt);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sent. The entries appear here when the result arrives.')));
        }
      case 'search':
        final food = await pickFood(context);
        if (food == null || !mounted) return;
        final amount = await askAmount(context,
            title: food.name, initial: food.defaultServingG, unit: food.amountUnit);
        if (amount == null || amount <= 0) return;
        await services.db.addEntry(LogEntriesCompanion.insert(
          timestamp: logAt,
          foodId: food.id,
          grams: amount,
          inputSource: 'text',
          rawInput: Value(food.name),
        ));
        await services.foods.ensureEnriched(food.id);
      case 'barcode':
        if (mounted) await scanAndLogBarcode(context, ref, logAt: logAt);
    }
  }
}
