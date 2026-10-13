import 'package:flutter/material.dart';

class MemoryMatchActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const MemoryMatchActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<MemoryMatchActivityWidget> createState() => _MemoryMatchActivityWidgetState();
}

class _MemoryCardItem {
  final int id;
  final String emoji;
  final String label;
  bool isFlipped;
  bool isMatched;

  _MemoryCardItem({
    required this.id,
    required this.emoji,
    required this.label,
  })  : isFlipped = false,
        isMatched = false;
}

class _MemoryMatchActivityWidgetState extends State<MemoryMatchActivityWidget> {
  late List<_MemoryCardItem> _cards;
  int? _firstFlippedIndex;
  bool _isProcessing = false;
  int _matchedPairsCount = 0;
  int _totalPairs = 3;

  int _level = 1;

  @override
  void initState() {
    super.initState();
    _level = widget.payload['level'] is int ? widget.payload['level'] : 1;
    _initCards();
  }

  void _initCards() {
    List<Map<String, String>> defaultPool = [
      {'emoji': '🐶', 'label': 'Köpek'},
      {'emoji': '🐱', 'label': 'Kedi'},
      {'emoji': '🐰', 'label': 'Tavşan'},
      {'emoji': '🦁', 'label': 'Aslan'},
      {'emoji': '🐼', 'label': 'Panda'},
      {'emoji': '🦊', 'label': 'Tilki'},
    ];

    int pairsCount;
    if (_level == 1) {
      pairsCount = 2; // 4 kart
    } else if (_level == 2) {
      pairsCount = 3; // 6 kart
    } else if (_level == 3) {
      pairsCount = 4; // 8 kart
    } else {
      pairsCount = 6; // 12 kart
    }

    final pairs = (widget.payload['pairs'] as List<dynamic>?)?.map((e) => Map<String, String>.from(e)).toList() ??
        defaultPool.take(pairsCount).toList();

    _totalPairs = pairs.length;
    _matchedPairsCount = 0;
    _firstFlippedIndex = null;
    _isProcessing = false;

    final List<_MemoryCardItem> cardList = [];
    int idCounter = 0;

    for (final p in pairs) {
      final emoji = p['emoji'] ?? '🐶';
      final label = p['label'] ?? 'Hayvan';
      cardList.add(_MemoryCardItem(id: idCounter++, emoji: emoji, label: label));
      cardList.add(_MemoryCardItem(id: idCounter++, emoji: emoji, label: label));
    }

    cardList.shuffle();
    _cards = cardList;
  }

  void _onCardTap(int index) {
    if (_isProcessing || _cards[index].isFlipped || _cards[index].isMatched) {
      return;
    }

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      final first = _cards[_firstFlippedIndex!];
      final second = _cards[index];

      if (first.emoji == second.emoji) {
        // Matched!
        setState(() {
          first.isMatched = true;
          second.isMatched = true;
          _firstFlippedIndex = null;
          _matchedPairsCount++;
        });

        if (_matchedPairsCount == _totalPairs) {
          widget.onAnswer(true);
        }
      } else {
        // Not matched, flip back after brief delay
        _isProcessing = true;
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            setState(() {
              first.isFlipped = false;
              second.isFlipped = false;
              _firstFlippedIndex = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAllMatched = _matchedPairsCount == _totalPairs;

    return Column(
      children: [
        // Status & Instruction Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF59E0B)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aynı sevimli hayvanları eşleştir! 🃏',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF92400E)),
              ),
              Text(
                '$_matchedPairsCount/$_totalPairs Eşleşme',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFFB45309)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Memory Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _cards.length <= 4 ? 2 : (_cards.length >= 12 ? 4 : 3),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: _cards.length >= 12 ? 0.85 : 0.95,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final card = _cards[index];
              final showContent = card.isFlipped || card.isMatched;

              return InkWell(
                onTap: () => _onCardTap(index),
                borderRadius: BorderRadius.circular(22),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: card.isMatched
                        ? const Color(0xFFD1FAE5)
                        : showContent
                            ? Colors.white
                            : const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: card.isMatched
                          ? const Color(0xFF10B981)
                          : showContent
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF4F46E5),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: showContent
                      ? Text(card.emoji, style: const TextStyle(fontSize: 44))
                      : const Text('❓', style: TextStyle(fontSize: 32, color: Colors.white)),
                ),
              );
            },
          ),
        ),

        if (isAllMatched) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF86EFAC)),
            ),
            child: const Text(
              '🎉 Harika Hafıza! Tüm kartları doğru eşleştirdin!',
              style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF15803D), fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
