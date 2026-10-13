import 'package:flutter/material.dart';

class ColorMixActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const ColorMixActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<ColorMixActivityWidget> createState() => _ColorMixActivityWidgetState();
}

class _ColorMixActivityWidgetState extends State<ColorMixActivityWidget> {
  final List<String> _selectedColors = [];
  bool? _isSuccess;

  void _onSelectColor(String colorKey) {
    if (_selectedColors.contains(colorKey)) {
      setState(() => _selectedColors.remove(colorKey));
      return;
    }

    if (_selectedColors.length < 2) {
      setState(() => _selectedColors.add(colorKey));
    }

    if (_selectedColors.length == 2) {
      final req1 = widget.payload['requiredColor1'] ?? 'RED';
      final req2 = widget.payload['requiredColor2'] ?? 'BLUE';

      final isCorrect = (_selectedColors.contains(req1) && _selectedColors.contains(req2));

      setState(() => _isSuccess = isCorrect);
      widget.onAnswer(isCorrect);
    }
  }

  void _reset() {
    setState(() {
      _selectedColors.clear();
      _isSuccess = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final targetColorName = widget.payload['targetColorName'] ?? 'Mor';
    final targetColorEmoji = widget.payload['targetColorEmoji'] ?? '🟣';
    final targetColorHex = widget.payload['targetColorHex'] as Color? ?? const Color(0xFF8B5CF6);

    final availableBottles = [
      {'key': 'RED', 'name': 'Kırmızı', 'emoji': '🔴', 'color': const Color(0xFFEF4444)},
      {'key': 'BLUE', 'name': 'Mavi', 'emoji': '🔵', 'color': const Color(0xFF3B82F6)},
      {'key': 'YELLOW', 'name': 'Sarı', 'emoji': '🟡', 'color': const Color(0xFFEAB308)},
    ];

    return Column(
      children: [
        // Target Flask
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text('🧪 Sihirli Renk Laboratuvarı', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
              const SizedBox(height: 12),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: targetColorHex,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: targetColorHex.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(targetColorEmoji, style: const TextStyle(fontSize: 38)),
              ),
              const SizedBox(height: 10),
              Text(
                'Hangi 2 rengi karıştırırsak $targetColorName olur?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3 Mixing Flask Options
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: availableBottles.map((b) {
            final key = b['key'] as String;
            final isSelected = _selectedColors.contains(key);
            final color = b['color'] as Color;

            return InkWell(
              onTap: () => _onSelectColor(key),
              borderRadius: BorderRadius.circular(24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 95,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? color : const Color(0xFFCBD5E1),
                    width: isSelected ? 4 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? color.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.04),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(b['emoji'] as String, style: const TextStyle(fontSize: 38)),
                    const SizedBox(height: 8),
                    Text(
                      b['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: isSelected ? color : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSelected ? '✓ Seçildi' : '+ Karıştır',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: isSelected ? color : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        if (_isSuccess != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isSuccess! ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _isSuccess! ? '🎉 Tebrikler Sihirbaz! Doğru renk iksirini buldun!' : '🤔 Bu iki renk farklı bir ton oluşturur, tekrar dene!',
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
