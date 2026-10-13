import 'package:flutter/material.dart';

class HabitatSortActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const HabitatSortActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<HabitatSortActivityWidget> createState() => _HabitatSortActivityWidgetState();
}

class _HabitatSortActivityWidgetState extends State<HabitatSortActivityWidget> {
  String? _selectedHabitat;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final creatureEmoji = widget.payload['creatureEmoji'] ?? '🐠';
    final creatureName = widget.payload['creatureName'] ?? 'Palyaço Balığı';
    final correctHabitat = widget.payload['correctHabitat'] ?? 'SEA';
    final habitats = (widget.payload['habitats'] as List<dynamic>? ?? [
      {'id': 'SEA', 'emoji': '🌊', 'name': 'Deniz'},
      {'id': 'FOREST', 'emoji': '🌲', 'name': 'Orman'},
      {'id': 'DESERT', 'emoji': '🏜️', 'name': 'Çöl'},
    ]).map((e) => Map<String, dynamic>.from(e)).toList();

    return Column(
      children: [
        // Creature Showcase
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
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
              Text(creatureEmoji, style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 6),
              Text(
                '$creatureName Nerede Yaşar? 🏠',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Habitats
        Expanded(
          child: ListView.separated(
            itemCount: habitats.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final hab = habitats[idx];
              final isSelected = _selectedHabitat == hab['id'];

              Color border = const Color(0xFFE2E8F0);
              Color bg = Colors.white;

              if (isSelected && _isCorrect != null) {
                border = _isCorrect! ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                bg = _isCorrect! ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
              }

              return InkWell(
                onTap: () {
                  final correct = hab['id'] == correctHabitat;
                  setState(() {
                    _selectedHabitat = hab['id'];
                    _isCorrect = correct;
                  });
                  widget.onAnswer(correct);
                },
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: border, width: 3),
                  ),
                  child: Row(
                    children: [
                      Text(hab['emoji'] ?? '🏠', style: const TextStyle(fontSize: 34)),
                      const SizedBox(width: 16),
                      Text(
                        hab['name'] ?? '',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      const Spacer(),
                      if (isSelected && _isCorrect != null)
                        Text(_isCorrect! ? '✅' : '❌', style: const TextStyle(fontSize: 22)),
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
              _isCorrect! ? '🎉 Harika Doğa Bilgisi! Doğru yaşam alanını seçtin!' : '🤔 Bu canlı nasıl nefes alır ve ne yer, tekrar düşün!',
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
