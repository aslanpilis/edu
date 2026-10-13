import 'package:flutter/material.dart';

class LogicPatternActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const LogicPatternActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<LogicPatternActivityWidget> createState() => _LogicPatternActivityWidgetState();
}

class _LogicPatternActivityWidgetState extends State<LogicPatternActivityWidget> {
  String? _selected;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final sequence = (widget.payload['sequence'] as List<dynamic>? ?? ['🔴', '🟦', '🔴', '🟦'])
        .map((e) => e.toString())
        .toList();
    final correctAnswer = widget.payload['correctAnswer'] ?? '🔴';
    final options = (widget.payload['options'] as List<dynamic>? ?? ['🔴', '🟦', '⭐', '🔺'])
        .map((e) => e.toString())
        .toList();

    return Column(
      children: [
        // Pattern Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
          ),
          child: Column(
            children: [
              const Text(
                'Sıradaki Şekil Hangisi Olmalı?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...sequence.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(item, style: const TextStyle(fontSize: 32)),
                      )),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _selected ?? '❓',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        const Text(
          'Seçeneklerden birine dokun:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),

        // Options Row
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: options.map((opt) {
            final isSelected = _selected == opt;
            return InkWell(
              onTap: () {
                final correct = opt == correctAnswer;
                setState(() {
                  _selected = opt;
                  _isCorrect = correct;
                });
                widget.onAnswer(correct);
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: isSelected && _isCorrect != null
                      ? (_isCorrect! ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2))
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected && _isCorrect != null
                        ? (_isCorrect! ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                        : const Color(0xFFCBD5E1),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(opt, style: const TextStyle(fontSize: 34)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
