import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/nutrition_service.dart';
import '../format.dart';
import '../providers.dart';
import '../theme.dart';
import 'home_page.dart';

enum RankingSort { amount, frequency, health }

class RankingPage extends ConsumerStatefulWidget {
  const RankingPage({super.key});

  @override
  ConsumerState<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends ConsumerState<RankingPage> {
  RankingSort _sort = RankingSort.amount;
  final _scoreRequested = <int>{};

  List<RankedFood> _sorted(List<RankedFood> list) {
    final l = [...list];
    switch (_sort) {
      case RankingSort.amount:
        l.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
      case RankingSort.frequency:
        l.sort((a, b) => b.count.compareTo(a.count));
      case RankingSort.health:
        // Healthiest first by the absolute health rating; unrated foods last; Nutri-Score breaks ties.
        int rating(RankedFood f) => f.note?.healthRating ?? 0;
        String grade(RankedFood f) => f.note?.nutriScore ?? 'Z';
        l.sort((a, b) {
          final c = rating(b).compareTo(rating(a));
          return c != 0 ? c : grade(a).compareTo(grade(b));
        });
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final window = ref.watch(windowProvider);
    final ranking = ref.watch(rankingProvider(window.days));

    return ranking.when(
      skipLoadingOnReload: true,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) {
        // Nutri-Score is computed locally once per food.
        final missing = list.where((f) => f.note?.nutriScore == null && _scoreRequested.add(f.food.id)).toList();
        if (missing.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            for (final f in missing) {
              await ref.read(servicesProvider).foods.refreshNutriScore(f.food.id);
            }
          });
        }
        final sorted = _sorted(list);
        return ListView(padding: EdgeInsets.all(t.spaceM), children: [
          const WindowSelector(),
          SizedBox(height: t.spaceS),
          SegmentedButton<RankingSort>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: RankingSort.amount, label: Text('Amount')),
              ButtonSegment(value: RankingSort.frequency, label: Text('Frequency')),
              ButtonSegment(value: RankingSort.health, label: Text('Healthiness')),
            ],
            selected: {_sort},
            onSelectionChanged: (s) => setState(() => _sort = s.first),
          ),
          SizedBox(height: t.spaceS),
          if (sorted.isEmpty) const Text('Nothing logged in this period.'),
          for (final f in sorted) _RankedTile(item: f),
        ]);
      },
    );
  }
}

class _RankedTile extends StatelessWidget {
  const _RankedTile({required this.item});

  final RankedFood item;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;
    final note = item.note;
    final pending = item.food.enrichment == 'pending';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.spaceXs),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(t.cardPadding),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(item.food.name, style: text.bodyLarge),
            SizedBox(height: t.spaceXs),
            Text(
              '${fmtQuantity(item.totalAmount, item.food.amountUnit)} in total · ${item.count}× logged',
              style: text.bodySmall?.copyWith(color: t.mutedText),
            ),
            SizedBox(height: t.spaceS),
            Wrap(spacing: t.spaceS, runSpacing: t.spaceXs, children: [
              if (note?.nutriScore != null)
                _Badge('Nutri-Score ${note!.nutriScore}', 'ABCDE'.indexOf(note.nutriScore!)),
              if (note?.novaGroup != null) _Badge('NOVA ${note!.novaGroup}', (note.novaGroup! - 1) * 4 ~/ 3),
              if (note?.healthRating != null) _Badge('Health ${note!.healthRating}/5', 5 - note.healthRating!),
              if (pending) Text('Assessment pending…', style: text.bodySmall?.copyWith(color: t.mutedText)),
            ]),
            if (note?.warningText != null) ...[
              SizedBox(height: t.spaceS),
              Text(note!.warningText!, style: text.bodySmall?.copyWith(color: t.warning)),
            ],
          ]),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.level);

  final String label;

  /// 0 = best … 4 = worst.
  final int level;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = t.badgeColors[level.clamp(0, t.badgeColors.length - 1)];
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: t.badgeFillOpacity),
      side: BorderSide(color: color),
      visualDensity: VisualDensity.compact,
    );
  }
}
