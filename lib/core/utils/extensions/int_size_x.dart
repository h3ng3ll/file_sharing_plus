/// Human-readable byte-size formatting.
extension IntSizeX on int {
  /// Formats this byte count as a readable string (e.g. `1.5 MB`).
  String get readableSize {
    if (this < 1024) return '$this B';
    const units = ['KB', 'MB', 'GB', 'TB'];
    var size = this / 1024;
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }
}
