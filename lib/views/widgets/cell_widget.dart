import 'package:flutter/material.dart';
import '../../models/bingo_cell.dart';

class CellWidget extends StatelessWidget {
  final BingoCell cell;
  final VoidCallback onTap;

  const CellWidget({
    super.key,
    required this.cell,
    required this.onTap,
  });

  /// Column theme color according to B-I-N-G-O index
  static Color getColumnColor(int colIndex) {
    switch (colIndex) {
      case 0:
        return const Color(
            0xFFFF5252); // B - Red/Coral
      case 1:
        return const Color(
            0xFFFFC107); // I - Amber
      case 2:
        return const Color(
            0xFF00E676); // N - Green
      case 3:
        return const Color(
            0xFF00B0FF); // G - Cyan/Blue
      case 4:
        return const Color(
            0xFFAA00FF); // O - Purple
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colColor = getColumnColor(cell.col);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: colColor.withValues(alpha: 0.4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: _buildBoxDecoration(colColor),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cell Content
              if (cell.isFree)
                _buildFreeContent()
              else
                _buildNumberContent(colColor),

              // Marked Overlay Indicator (Badge/Icon + Visual Stamp)
              if (cell.isMarked && !cell.isFree)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: cell.isWinning ? Colors.amber : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: cell.isWinning ? Colors.black : Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(Color colColor) {
    if (cell.isWinning) {
      return BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.8),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.white, width: 2.5),
      );
    }

    if (cell.isFree) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colColor.withValues(alpha: 0.35),
            colColor.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colColor.withValues(alpha: 0.3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      );
    }

    if (cell.isMarked) {
      return BoxDecoration(
        color: colColor.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colColor.withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      );
    }

    // Default Unmarked State
    return BoxDecoration(
      color: const Color(0xFF1E1F38),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.12),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildFreeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.star_rounded,
          color: Colors.amber,
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          'FREE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.1,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberContent(Color colColor) {
    final textColor = cell.isWinning
        ? Colors.black
        : (cell.isMarked ? Colors.white : Colors.white.withValues(alpha: 0.95));

    return Center(
      child: Text(
        '${cell.value}',
        style: TextStyle(
          color: textColor,
          fontWeight: cell.isMarked ? FontWeight.bold : FontWeight.w600,
          fontSize: 22,
        ),
      ),
    );
  }
}
