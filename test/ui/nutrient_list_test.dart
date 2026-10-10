import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrient_tracker/nutrition/aggregation.dart';
import 'package:nutrient_tracker/nutrition/models.dart';
import 'package:nutrient_tracker/nutrition/report.dart';
import 'package:nutrient_tracker/nutrition/suggestions.dart';
import 'package:nutrient_tracker/nutrition/targets.dart';
import 'package:nutrient_tracker/ui/theme.dart';
import 'package:nutrient_tracker/ui/widgets/nutrient_list.dart';

import '../nutrition/fixtures.dart';

void main() {
  testWidgets('nutrient list renders bars, targets and suggestions', (tester) async {
    const orange = 101, bread = 100;
    final table = <int, Map<int, double>>{
      bread: {energy.id: 250, protein.id: 8, fat.id: 3},
      orange: {energy.id: 47, vitC.id: 50},
    };
    final today = DateTime.now();
    final report = buildReport(
      profile: man30,
      nutrients: nutrients,
      resolver: TargetResolver(nutrients: nutrients, references: references),
      averages: averageWindow(
          items: [LoggedItem(timestamp: today, foodId: bread, amount: 300)], nutrients: table, today: today, days: 7),
      suggestions: SuggestionEngine(
          commonFoods: const [FoodInfo(id: orange, name: 'Orange', servingAmount: 150, servingLabel: '1 orange')],
          nutrients: table),
      windowDays: 7,
    );

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(theme: buildTheme(), home: Scaffold(body: NutrientList(report: report))),
    ));
    expect(find.text('Energy'), findsOneWidget);
    expect(find.text('750 / 2300 kcal'), findsOneWidget);
    expect(find.text('Vitamin C'), findsOneWidget);
    expect(find.text('→ eat 1 orange'), findsWidgets);
    expect(find.byType(NutrientBar), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
