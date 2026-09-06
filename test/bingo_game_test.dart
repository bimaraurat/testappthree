import 'package:flutter_test/flutter_test.dart';
import 'package:testappthree/models/bingo_cell.dart';
import 'package:testappthree/models/game_state.dart';
import 'package:testappthree/utils/bingo_generator.dart';

void main() {
  group('Bingo Board Generation Tests', () {
    test('Board conforms to 5x5 grid and B-I-N-G-O range rules', () {
      final board = BingoGenerator.generateBoard();

      expect(board.length, 5);
      for (final row in board) {
        expect(row.length, 5);
      }

      final allNumbers = <int>{};

      for (int r = 0; r < 5; r++) {
        for (int c = 0; c < 5; c++) {
          final cell = board[r][c];

          if (r == 2 && c == 2) {
            expect(cell.isFree, isTrue);
            expect(cell.isMarked, isTrue);
            expect(cell.value, 0);
          } else {
            expect(cell.isFree, isFalse);
            expect(cell.isMarked, isFalse);
            expect(allNumbers.contains(cell.value), isFalse,
                reason: 'Duplicate number ${cell.value} found on board');
            allNumbers.add(cell.value);

            switch (c) {
              case 0: // B
                expect(cell.value, inInclusiveRange(1, 15));
                break;
              case 1: // I
                expect(cell.value, inInclusiveRange(16, 30));
                break;
              case 2: // N
                expect(cell.value, inInclusiveRange(31, 45));
                break;
              case 3: // G
                expect(cell.value, inInclusiveRange(46, 60));
                break;
              case 4: // O
                expect(cell.value, inInclusiveRange(61, 75));
                break;
            }
          }
        }
      }
      expect(allNumbers.length, 24); // 24 unique numbers + 1 FREE space
    });
  });

  group('Number Calling Tests', () {
    test('Calls unique numbers between 1 and 75', () {
      final gameState = GameState();

      for (int i = 0; i < 75; i++) {
        final success = gameState.callNextNumber();
        expect(success, isTrue);
        expect(gameState.lastCalledNumber, isNotNull);
        expect(gameState.lastCalledNumber!, inInclusiveRange(1, 75));
      }

      // 76th call should fail
      final success76 = gameState.callNextNumber();
      expect(success76, isFalse);
      expect(gameState.calledNumbers.length, 75);
      expect(gameState.calledNumbers.toSet().length, 75); // All unique
    });
  });

  group('Cell Marking & Rule Validation', () {
    test('Cannot mark an uncalled number', () {
      final gameState = GameState();
      BingoCell? targetCell;
      int targetRow = 0, targetCol = 0;
      for (int r = 0; r < 5; r++) {
        for (int c = 0; c < 5; c++) {
          if (!gameState.board[r][c].isFree) {
            targetCell = gameState.board[r][c];
            targetRow = r;
            targetCol = c;
            break;
          }
        }
      }

      expect(targetCell, isNotNull);
      expect(gameState.isNumberCalled(targetCell!.value), isFalse);

      final marked = gameState.markCell(targetRow, targetCol);
      expect(marked, isFalse);
      expect(targetCell.isMarked, isFalse);
    });

    test('Can mark a called number and repeated taps do not unmark', () {
      final gameState = GameState();
      int? matchedRow;
      int? matchedCol;

      while (matchedRow == null && gameState.callCount < 75) {
        gameState.callNextNumber();
        final lastNum = gameState.lastCalledNumber!;

        for (int r = 0; r < 5; r++) {
          for (int c = 0; c < 5; c++) {
            if (gameState.board[r][c].value == lastNum) {
              matchedRow = r;
              matchedCol = c;
              break;
            }
          }
        }
      }

      expect(matchedRow, isNotNull);
      expect(matchedCol, isNotNull);

      // First tap marks
      final mark1 = gameState.markCell(matchedRow!, matchedCol!);
      expect(mark1, isTrue);
      expect(gameState.board[matchedRow][matchedCol].isMarked, isTrue);

      // Second tap does not unmark
      final mark2 = gameState.markCell(matchedRow, matchedCol);
      expect(mark2, isFalse);
      expect(gameState.board[matchedRow][matchedCol].isMarked, isTrue);
    });
  });

  group('Bingo Win Detection Tests', () {
    test('Winning horizontal row sets Bingo win and isGameOver', () {
      final gameState = GameState();

      // Call all numbers on row 0 and mark them
      for (int c = 0; c < 5; c++) {
        final cell = gameState.board[0][c];
        if (!cell.isFree) {
          // Simulate number call
          while (!gameState.isNumberCalled(cell.value)) {
            gameState.callNextNumber();
          }
          gameState.markCell(0, c);
        }
      }

      expect(gameState.hasWon, isTrue);
      expect(gameState.isGameOver, isTrue);
      for (int c = 0; c < 5; c++) {
        expect(gameState.board[0][c].isWinning, isTrue);
      }
    });

    test('Winning vertical column sets Bingo win', () {
      final gameState = GameState();

      // Call all numbers in column 0 (B column) and mark them
      for (int r = 0; r < 5; r++) {
        final cell = gameState.board[r][0];
        if (!cell.isFree) {
          while (!gameState.isNumberCalled(cell.value)) {
            gameState.callNextNumber();
          }
          gameState.markCell(r, 0);
        }
      }

      expect(gameState.hasWon, isTrue);
      expect(gameState.isGameOver, isTrue);
      for (int r = 0; r < 5; r++) {
        expect(gameState.board[r][0].isWinning, isTrue);
      }
    });

    test('Main diagonal win (with FREE space at center)', () {
      final gameState = GameState();

      for (int i = 0; i < 5; i++) {
        final cell = gameState.board[i][i];
        if (!cell.isFree) {
          while (!gameState.isNumberCalled(cell.value)) {
            gameState.callNextNumber();
          }
          gameState.markCell(i, i);
        }
      }

      expect(gameState.hasWon, isTrue);
      expect(gameState.isGameOver, isTrue);
      for (int i = 0; i < 5; i++) {
        expect(gameState.board[i][i].isWinning, isTrue);
      }
    });

    test('Anti diagonal win (with FREE space at center)', () {
      final gameState = GameState();

      for (int i = 0; i < 5; i++) {
        final cell = gameState.board[i][4 - i];
        if (!cell.isFree) {
          while (!gameState.isNumberCalled(cell.value)) {
            gameState.callNextNumber();
          }
          gameState.markCell(i, 4 - i);
        }
      }

      expect(gameState.hasWon, isTrue);
      expect(gameState.isGameOver, isTrue);
      for (int i = 0; i < 5; i++) {
        expect(gameState.board[i][4 - i].isWinning, isTrue);
      }
    });
  });

  group('Auto-Caller Tests', () {
    test('Starts and stops auto calling state', () {
      final gameState = GameState();
      expect(gameState.isAutoCalling, isFalse);

      gameState.startAutoCall(interval: const Duration(milliseconds: 100));
      expect(gameState.isAutoCalling, isTrue);

      gameState.stopAutoCall();
      expect(gameState.isAutoCalling, isFalse);
      gameState.dispose();
    });
  });
}
