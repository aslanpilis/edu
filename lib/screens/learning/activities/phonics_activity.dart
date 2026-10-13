import 'package:flutter/material.dart';

class PhonicsActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const PhonicsActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<PhonicsActivityWidget> createState() => _PhonicsActivityWidgetState();
}

class _PhonicsActivityWidgetState extends State<PhonicsActivityWidget> {
  String? _selectedOption;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final letter = widget.payload['letter'] ?? 'A';
    final correctLabel = widget.payload['correctLabel'] ?? '🐝 Arı';
    final options = (widget.payload['options'] as List<dynamic>? ?? ['🐝 Arı', '🐘 Fil', '🐟 Balık'])
        .map((e) => e.toString())
        .toList();

    return Column(
      children: [
        // Giant Letter Box
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF43F5E).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Bu harfin sesi ile başlayan hangisi?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 24),

        // Option Cards
        Expanded(
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, idx) {
              final opt = options[idx];
              final isSelected = _selectedOption == opt;

              Color borderColor = const Color(0xFFE2E8F0);
              Color bgColor = Colors.white;

              if (isSelected && _isCorrect != null) {
                borderColor = _isCorrect! ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                bgColor = _isCorrect! ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
              }

              return InkWell(
                onTap: () {
                  final correct = opt == correctLabel;
                  setState(() {
                    _selectedOption = opt;
                    _isCorrect = correct;
                  });
                  widget.onAnswer(correct);
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opt,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (isSelected && _isCorrect != null)
                        Text(
                          _isCorrect! ? '✅' : '❌',
                          style: const TextStyle(fontSize: 22),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
