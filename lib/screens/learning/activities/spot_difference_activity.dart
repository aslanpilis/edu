import 'package:flutter/material.dart';

class SpotDifferenceActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final ValueChanged<bool> onAnswer;

  const SpotDifferenceActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<SpotDifferenceActivityWidget> createState() => _SpotDifferenceActivityWidgetState();
}

class _DifferenceItem {
  final int id;
  final String label;
  final String leftEmoji;
  final String rightEmoji;
  final bool isDifferent;

  _DifferenceItem({
    required this.id,
    required this.label,
    required this.leftEmoji,
    required this.rightEmoji,
    required this.isDifferent,
  });
}

class _SpotDifferenceActivityWidgetState extends State<SpotDifferenceActivityWidget> {
  late int _level;
  late List<_DifferenceItem> _items;
  final Set<int> _foundDiffIds = {};
  int _totalDiffCount = 0;

  @override
  void initState() {
    super.initState();
    _level = widget.payload['level'] is int ? widget.payload['level'] : 1;
    _setupItems();
  }

  void _setupItems() {
    _foundDiffIds.clear();

    if (_level == 1) {
      // 2 Fark (4x2 Izgara)
      _items = [
        _DifferenceItem(id: 1, label: 'Güneş', leftEmoji: '☀️', rightEmoji: '☀️', isDifferent: false),
        _DifferenceItem(id: 2, label: 'Kuş', leftEmoji: '🦜', rightEmoji: '🦉', isDifferent: true), // FARK 1
        _DifferenceItem(id: 3, label: 'Ağaç', leftEmoji: '🌲', rightEmoji: '🌲', isDifferent: false),
        _DifferenceItem(id: 4, label: 'Çiçek', leftEmoji: '🌸', rightEmoji: '🌻', isDifferent: true), // FARK 2
      ];
    } else if (_level == 2) {
      // 3 Fark (6 item)
      _items = [
        _DifferenceItem(id: 1, label: 'Roket', leftEmoji: '🚀', rightEmoji: '🚀', isDifferent: false),
        _DifferenceItem(id: 2, label: 'Gezegen', leftEmoji: '🪐', rightEmoji: '🌍', isDifferent: true), // FARK 1
        _DifferenceItem(id: 3, label: 'Astronot', leftEmoji: '👨‍🚀', rightEmoji: '👨‍🚀', isDifferent: false),
        _DifferenceItem(id: 4, label: 'Yıldız', leftEmoji: '⭐', rightEmoji: '🌟', isDifferent: true), // FARK 2
        _DifferenceItem(id: 5, label: 'Uzaylı', leftEmoji: '👽', rightEmoji: '👾', isDifferent: true), // FARK 3
        _DifferenceItem(id: 6, label: 'Ay', leftEmoji: '🌙', rightEmoji: '🌙', isDifferent: false),
      ];
    } else {
      // Level 3 (4 Fark - 8 item)
      _items = [
        _DifferenceItem(id: 1, label: 'Balık', leftEmoji: '🐠', rightEmoji: '🐡', isDifferent: true), // FARK 1
        _DifferenceItem(id: 2, label: 'Denizatı', leftEmoji: '🪸', rightEmoji: '🪸', isDifferent: false),
        _DifferenceItem(id: 3, label: 'Ahtapot', leftEmoji: '🐙', rightEmoji: '🦑', isDifferent: true), // FARK 2
        _DifferenceItem(id: 4, label: 'Yunus', leftEmoji: '🐬', rightEmoji: '🐬', isDifferent: false),
        _DifferenceItem(id: 5, label: 'Kaplumbağa', leftEmoji: '🐢', rightEmoji: '🦀', isDifferent: true), // FARK 3
        _DifferenceItem(id: 6, label: 'Deniz Yıldızı', leftEmoji: '⭐', rightEmoji: '⭐', isDifferent: false),
        _DifferenceItem(id: 7, label: 'İstiridye', leftEmoji: '🦪', rightEmoji: '🐚', isDifferent: true), // FARK 4
        _DifferenceItem(id: 8, label: 'Dalgıç', leftEmoji: '🤿', rightEmoji: '🤿', isDifferent: false),
      ];
    }

    _totalDiffCount = _items.where((i) => i.isDifferent).length;
  }

  void _onItemTapped(_DifferenceItem item) {
    if (item.isDifferent) {
      if (!_foundDiffIds.contains(item.id)) {
        setState(() {
          _foundDiffIds.add(item.id);
        });

        if (_foundDiffIds.length == _totalDiffCount) {
          Future.delayed(const Duration(milliseconds: 700), () {
            if (mounted) widget.onAnswer(true);
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu iki görsel birbirinin aynısı, farklı olanları ara! 🔎'),
          duration: Duration(milliseconds: 800),
          backgroundColor: Color(0xFF64748B),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.pink.shade300),
                ),
                child: Text(
                  '🔎 Fark Bulma • Seviye $_level',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.pink.shade900, fontSize: 13),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('Bulunan Fark: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
                    Text(
                      '${_foundDiffIds.length} / $_totalDiffCount',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.amber.shade900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text(
            'Sol ve sağ resimleri karşılaştır, farklı olan kutulara dokun! 👇',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Side-by-Side Comparison Boards
          Expanded(
            child: Row(
              children: [
                // Sol Tablo
                Expanded(child: _buildGridPanel('Resim A 🅰️', false)),
                const SizedBox(width: 10),
                // Sağ Tablo
                Expanded(child: _buildGridPanel('Resim B 🅱️', true)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPanel(String title, bool isRightSide) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isRightSide ? const Color(0xFFF1F5F9) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isRightSide ? const Color(0xFFCBD5E1) : const Color(0xFFBFDBFE), width: 2),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF1E293B))),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: _items.length > 6 ? 1.0 : 1.2,
              ),
              itemCount: _items.length,
              itemBuilder: (context, idx) {
                final item = _items[idx];
                final isFound = _foundDiffIds.contains(item.id);
                final emoji = isRightSide ? item.rightEmoji : item.leftEmoji;

                return GestureDetector(
                  onTap: () => _onItemTapped(item),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isFound ? const Color(0xFFD1FAE5) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isFound ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                        width: isFound ? 3 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(emoji, style: TextStyle(fontSize: _items.length > 6 ? 24 : 32)),
                        if (isFound)
                          const Positioned(
                            top: 2,
                            right: 2,
                            child: Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
