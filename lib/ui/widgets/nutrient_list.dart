import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../nutrition/classification.dart';
import '../../nutrition/models.dart';
import '../../nutrition/report.dart';
import '../format.dart';
import '../providers.dart';
import '../theme.dart';

/// Bar with the current value against the target. Colour comes from the classification.
class NutrientBar extends StatelessWidget {
  const NutrientBar({super.key, required this.status});

  final NutrientStatus status;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final target = status.target;
    final color = switch (status.classification.state) {
      BarState.green => t.barGreen,
      BarState.yellow => t.barYellow,
      BarState.red => t.barRed,
      BarState.none => t.barNone,
    };
    // Scale: target at 2/3 of the width so values above it stay visible.
    final markers = <double>[
      if (target?.type == TargetType.pctRange) ...[target!.low!, target.high!] else if (target?.displayValue != null)
        target!.displayValue!,
    ];
    final scaleMax = markers.isEmpty
        ? math.max(status.average, 1.0)
        : math.max(markers.reduce(math.max) * 1.5, status.average);
    final fraction = scaleMax <= 0 ? 0.0 : (status.average / scaleMax).clamp(0.0, 1.0);

    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      return SizedBox(
        height: t.barHeight,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(color: t.barTrack, borderRadius: BorderRadius.circular(t.barRadius)),
          ),
          Container(
            width: w * fraction,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(t.barRadius)),
          ),
          for (final m in markers)
            Positioned(
              left: (w * (m / scaleMax)).clamp(0.0, w - t.barMarkerWidth),
              top: 0,
              bottom: 0,
              child: Container(width: t.barMarkerWidth, color: t.barMarker),
            ),
        ]),
      );
    });
  }
}

String targetText(NutrientStatus s) {
  final unit = s.nutrient.unit;
  final t = s.target;
  final current = fmtAmount(s.average);
  if (t == null) return '$current $unit';
  return switch (t.type) {
    TargetType.pctRange => '$current / ${fmtAmount(t.low!)}–${fmtAmount(t.high!)} $unit',
    TargetType.limit => '$current / max ${fmtAmount(t.limit!)} $unit',
    _ => '$current / ${fmtAmount(t.displayValue!)} $unit',
  };
}

class NutrientTile extends ConsumerWidget {
  const NutrientTile({super.key, required this.status});

  final NutrientStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;
    final hint = _hint(ref);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.spaceXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(child: Text(status.nutrient.name, style: text.bodyMedium)),
            Text(targetText(status), style: text.bodySmall?.copyWith(color: t.mutedText)),
          ]),
          SizedBox(height: t.spaceXs),
          if (status.target != null) NutrientBar(status: status),
          if (hint != null)
            Padding(
              padding: EdgeInsets.only(top: t.spaceXs),
              child: Text(hint, style: text.bodySmall?.copyWith(color: t.barRed)),
            ),
        ],
      ),
    );
  }

  String? _hint(WidgetRef ref) {
    if (status.suggestions.isNotEmpty) {
      final names = status.suggestions.map((s) => s.food.servingLabel ?? s.food.name).toList();
      return '→ eat ${names.join(' or ')}';
    }
    if (status.contributors.isNotEmpty) {
      final names = [
        for (final c in status.contributors) ref.watch(foodProvider(c.key)).value?.name ?? '…',
      ];
      return 'Mainly from ${names.join(' and ')}';
    }
    return null;
  }
}

/// All nutrients of a report in importance order.
class NutrientList extends StatelessWidget {
  const NutrientList({super.key, required this.report, this.header, this.footer});

  final NutrientReport report;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final rows = report.rows;
    return ListView.builder(
      padding: EdgeInsets.all(t.spaceM),
      itemCount: rows.length + 2,
      itemBuilder: (context, i) {
        if (i == 0) return header ?? const SizedBox.shrink();
        if (i == rows.length + 1) return footer ?? const SizedBox.shrink();
        return NutrientTile(status: rows[i - 1]);
      },
    );
  }
}
