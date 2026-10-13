import 'package:flutter/material.dart';

class BalanceScaleActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const BalanceScaleActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<BalanceScaleActivityWidget> createState() => _BalanceScaleActivityWidgetState();
}

class _BalanceScaleActivityWidgetState extends State<BalanceScaleActivityWidget> {
  String? _selectedSide;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final leftItem = widget.payload['leftItem'] ?? {'emoji': '🐘', 'name': 'Fil', 'weight': 100};
    final rightItem = widget.payload['rightItem'] ?? {'emoji': '🍎', 'name': 'Elma', 'weight': 1};
    final question = widget.payload['question'] ?? 'Hangisi daha AĞIR? ⚖️';
    final targetHeavy = widget.payload['targetHeavy'] ?? true;

    final leftWeight = leftItem['weight'] as int? ?? 1;
    final rightWeight = rightItem['weight'] as int? ?? 1;

    final correctSide = (targetHeavy && leftWeight > rightWeight) || (!targetHeavy && leftWeight < rightWeight)
        ? 'LEFT'
        : 'RIGHT';

    return Column(
      children: [
        // Question Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF60A5FA), width: 2),
          ),
          child: Text(
            question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E40AF)),
          ),
        ),
        const SizedBox(height: 24),

        // Scale Visual
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
          ),
          child: Column(
            children: [
              const Text('⚖️ Denge Terazisi', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Left Side Option
                  _buildScalePan(
                    side: 'LEFT',
                    emoji: leftItem['emoji'] ?? '🐘',
                    name: leftItem['name'] ?? 'Fil',
                    isSelected: _selectedSide == 'LEFT',
                    onTap: () {
                      final correct = correctSide == 'LEFT';
                      setState(() {
                        _selectedSide = 'LEFT';
                        _isCorrect = correct;
                      });
                      widget.onAnswer(correct);
                    },
                  ),

                  // Fulcrum Pivot
                  Container(
                    width: 24,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF64748B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Right Side Option
                  _buildScalePan(
                    side: 'RIGHT',
                    emoji: rightItem['emoji'] ?? '🍎',
                    name: rightItem['name'] ?? 'Elma',
                    isSelected: _selectedSide == 'RIGHT',
                    onTap: () {
                      final correct = correctSide == 'RIGHT';
                      setState(() {
                        _selectedSide = 'RIGHT';
                        _isCorrect = correct;
                      });
                      widget.onAnswer(correct);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        if (_isCorrect != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isCorrect! ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _isCorrect! ? '🎉 Harika Tahmin! Çok doğru bir seçim!' : '🤔 Gerçek dünyadaki boyut ve ağırlıkları düşün!',
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

  Widget _buildScalePan({
    required String side,
    required String emoji,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color border = const Color(0xFFE2E8F0);
    Color bg = const Color(0xFFF8FAFC);

    if (isSelected && _isCorrect != null) {
      border = _isCorrect! ? const Color(0xFF10B981) : const Color(0xFFEF4444);
      bg = _isCorrect! ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1E293B)),
            ),
          ],
        ),
      ),
    );
  }
}
