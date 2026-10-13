import 'package:flutter/material.dart';

class TangramPuzzleActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final ValueChanged<bool> onAnswer;

  const TangramPuzzleActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<TangramPuzzleActivityWidget> createState() => _TangramPuzzleActivityWidgetState();
}

class _TangramPiece {
  final String id;
  final String label;
  final String emoji;
  final Color color;
  final IconData icon;

  _TangramPiece({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
    required this.icon,
  });
}

class _TangramPuzzleActivityWidgetState extends State<TangramPuzzleActivityWidget> {
  late int _level;
  late List<_TangramPiece> _allPieces;
  final Map<String, _TangramPiece?> _placedSlots = {};
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _level = widget.payload['level'] is int ? widget.payload['level'] : 1;
    _setupPuzzle();
  }

  void _setupPuzzle() {
    _placedSlots.clear();
    if (_level == 1) {
      // 3 temel şekil: Daire, Kare, Üçgen
      _allPieces = [
        _TangramPiece(id: 'circle', label: 'Daire', emoji: '🔴', color: const Color(0xFFEF4444), icon: Icons.circle),
        _TangramPiece(id: 'square', label: 'Kare', emoji: '🟦', color: const Color(0xFF3B82F6), icon: Icons.square),
        _TangramPiece(id: 'triangle', label: 'Üçgen', emoji: '🔺', color: const Color(0xFF10B981), icon: Icons.change_history),
      ];
    } else if (_level == 2) {
      // 5 parça: Ev & Roket yapısı
      _allPieces = [
        _TangramPiece(id: 'roof', label: 'Çatı', emoji: '🔺', color: const Color(0xFFF59E0B), icon: Icons.change_history),
        _TangramPiece(id: 'body', label: 'Gövde', emoji: '🟦', color: const Color(0xFF6366F1), icon: Icons.crop_square),
        _TangramPiece(id: 'door', label: 'Kapı', emoji: '🚪', color: const Color(0xFF8B5CF6), icon: Icons.rectangle_outlined),
        _TangramPiece(id: 'window', label: 'Pencere', emoji: '🪟', color: const Color(0xFF06B6D4), icon: Icons.grid_view),
        _TangramPiece(id: 'chimney', label: 'Baca', emoji: '🧱', color: const Color(0xFFEC4899), icon: Icons.view_column),
      ];
    } else {
      // Level 3 (Zor): 7 Parçalı Tangram Gemi / Kuş
      _allPieces = [
        _TangramPiece(id: 'sail1', label: 'Büyük Yelken', emoji: '⛵', color: const Color(0xFF0EA5E9), icon: Icons.navigation),
        _TangramPiece(id: 'sail2', label: 'Küçük Yelken', emoji: '🚩', color: const Color(0xFFF97316), icon: Icons.change_history),
        _TangramPiece(id: 'hull', label: 'Gemi Gövdesi', emoji: '🚢', color: const Color(0xFF14B8A6), icon: Icons.directions_boat),
        _TangramPiece(id: 'mast', label: 'Direk', emoji: '🦯', color: const Color(0xFF64748B), icon: Icons.view_headline),
        _TangramPiece(id: 'flag', label: 'Flama', emoji: '🏳️', color: const Color(0xFFEF4444), icon: Icons.flag),
        _TangramPiece(id: 'sun', label: 'Güneş', emoji: '☀️', color: const Color(0xFFEAB308), icon: Icons.wb_sunny),
        _TangramPiece(id: 'wave', label: 'Dalga', emoji: '🌊', color: const Color(0xFF3B82F6), icon: Icons.waves),
      ];
    }

    for (var p in _allPieces) {
      _placedSlots[p.id] = null;
    }
  }

  void _onPiecePlaced(String slotId, _TangramPiece piece) {
    if (slotId == piece.id) {
      setState(() {
        _placedSlots[slotId] = piece;
        _score++;
      });

      if (_placedSlots.values.every((p) => p != null)) {
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) widget.onAnswer(true);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu parça buraya tam uymadı, başka bir yuvayı dene! 🧩'),
          duration: Duration(milliseconds: 900),
          backgroundColor: Color(0xFFF59E0B),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availablePieces = _allPieces.where((p) => !_placedSlots.values.contains(p)).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple.shade300),
                ),
                child: Text(
                  '🧩 Tangram • Seviye $_level',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.purple.shade800, fontSize: 13),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Yerleşen: $_score / ${_allPieces.length}',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.amber.shade900, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Target Blueprint Silhouette Board
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF334155), width: 3),
              ),
              child: Column(
                children: [
                  const Text(
                    'Şekil Yuvalarına Parçaları Sürükle!',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: _allPieces.map((piece) {
                        final placed = _placedSlots[piece.id];

                        return DragTarget<_TangramPiece>(
                          onWillAcceptWithDetails: (details) => true,
                          onAcceptWithDetails: (details) => _onPiecePlaced(piece.id, details.data),
                          builder: (context, candidateData, rejectedData) {
                            final isHovered = candidateData.isNotEmpty;

                            if (placed != null) {
                              return Container(
                                width: _level == 3 ? 75 : 90,
                                height: _level == 3 ? 75 : 90,
                                decoration: BoxDecoration(
                                  color: placed.color,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: placed.color.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(placed.icon, color: Colors.white, size: _level == 3 ? 30 : 36),
                                    const SizedBox(height: 2),
                                    Text(
                                      placed.label,
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Container(
                              width: _level == 3 ? 75 : 90,
                              height: _level == 3 ? 75 : 90,
                              decoration: BoxDecoration(
                                color: isHovered ? Colors.cyan.withValues(alpha: 0.3) : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isHovered ? Colors.cyanAccent : const Color(0xFF475569),
                                  width: isHovered ? 3 : 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(piece.icon, color: const Color(0xFF475569), size: _level == 3 ? 28 : 34),
                                  const SizedBox(height: 2),
                                  Text(
                                    piece.label,
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Available Draggable Pieces Tray
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: availablePieces.map((p) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Draggable<_TangramPiece>(
                        data: p,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: p.color,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
                            ),
                            alignment: Alignment.center,
                            child: Icon(p.icon, color: Colors.white, size: 40),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: p.color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: p.color,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: p.color.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 3)),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(p.icon, color: Colors.white, size: 30),
                              const SizedBox(height: 2),
                              Text(
                                p.label,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
