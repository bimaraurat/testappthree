import 'dart:math';
import 'package:flutter/foundation.dart';
import 'bingo_cell.dart';
import '../utils/bingo_generator.dart';

class GameState extends ChangeNotifier {
  late List<List<BingoCell>> _board;
  final List<int> _calledNumbers = [];
  int? _lastCalledNumber;
  bool _isGameOver = false;
  bool _hasWon = false;
  final List<String> _winningPatterns = [];
  final Random _random = Random();

  GameState() {
    startNewGame();
  }

  // Getters
  List<List<BingoCell>> get board => _board;
  List<int> get calledNumbers => List.unmodifiable(_calledNumbers);
  int? get lastCalledNumber => _lastCalledNumber;
  int get callCount => _calledNumbers.length;
  bool get isGameOver => _isGameOver;
  bool get hasWon => _hasWon;
  List<String> get winningPatterns => List.unmodifiable(_winningPatterns);
  bool get isPoolExhausted => _calledNumbers.length >= 75 && !_hasWon;

  /// Get column name and number formatted, e.g. "B-12"
  String? get formattedLastCalledNumber {
    if (_lastCalledNumber == null) return null;
    final letter = BingoGenerator.getColumnForNumber(_lastCalledNumber!);
    return '$letter-$_lastCalledNumber';
  }

  /// Start or reset to a fresh game.
  void startNewGame() {
    _board = BingoGenerator.generateBoard();
    _calledNumbers.clear();
    _lastCalledNumber = null;
    _isGameOver = false;
    _hasWon = false;
    _winningPatterns.clear();
    notifyListeners();
  }

  /// Draw a random number between 1 and 75 that has not been called.
  /// Returns true if a number was called, false if game is over or all numbers called.
  bool callNextNumber() {
    if (_isGameOver || _calledNumbers.length >= 75) {
      return false;
    }

    // Determine remaining uncalled numbers
    final available = List<int>.generate(75, (i) => i + 1)
        .where((n) => !_calledNumbers.contains(n))
        .toList();

    if (available.isEmpty) {
      _isGameOver = true;
      notifyListeners();
      return false;
    }

    // Pick random available number
    final nextNumber = available[_random.nextInt(available.length)];
    _calledNumbers.add(nextNumber);
    _lastCalledNumber = nextNumber;

    // If pool is exhausted without Bingo, end game
    if (_calledNumbers.length >= 75 && !_hasWon) {
      _isGameOver = true;
    }

    notifyListeners();
    return true;
  }

  /// Attempt to mark a cell at (row, col).
  /// A cell can only be marked if it is the FREE cell OR its value has been called.
  /// Once marked, it cannot be unmarked.
  bool markCell(int row, int col) {
    if (_isGameOver) return false;
    if (row < 0 || row >= 5 || col < 0 || col >= 5) return false;

    final cell = _board[row][col];

    // Already marked cells cannot be unmarked or re-marked
    if (cell.isMarked) return false;

    // Allowed if FREE or value has been called
    if (cell.isFree || _calledNumbers.contains(cell.value)) {
      cell.isMarked = true;
      _checkBingo();
      notifyListeners();
      return true;
    }

    return false;
  }

  /// Check all horizontal, vertical, and diagonal lines for 5 marked cells.
  void _checkBingo() {
    _winningPatterns.clear();
    final Set<String> winningCoords = {};

    // 1. Check Rows
    for (int r = 0; r < 5; r++) {
      bool rowComplete = true;
      for (int c = 0; c < 5; c++) {
        if (!_board[r][c].isMarked) {
          rowComplete = false;
          break;
        }
      }
      if (rowComplete) {
        _winningPatterns.add('Row ${r + 1}');
        for (int c = 0; c < 5; c++) {
          winningCoords.add('$r,$c');
        }
      }
    }

    // 2. Check Columns
    for (int c = 0; c < 5; c++) {
      bool colComplete = true;
      for (int r = 0; r < 5; r++) {
        if (!_board[r][c].isMarked) {
          colComplete = false;
          break;
        }
      }
      if (colComplete) {
        final letter = BingoCell.getColumnLetter(c);
        _winningPatterns.add('Column $letter');
        for (int r = 0; r < 5; r++) {
          winningCoords.add('$r,$c');
        }
      }
    }

    // 3. Check Main Diagonal (0,0) -> (4,4)
    bool mainDiagComplete = true;
    for (int i = 0; i < 5; i++) {
      if (!_board[i][i].isMarked) {
        mainDiagComplete = false;
        break;
      }
    }
    if (mainDiagComplete) {
      _winningPatterns.add('Main Diagonal ( Top-Left ➔ Bottom-Right )');
      for (int i = 0; i < 5; i++) {
        winningCoords.add('$i,$i');
      }
    }

    // 4. Check Secondary Diagonal (0,4) -> (4,0)
    bool secDiagComplete = true;
    for (int i = 0; i < 5; i++) {
      if (!_board[i][4 - i].isMarked) {
        secDiagComplete = false;
        break;
      }
    }
    if (secDiagComplete) {
      _winningPatterns.add('Anti Diagonal ( Top-Right ➔ Bottom-Left )');
      for (int i = 0; i < 5; i++) {
        winningCoords.add('$i,${4 - i}');
      }
    }

    // Flag winning cells
    if (winningCoords.isNotEmpty) {
      for (int r = 0; r < 5; r++) {
        for (int c = 0; c < 5; c++) {
          if (winningCoords.contains('$r,$c')) {
            _board[r][c].isWinning = true;
          }
        }
      }
      _hasWon = true;
      _isGameOver = true;
    }
  }

  /// Helper to check if a specific number has been called.
  bool isNumberCalled(int number) => _calledNumbers.contains(number);
}
