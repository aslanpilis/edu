import 'package:flutter/material.dart';

class QuizActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const QuizActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<QuizActivityWidget> createState() => _QuizActivityWidgetState();
}

class _QuizActivityWidgetState extends State<QuizActivityWidget> {
  int? _selectedIndex;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final question = widget.payload['question'] ?? 'Soruyu cevaplayın:';
    final options = (widget.payload['options'] as List<dynamic>? ?? ['A', 'B', 'C', 'D'])
        .map((e) => e.toString())
        .toList();
    final correctIndex = widget.payload['correctIndex'] ?? 0;
    final explanation = widget.payload['explanation'] ?? '';

    return Column(
      children: [
        // Question Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Options List
        Expanded(
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final opt = options[idx];
              final isSelected = _selectedIndex == idx;

              Color border = const Color(0xFFE2E8F0);
              Color bg = Colors.white;

              if (isSelected && _isCorrect != null) {
                border = _isCorrect! ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                bg = _isCorrect! ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
              }

              return InkWell(
                onTap: () {
                  final correct = idx == correctIndex;
                  setState(() {
                    _selectedIndex = idx;
                    _isCorrect = correct;
                  });
                  widget.onAnswer(correct);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: border, width: 2.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opt,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (isSelected && _isCorrect != null)
                        Text(_isCorrect! ? '🎉' : '💭', style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        if (_isCorrect != null && explanation.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Text(
              explanation,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF15803D),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
