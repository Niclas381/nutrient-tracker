import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../nutrition/aggregation.dart';
import '../nutrition/report.dart';
import '../services/app_services.dart';
import '../services/nutrition_service.dart';

/// Overridden in main() with the started services.
final servicesProvider = Provider<AppServices>((ref) => throw UnimplementedError('services not started'));

final dbProvider = Provider<AppDatabase>((ref) => ref.watch(servicesProvider).db);

/// Ticks whenever data that affects averages, bars or rankings changes. Derived providers watch it, so any
/// edit (entry, food value, profile) recalculates everything immediately.
final dataVersionProvider = StreamProvider<int>((ref) {
  final db = ref.watch(dbProvider);
  var n = 0;
  return db
      .tableUpdates(TableUpdateQuery.onAllTables(
          [db.logEntries, db.foodNutrients, db.foods, db.profiles, db.foodNotes, db.supplementPlans]))
      .map((_) => ++n);
});

final profileProvider = StreamProvider<ProfileRow?>((ref) => ref.watch(dbProvider).watchProfile());

class WindowNotifier extends Notifier<TimeWindow> {
  @override
  TimeWindow build() => TimeWindow.days7;

  void set(TimeWindow w) => state = w;
}

/// Shared by the home and ranking pages.
final windowProvider = NotifierProvider<WindowNotifier, TimeWindow>(WindowNotifier.new);

final reportProvider = FutureProvider.family<NutrientReport?, int>((ref, days) async {
  ref.watch(dataVersionProvider);
  return ref.watch(servicesProvider).nutrition.report(days: days);
});

/// Totals of a single day (calendar day view).
final dayReportProvider = FutureProvider.family<NutrientReport?, DateTime>((ref, day) async {
  ref.watch(dataVersionProvider);
  return ref.watch(servicesProvider).nutrition.report(days: 1, today: day);
});

final rankingProvider = FutureProvider.family<List<RankedFood>, int>((ref, days) async {
  ref.watch(dataVersionProvider);
  return ref.watch(servicesProvider).nutrition.ranking(days: days);
});

final foodProvider = FutureProvider.family<FoodRow?, int>((ref, id) async {
  ref.watch(dataVersionProvider);
  return ref.watch(dbProvider).foodById(id);
});

final chatRequestsProvider = StreamProvider<List<RequestRow>>((ref) => ref.watch(dbProvider).watchChatRequests());

final requestEntriesProvider = StreamProvider.family<List<LogEntryRow>, String>(
    (ref, requestId) => ref.watch(dbProvider).watchEntriesForRequest(requestId));

final dayEntriesProvider = StreamProvider.family<List<LogEntryRow>, DateTime>((ref, day) {
  final start = dayOf(day);
  return ref.watch(dbProvider).watchEntriesBetween(start, start.add(const Duration(days: 1)));
});

/// Days with entries in the month containing [month].
final markedDaysProvider = StreamProvider.family<Set<DateTime>, DateTime>((ref, month) {
  final start = DateTime(month.year, month.month - 1, 20);
  final end = DateTime(month.year, month.month + 1, 12);
  return ref
      .watch(dbProvider)
      .watchEntriesBetween(start, end)
      .map((list) => {for (final e in list) dayOf(e.timestamp)});
});

final supplementPlansProvider =
    StreamProvider<List<SupplementPlanRow>>((ref) => ref.watch(dbProvider).watchSupplementPlans());

/// Local chat replies (status answers, out-of-scope notes). Not stored.
class ChatMessage {
  const ChatMessage({required this.time, required this.text, required this.fromUser});
  final DateTime time;
  final String text;
  final bool fromUser;
}

class ChatMessagesNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => const [];

  void add(ChatMessage m) => state = [...state, m];

  void clear() => state = const [];
}

final chatMessagesProvider = NotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(ChatMessagesNotifier.new);
