import 'dart:math';
import '../models/bingo_cell.dart';

class BingoGenerator {
  static final Random _random = Random();

  /// Map column index to column number range
  static const Map<int, List<int>> colRanges = {
    0: [1, 15],   // B
    1: [16, 30],  // I
    2: [31, 45],  // N
    3: [46, 60],  // G
    4: [61, 75],  // O
  };

  /// Generates a randomized 5x5 Bingo board.
  /// Column 0 (B): 5 numbers in 1..15
  /// Column 1 (I): 5 numbers in 16..30
  /// Column 2 (N): 4 numbers in 31..45 + FREE space at center (row 2, col 2)
  /// Column 3 (G): 5 numbers in 46..60
  /// Column 4 (O): 5 numbers in 61..75
  static List<List<BingoCell>> generateBoard() {
    // 5x5 matrix
    List<List<BingoCell?>> board = List.generate(
      5,
      (_) => List<BingoCell?>.filled(5, null),
    );

    for (int col = 0; col < 5; col++) {
      final minVal = colRanges[col]![0];
      final maxVal = colRanges[col]![1];

      // Pick 5 unique random numbers for this column's range
      final numbers = _getRandomUniqueNumbers(
        minVal,
        maxVal,
        col == 2 ? 4 : 5,
      );

      int numberIndex = 0;

      for (int row = 0; row < 5; row++) {
        if (row == 2 && col == 2) {
          // Center FREE Space
          board[row][col] = BingoCell(
            row: row,
            col: col,
            value: 0,
            isFree: true,
            isMarked: true, // Automatically marked
          );
        } else {
          board[row][col] = BingoCell(
            row: row,
            col: col,
            value: numbers[numberIndex++],
            isFree: false,
            isMarked: false,
          );
        }
      }
    }

    return board.map((row) => row.cast<BingoCell>()).toList();
  }

  /// Generates `count` unique random numbers within `[min, max]` inclusive.
  static List<int> _getRandomUniqueNumbers(int min, int max, int count) {
    final List<int> pool = List.generate(max - min + 1, (i) => min + i);
    pool.shuffle(_random);
    return pool.sublist(0, count);
  }

  /// Helper to get column letter from number 1-75.
  static String getColumnForNumber(int number) {
    if (number >= 1 && number <= 15) return 'B';
    if (number >= 16 && number <= 30) return 'I';
    if (number >= 31 && number <= 45) return 'N';
    if (number >= 46 && number <= 60) return 'G';
    if (number >= 61 && number <= 75) return 'O';
    return '';
  }
}
