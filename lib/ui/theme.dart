import 'package:flutter/material.dart';

/// The only place with visual style values. Widgets read everything from [ThemeData] and [AppTokens], so the
/// design from Claude Design can be applied by editing this file alone.
///
/// Current values are deliberately plain placeholders.
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.barGreen,
    required this.barYellow,
    required this.barRed,
    required this.barNone,
    required this.barTrack,
    required this.barMarker,
    required this.barMarkerWidth,
    required this.barHeight,
    required this.barRadius,
    required this.spaceXs,
    required this.spaceS,
    required this.spaceM,
    required this.spaceL,
    required this.cardRadius,
    required this.cardPadding,
    required this.mutedText,
    required this.warning,
    required this.error,
    required this.success,
    required this.userBubble,
    required this.replyBubble,
    required this.calendarMarker,
    required this.badgeColors,
    required this.badgeFillOpacity,
  });

  final Color barGreen;
  final Color barYellow;
  final Color barRed;

  /// Nutrients without a bar state (no data yet).
  final Color barNone;
  final Color barTrack;

  /// Tick marking the target on the bar.
  final Color barMarker;
  final double barMarkerWidth;
  final double barHeight;
  final double barRadius;

  final double spaceXs;
  final double spaceS;
  final double spaceM;
  final double spaceL;

  final double cardRadius;
  final double cardPadding;

  final Color mutedText;
  final Color warning;
  final Color error;
  final Color success;

  /// Chat: the user's message and local status replies.
  final Color userBubble;
  final Color replyBubble;

  final Color calendarMarker;

  /// Nutri-Score badges A–E and NOVA 1–4 / health 1–5 use this scale (index 0 = best).
  final List<Color> badgeColors;
  final double badgeFillOpacity;

  static AppTokens of(BuildContext context) => Theme.of(context).extension<AppTokens>()!;

  @override
  AppTokens copyWith() => this;

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) => this;
}

const _tokens = AppTokens(
  barGreen: Color(0xFF4CAF50),
  barYellow: Color(0xFFFFC107),
  barRed: Color(0xFFE53935),
  barNone: Color(0xFFBDBDBD),
  barTrack: Color(0xFFEEEEEE),
  barMarker: Color(0xFF616161),
  barMarkerWidth: 2,
  barHeight: 8,
  barRadius: 4,
  spaceXs: 4,
  spaceS: 8,
  spaceM: 12,
  spaceL: 20,
  cardRadius: 8,
  cardPadding: 12,
  mutedText: Color(0xFF757575),
  warning: Color(0xFFF57C00),
  error: Color(0xFFD32F2F),
  success: Color(0xFF388E3C),
  userBubble: Color(0xFFE3F2FD),
  replyBubble: Color(0xFFF5F5F5),
  calendarMarker: Color(0xFF1976D2),
  badgeColors: [
    Color(0xFF1B8A3A),
    Color(0xFF8BC34A),
    Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFFE53935),
  ],
  badgeFillOpacity: 0.2,
);

ThemeData buildTheme() {
  final base = ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF607D8B));
  return base.copyWith(
    extensions: const [_tokens],
    cardTheme: base.cardTheme.copyWith(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_tokens.cardRadius)),
    ),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), isDense: true),
  );
}

extension TokensX on BuildContext {
  AppTokens get tokens => AppTokens.of(this);
}
