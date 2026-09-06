import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../utils/bingo_generator.dart';
import 'cell_widget.dart';

class HistoryBar extends StatelessWidget {
  final GameState gameState;

  const HistoryBar({
    super.key,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    final calledList = gameState.calledNumbers;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F38),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_rounded,
                      color: Color(0xFF00E5FF), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'CALLED NUMBERS HISTORY',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showFullHistorySheet(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: const Color(0xFF00E5FF),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right_rounded,
                          color: Color(0xFF00E5FF), size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (calledList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  'No numbers called yet. Tap "Call Next" to start!',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                reverse: true, // Shows newest called numbers first
                itemCount: calledList.length,
                itemBuilder: (context, index) {
                  final number = calledList[calledList.length - 1 - index];
                  final isLatest = index == 0;
                  final letter = BingoGenerator.getColumnForNumber(number);
                  final colColor = _getLetterColor(letter);

                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLatest
                          ? colColor
                          : colColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isLatest
                            ? Colors.white
                            : colColor.withValues(alpha: 0.5),
                        width: isLatest ? 1.5 : 1,
                      ),
                      boxShadow: isLatest
                          ? [
                              BoxShadow(
                                color: colColor.withValues(alpha: 0.5),
                                blurRadius: 6,
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        '$letter-$number',
                        style: TextStyle(
                          color: isLatest ? Colors.white : Colors.white70,
                          fontWeight:
                              isLatest ? FontWeight.w900 : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showFullHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14152A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Called Numbers Sheet (1-75)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: List.generate(5, (colIdx) {
                    final colLetters = ['B', 'I', 'N', 'G', 'O'];
                    final letter = colLetters[colIdx];
                    final minNum = colIdx * 15 + 1;
                    final maxNum = minNum + 14;
                    final colColor = CellWidget.getColumnColor(colIdx);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: colColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    letter,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$letter Column ($minNum - $maxNum)',
                                style: TextStyle(
                                  color: colColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(15, (numIdx) {
                              final numVal = minNum + numIdx;
                              final isCalled =
                                  gameState.calledNumbers.contains(numVal);
                              final isLatest =
                                  gameState.lastCalledNumber == numVal;

                              return Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isCalled
                                      ? (isLatest
                                          ? colColor
                                          : colColor.withValues(alpha: 0.3))
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isCalled
                                        ? colColor
                                        : Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '$numVal',
                                    style: TextStyle(
                                      color: isCalled
                                          ? Colors.white
                                          : Colors.white38,
                                      fontWeight: isCalled
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
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
