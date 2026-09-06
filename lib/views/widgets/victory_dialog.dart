import 'package:flutter/material.dart';
import '../../models/game_state.dart';

class VictoryDialog extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onNewGame;

  const VictoryDialog({
    super.key,
    required this.gameState,
    required this.onNewGame,
  });

  static void show(
      BuildContext context, GameState gameState, VoidCallback onNewGame) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryDialog(
        gameState: gameState,
        onNewGame: () {
          Navigator.of(context).pop();
          onNewGame();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWin = gameState.hasWon;

    return Dialog(
      backgroundColor: const Color(0xFF1E1F38),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Badge
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isWin
                      ? [const Color(0xFFFFD700), const Color(0xFFFF8C00)]
                      : [Colors.grey.shade700, Colors.grey.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isWin
                        ? Colors.amber.withValues(alpha: 0.6)
                        : Colors.black.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                isWin ? Icons.emoji_events_rounded : Icons.info_outline_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              isWin ? 'BINGO!' : 'GAME OVER',
              style: TextStyle(
                color: isWin ? const Color(0xFFFFD700) : Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                shadows: isWin
                    ? [
                        Shadow(
                          color: Colors.amber.withValues(alpha: 0.8),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              isWin
                  ? 'Congratulations! You achieved Bingo!'
                  : 'All 75 numbers have been called without a Bingo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            // Win Details
            if (isWin) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Winning Line(s):',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...gameState.winningPatterns.map(
                      (p) => Text(
                        '• $p',
                        style: const TextStyle(
                          color: Color(0xFF00E676),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Completed in ${gameState.callCount} calls',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onNewGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4081),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: const Color(0xFFFF4081).withValues(alpha: 0.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh_rounded, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
