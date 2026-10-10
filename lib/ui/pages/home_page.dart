import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../nutrition/aggregation.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/chat_panel.dart';
import '../widgets/nutrient_list.dart';

class WindowSelector extends ConsumerWidget {
  const WindowSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final window = ref.watch(windowProvider);
    return SegmentedButton<TimeWindow>(
      showSelectedIcon: false,
      segments: [for (final w in TimeWindow.values) ButtonSegment(value: w, label: Text(w.label))],
      selected: {window},
      onSelectionChanged: (s) => ref.read(windowProvider.notifier).set(s.first),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final window = ref.watch(windowProvider);
    final report = ref.watch(reportProvider(window.days));
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(color: t.mutedText);

    return Column(children: [
      Expanded(
        child: report.when(
          skipLoadingOnReload: true,
          data: (r) {
            if (r == null) return const SizedBox.shrink();
            final days = r.averages.countedDays;
            return NutrientList(
              report: r,
              header: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const WindowSelector(),
                SizedBox(height: t.spaceS),
                Text(
                  days == 0
                      ? 'Nothing logged in this period yet.'
                      : 'Daily average over $days logged day${days == 1 ? '' : 's'}',
                  style: muted,
                ),
                SizedBox(height: t.spaceS),
              ]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ),
      const Divider(height: 1),
      const ChatPanel(),
    ]);
  }
}
