import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import 'cell_widget.dart';

class BingoBoardGrid extends StatelessWidget {
  final GameState gameState;
  final Function(int row, int col) onCellTap;

  const BingoBoardGrid({
    super.key,
    required this.gameState,
    required this.onCellTap,
  });

  static const List<String> colLetters = ['B', 'I', 'N', 'G', 'O'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF14152A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // B-I-N-G-O Header Row
          Row(
            children: List.generate(5, (index) {
              final colColor = CellWidget.getColumnColor(index);
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: colColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colColor.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      colLetters[index],
                      style: TextStyle(
                        color: colColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: colColor.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),

          // 5x5 Board Cells Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 25,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final row = index ~/ 5;
              final col = index % 5;
              final cell = gameState.board[row][col];

              return CellWidget(
                cell: cell,
                onTap: () => onCellTap(row, col),
              );
            },
          ),
        ],
      ),
    );
  }
}
