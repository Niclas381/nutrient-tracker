import 'package:intl/intl.dart';

/// Compact number for amounts: 1234 -> "1234", 45.67 -> "45.7", 0.123 -> "0.12".
String fmtAmount(double v) {
  final a = v.abs();
  if (a >= 100) return v.round().toString();
  if (a >= 10) return _trim(v.toStringAsFixed(1));
  if (a >= 1) return _trim(v.toStringAsFixed(1));
  if (a == 0) return '0';
  return _trim(v.toStringAsFixed(2));
}

String _trim(String s) => s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;

/// "120 g", "250 ml", "1 piece", "2 pieces"
String fmtQuantity(double amount, String unit) {
  if (unit == 'piece') return '${fmtAmount(amount)} ${amount == 1 ? 'piece' : 'pieces'}';
  return '${fmtAmount(amount)} $unit';
}

final timeFmt = DateFormat.Hm();
final dayFmt = DateFormat('EEE d MMM yyyy');
