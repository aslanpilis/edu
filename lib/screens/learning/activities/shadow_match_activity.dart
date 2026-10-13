import 'package:flutter/material.dart';

class ShadowMatchActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const ShadowMatchActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<ShadowMatchActivityWidget> createState() => _ShadowMatchActivityWidgetState();
}

class _ShadowMatchActivityWidgetState extends State<ShadowMatchActivityWidget> {
  String? _selected;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final targetEmoji = widget.payload['targetEmoji'] ?? '🐘';
    final targetName = widget.payload['targetName'] ?? 'Fil';
    final options = (widget.payload['options'] as List<dynamic>? ?? ['🐘', '🦒', '🦁', '🐻'])
        .map((e) => e.toString())
        .toList();

    return Column(
      children: [
        // Silhouette Shadow Card
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Opacity(
            opacity: 0.35,
            child: Text(
              targetEmoji,
              style: const TextStyle(fontSize: 72),
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Bu gölge hangi sevimli hayvana ait? 🕵️‍♂️',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 24),

        // 4 Options Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
            ),
            itemCount: options.length,
            itemBuilder: (context, idx) {
              final opt = options[idx];
              final isSelected = _selected == opt;

              Color border = const Color(0xFFE2E8F0);
              Color bg = Colors.white;

              if (isSelected && _isCorrect != null) {
                border = _isCorrect! ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                bg = _isCorrect! ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
              }

              return InkWell(
                onTap: () {
                  final correct = opt == targetEmoji;
                  setState(() {
                    _selected = opt;
                    _isCorrect = correct;
                  });
                  widget.onAnswer(correct);
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
                  alignment: Alignment.center,
                  child: Text(opt, style: const TextStyle(fontSize: 48)),
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
              _isCorrect! ? '🎉 Tebrikler! Doğru gölge: $targetName!' : '🤔 Gölgelerin hatlarına dikkatlice bak!',
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
