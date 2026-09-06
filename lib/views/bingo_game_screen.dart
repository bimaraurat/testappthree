import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'widgets/bingo_board_grid.dart';
import 'widgets/caller_card.dart';
import 'widgets/history_bar.dart';
import 'widgets/victory_dialog.dart';

class BingoGameScreen extends StatefulWidget {
  const BingoGameScreen({super.key});

  @override
  State<BingoGameScreen> createState() => _BingoGameScreenState();
}

class _BingoGameScreenState extends State<BingoGameScreen> {
  late final GameState _gameState;

  @override
  void initState() {
    super.initState();
    _gameState = GameState();
    _gameState.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    _gameState.removeListener(_onGameStateChanged);
    _gameState.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    if (_gameState.isGameOver && mounted) {
      // Delay slightly to let cell marking animation settle before showing modal
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted && _gameState.isGameOver) {
          VictoryDialog.show(
            context,
            _gameState,
            _handleNewGame,
          );
        }
      });
    }
  }

  void _handleCallNext() {
    if (_gameState.isGameOver) return;
    final success = _gameState.callNextNumber();
    if (!success && _gameState.callCount < 75) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot call number right now.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _handleCellTap(int row, int col) {
    if (_gameState.isGameOver) return;
    final cell = _gameState.board[row][col];

    if (cell.isMarked) return;

    final marked = _gameState.markCell(row, col);
    if (!marked && !cell.isFree && !_gameState.isNumberCalled(cell.value)) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Text(
                'Number ${cell.fullIdentifier} has not been called yet!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2A2B4A),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1, milliseconds: 500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _handleNewGame() {
    _gameState.startNewGame();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.casino, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('New Bingo board generated! Good luck!'),
          ],
        ),
        backgroundColor: const Color(0xFFFF4081),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _gameState,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D0E21),
          appBar: AppBar(
            backgroundColor: const Color(0xFF14152A),
            elevation: 0,
            title: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF4081), Color(0xFFAA00FF)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'BINGO',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Classic 75',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                tooltip: 'New Game',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1F38),
                      title: const Text(
                        'Start New Game?',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Your current board and called numbers will be reset.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4081),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _handleNewGame();
                          },
                          child: const Text('New Game'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 6),

                  // Caller Action & Display Card
                  CallerCard(
                    gameState: _gameState,
                    onCallNext: _handleCallNext,
                  ),

                  // Main 5x5 Bingo Board
                  BingoBoardGrid(
                    gameState: _gameState,
                    onCellTap: _handleCellTap,
                  ),

                  // Called Numbers History Bar
                  HistoryBar(
                    gameState: _gameState,
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
