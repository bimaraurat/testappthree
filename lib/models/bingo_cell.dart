class BingoCell {
  final int row;
  final int col;
  final int value; // 1-75, or 0 for FREE space
  final bool isFree;
  bool isMarked;
  bool isWinning;

  BingoCell({
    required this.row,
    required this.col,
    required this.value,
    this.isFree = false,
    this.isMarked = false,
    this.isWinning = false,
  });

  /// Label for display.
  String get displayLabel => isFree ? 'FREE' : value.toString();

  /// Gets the column letter name (B, I, N, G, O) based on column index (0..4).
  static String getColumnLetter(int colIndex) {
    switch (colIndex) {
      case 0:
        return 'B';
      case 1:
        return 'I';
      case 2:
        return 'N';
      case 3:
        return 'G';
      case 4:
        return 'O';
      default:
        return '';
    }
  }

  /// Get the full display identifier, e.g. "B-12"
  String get fullIdentifier {
    if (isFree) return 'FREE';
    return '${getColumnLetter(col)}-$value';
  }

  BingoCell copyWith({
    int? row,
    int? col,
    int? value,
    bool? isFree,
    bool? isMarked,
    bool? isWinning,
  }) {
    return BingoCell(
      row: row ?? this.row,
      col: col ?? this.col,
      value: value ?? this.value,
      isFree: isFree ?? this.isFree,
      isMarked: isMarked ?? this.isMarked,
      isWinning: isWinning ?? this.isWinning,
    );
  }
}
