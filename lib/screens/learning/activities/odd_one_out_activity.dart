import 'package:flutter/material.dart';

class OddOneOutActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const OddOneOutActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<OddOneOutActivityWidget> createState() => _OddOneOutActivityWidgetState();
}

class _OddOneOutActivityWidgetState extends State<OddOneOutActivityWidget> {
  String? _selected;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final items = (widget.payload['items'] as List<dynamic>? ?? [
      {'emoji': '🍎', 'label': 'Elma', 'isOdd': false},
      {'emoji': '🍌', 'label': 'Muz', 'isOdd': false},
      {'emoji': '🚗', 'label': 'Araba', 'isOdd': true},
      {'emoji': '🍇', 'label': 'Üzüm', 'isOdd': false},
    ]).map((e) => Map<String, dynamic>.from(e)).toList();

    final hint = widget.payload['hint'] ?? 'Gruba uymayan farklı nesneyi bul! 🔍';

    return Column(
      children: [
        // Hint / Instruction
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF59E0B), width: 2),
          ),
          child: Text(
            hint,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF92400E)),
          ),
        ),
        const SizedBox(height: 24),

        // 2x2 Grid of Items
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
            ),
            itemCount: items.length,
            itemBuilder: (context, idx) {
              final item = items[idx];
              final emoji = item['emoji'] ?? '❓';
              final label = item['label'] ?? '';
              final isOdd = item['isOdd'] == true;
              final isSelected = _selected == emoji;

              Color border = const Color(0xFFE2E8F0);
              Color bg = Colors.white;

              if (isSelected && _isCorrect != null) {
                border = _isCorrect! ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                bg = _isCorrect! ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
              }

              return InkWell(
                onTap: () {
                  setState(() {
                    _selected = emoji;
                    _isCorrect = isOdd;
                  });
                  widget.onAnswer(isOdd);
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: border, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        if (_isCorrect != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isCorrect! ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _isCorrect! ? '🎉 Harika Sınıflandırma Mantığı! Farklı olanı buldun!' : '🤔 Diğer 3 nesnenin ortak özelliğini düşün!',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: _isCorrect! ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
