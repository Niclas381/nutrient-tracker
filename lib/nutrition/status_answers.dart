/// Local handling of chat messages that are not food logs.
library;

import 'report.dart';

/// Period a status question refers to. `today` is just the current day.
enum StatusPeriod {
  today(1, 'today'),
  week(7, 'in the last 7 days'),
  month(30, 'in the last month'),
  year(365, 'in the last year');

  const StatusPeriod(this.days, this.phrase);
  final int days;
  final String phrase;
}

sealed class ChatIntent {
  const ChatIntent();
}

class LogIntent extends ChatIntent {
  const LogIntent();
}

class StatusIntent extends ChatIntent {
  const StatusIntent(this.period);
  final StatusPeriod period;
}

class OutOfScopeIntent extends ChatIntent {
  const OutOfScopeIntent();
}

const outOfScopeReply = 'I can only log food and drinks and answer short status questions like '
    '"what am I low on today?" or "this week?".';

final _statusWords = RegExp(
    r"\b(low on|lacking|missing|deficien\w*|short on|too (much|high|low)|how am i doing|how'?s my|status|"
    r'what do i need|was fehlt|zu wenig|zu viel|mangel)\b',
    caseSensitive: false);
final _periodOnly = RegExp(
    r'^\s*(and\s+|und\s+)?(today|this week|week|this month|month|this year|year|heute|diese woche|woche|'
    r'diesen monat|monat|dieses jahr|jahr)\s*\??\s*$',
    caseSensitive: false);
final _questionStart = RegExp(
    r'^\s*(what|why|how|should|can|could|is|are|do|does|did|which|when|where|who|will|would|tell me|explain|'
    r'was|warum|wieso|wie|soll|kann|ist|sind|welche|wann|wo|wer)\b',
    caseSensitive: false);

StatusPeriod _period(String text) {
  final t = text.toLowerCase();
  if (RegExp(r'\b(year|jahr)\b').hasMatch(t)) return StatusPeriod.year;
  if (RegExp(r'\b(month|monat)\b').hasMatch(t)) return StatusPeriod.month;
  if (RegExp(r'\b(week|woche)\b').hasMatch(t)) return StatusPeriod.week;
  return StatusPeriod.today;
}

/// Decides locally whether [text] is a status question, an out-of-scope question, or something to log.
/// [previousWasStatus] lets a bare follow-up like "this week?" count as a status question.
ChatIntent classifyChatInput(String text, {bool previousWasStatus = false}) {
  if (_statusWords.hasMatch(text)) return StatusIntent(_period(text));
  if (previousWasStatus && _periodOnly.hasMatch(text)) return StatusIntent(_period(text));
  final trimmed = text.trim();
  if (trimmed.endsWith('?') || _questionStart.hasMatch(trimmed)) return const OutOfScopeIntent();
  return const LogIntent();
}

String _fmt(double v) {
  if (v >= 100) return v.round().toString();
  if (v >= 10) return v.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '');
  return v.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

String _item(NutrientStatus s) {
  final target = s.target?.displayValue;
  final unit = s.nutrient.unit;
  return target == null
      ? '${s.nutrient.name} (${_fmt(s.average)} $unit)'
      : '${s.nutrient.name} (${_fmt(s.average)} / ${_fmt(target)} $unit)';
}

/// Short template answer for a status question.
String statusAnswer(NutrientReport report, StatusPeriod period) {
  if (report.averages.isEmpty) return 'Nothing logged ${period.phrase} yet.';
  final low = report.low.toList();
  final high = report.high.toList();
  final buf = StringBuffer();
  if (low.isEmpty && high.isEmpty) {
    buf.write('Nothing is in the red ${period.phrase}.');
  } else {
    if (low.isNotEmpty) buf.write('Low ${period.phrase}: ${low.take(6).map(_item).join(', ')}.');
    if (high.isNotEmpty) {
      if (buf.isNotEmpty) buf.write(' ');
      buf.write('Too high: ${high.take(4).map(_item).join(', ')}.');
    }
  }
  final days = report.averages.countedDays;
  if (period != StatusPeriod.today) buf.write(' (Average of $days logged day${days == 1 ? '' : 's'}.)');
  return buf.toString();
}
