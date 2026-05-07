import 'dart:ui';

extension ColorExtensions on Color {
  Color darken([double percent = 0.05]) {
    assert(0.0 <= percent && percent <= 1.0);
    percent = 1.0 - percent;

    final c = this;
    return Color.from(
      alpha: c.a,
      red: c.r * percent,
      green: c.g * percent,
      blue: c.b * percent,
    );
  }
}