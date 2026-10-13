import 'package:flutter/material.dart';

class SizeOrderActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const SizeOrderActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<SizeOrderActivityWidget> createState() => _SizeOrderActivityWidgetState();
}

class _SizeOrderActivityWidgetState extends State<SizeOrderActivityWidget> {
  final List<int> _tappedIndices = [];
  bool? _isSuccess;

  void _onTap(int index, int totalCount) {
    if (_tappedIndices.contains(index)) return;

    setState(() {
      _tappedIndices.add(index);
    });

    if (_tappedIndices.length == totalCount) {
      // Check if ordered from smallest size to largest size (1, 2, 3)
      bool isCorrect = true;
      for (int i = 0; i < totalCount; i++) {
        if (_tappedIndices[i] != i) {
          isCorrect = false;
          break;
        }
      }

      setState(() => _isSuccess = isCorrect);
      widget.onAnswer(isCorrect);
    }
  }

  void _reset() {
    setState(() {
      _tappedIndices.clear();
      _isSuccess = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Items with sizes 1 (small), 2 (medium), 3 (large)
    final items = (widget.payload['items'] as List<dynamic>? ?? [
      {'size': 1, 'emoji': '🐻', 'fontSize': 32.0, 'label': 'Küçük'},
      {'size': 2, 'emoji': '🐻', 'fontSize': 48.0, 'label': 'Orta'},
      {'size': 3, 'emoji': '🐻', 'fontSize': 64.0, 'label': 'Büyük'},
    ]).map((e) => Map<String, dynamic>.from(e)).toList();

    // Shuffled display order
    final displayOrder = [1, 0, 2]; // medium, small, large display

    return Column(
      children: [
        // Instruction Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF59E0B)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'En KÜÇÜKTEN en BÜYÜĞE sırayla dokun! 📏',
                style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF92400E), fontSize: 13),
              ),
              IconButton(
                onPressed: _reset,
                icon: const Icon(Icons.refresh, color: Color(0xFFD97706)),
                tooltip: 'Sıfırla',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Size Cards Row
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayOrder.map((realIdx) {
              final item = items[realIdx];
              final isTapped = _tappedIndices.contains(realIdx);
              final tapOrderIndex = _tappedIndices.indexOf(realIdx);

              return InkWell(
                onTap: () => _onTap(realIdx, items.length),
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 95,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isTapped ? const Color(0xFFD1FAE5) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isTapped ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                      width: isTapped ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['emoji'] ?? '🐻', style: TextStyle(fontSize: item['fontSize'] as double)),
                      const SizedBox(height: 12),
                      if (isTapped)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${tapOrderIndex + 1}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                          ),
                        )
                      else
                        const Text('?', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w800, fontSize: 16)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        if (_isSuccess != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isSuccess! ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _isSuccess! ? '🎉 Harika Boyut Sıralaması! Küçükten büyüğe tam dizdin!' : '🤔 Sıralama yanlış oldu, 🔄 ile tekrar dene!',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: _isSuccess! ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
