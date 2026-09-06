import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../utils/bingo_generator.dart';
import 'cell_widget.dart';

class CallerCard extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onCallNext;

  const CallerCard({
    super.key,
    required this.gameState,
    required this.onCallNext,
  });

  @override
  Widget build(BuildContext context) {
    final lastNum = gameState.lastCalledNumber;
    final letter =
        lastNum != null ? BingoGenerator.getColumnForNumber(lastNum) : null;
    final colColor =
        lastNum != null && letter != null ? _getLetterColor(letter) : Colors.grey;

    final isDisabled = gameState.isGameOver || gameState.callCount >= 75;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F38),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Display of Last Called Number
              Expanded(
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Container(
                        key: ValueKey(lastNum),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: lastNum != null
                              ? LinearGradient(
                                  colors: [
                                    colColor,
                                    colColor.withValues(alpha: 0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.1),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                                ),
                          boxShadow: lastNum != null
                              ? [
                                  BoxShadow(
                                    color: colColor.withValues(alpha: 0.5),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: lastNum != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      letter!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        height: 1.0,
                                      ),
                                    ),
                                    Text(
                                      '$lastNum',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                )
                              : const Icon(
                                  Icons.casino_outlined,
                                  color: Colors.white54,
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lastNum != null ? 'LATEST CALL' : 'READY TO PLAY',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lastNum != null ? '$letter - $lastNum' : 'Tap to start!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Called: ${gameState.callCount} / 75',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Call Number Button
              ElevatedButton(
                onPressed: isDisabled ? null : onCallNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4081),
                  disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: isDisabled ? 0 : 6,
                  shadowColor: const Color(0xFFFF4081).withValues(alpha: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDisabled ? Icons.lock_clock : Icons.play_arrow_rounded,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isDisabled ? 'Ended' : 'Call Next',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Auto Call Toggle Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: gameState.isAutoCalling
                  ? const Color(0xFFFF9100).withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: gameState.isAutoCalling
                    ? const Color(0xFFFF9100).withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      gameState.isAutoCalling
                          ? Icons.timer_rounded
                          : Icons.timer_outlined,
                      color: gameState.isAutoCalling
                          ? const Color(0xFFFF9100)
                          : Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      gameState.isAutoCalling
                          ? 'Auto-Calling active (every 3s)...'
                          : 'Auto-Call Mode',
                      style: TextStyle(
                        color: gameState.isAutoCalling
                            ? const Color(0xFFFF9100)
                            : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: gameState.isAutoCalling,
                  activeColor: const Color(0xFFFF9100),
                  onChanged: isDisabled
                      ? null
                      : (val) => gameState.toggleAutoCall(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLetterColor(String letter) {
    switch (letter) {
      case 'B':
        return CellWidget.getColumnColor(0);
      case 'I':
        return CellWidget.getColumnColor(1);
      case 'N':
        return CellWidget.getColumnColor(2);
      case 'G':
        return CellWidget.getColumnColor(3);
      case 'O':
        return CellWidget.getColumnColor(4);
      default:
        return Colors.blue;
    }
  }
}
