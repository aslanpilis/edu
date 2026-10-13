import 'package:flutter/material.dart';

class MatrixLogicActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final ValueChanged<bool> onAnswer;

  const MatrixLogicActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<MatrixLogicActivityWidget> createState() => _MatrixLogicActivityWidgetState();
}

class _MatrixLogicActivityWidgetState extends State<MatrixLogicActivityWidget> {
  late int _level;
  late int _gridSize;
  late List<String> _symbols;
  late List<List<String?>> _board;
  late List<List<String>> _solution;
  late List<List<bool>> _isFixed;

  int? _selectedRow;
  int? _selectedCol;
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _level = widget.payload['level'] is int ? widget.payload['level'] : 1;
    _setupMatrix();
  }

  void _setupMatrix() {
    if (_level == 1) {
      _gridSize = 3;
      _symbols = ['🦁', '🐘', '🦒'];
      _solution = [
        ['🦁', '🐘', '🦒'],
        ['🦒', '🦁', '🐘'],
        ['🐘', '🦒', '🦁'],
      ];
      // 1 hücre eksik
      _board = [
        ['🦁', '🐘', '🦒'],
        ['🦒', null, '🐘'],
        ['🐘', '🦒', '🦁'],
      ];
      _isFixed = [
        [true, true, true],
        [true, false, true],
        [true, true, true],
      ];
    } else if (_level == 2) {
      _gridSize = 3;
      _symbols = ['🍎', '🍌', '🍇'];
      _solution = [
        ['🍎', '🍌', '🍇'],
        ['🍇', '🍎', '🍌'],
        ['🍌', '🍇', '🍎'],
      ];
      // 3 hücre eksik
      _board = [
        ['🍎', null, '🍇'],
        [null, '🍎', '🍌'],
        ['🍌', '🍇', null],
      ];
      _isFixed = [
        [true, false, true],
        [false, true, true],
        [true, true, false],
      ];
    } else {
      // Level 3 (4x4 Sayı Sudoku)
      _gridSize = 4;
      _symbols = ['1', '2', '3', '4'];
      _solution = [
        ['1', '2', '3', '4'],
        ['3', '4', '1', '2'],
        ['2', '1', '4', '3'],
        ['4', '3', '2', '1'],
      ];
      _board = [
        ['1', null, '3', '4'],
        [null, '4', '1', null],
        ['2', '1', null, '3'],
        ['4', null, '2', '1'],
      ];
      _isFixed = [
        [true, false, true, true],
        [false, true, true, false],
        [true, true, false, true],
        [true, false, true, true],
      ];
    }
  }

  void _selectCell(int r, int c) {
    if (_isFixed[r][c] || _isSolved) return;
    setState(() {
      _selectedRow = r;
      _selectedCol = c;
    });
  }

  void _fillSymbol(String symbol) {
    if (_selectedRow == null || _selectedCol == null || _isSolved) return;
    final r = _selectedRow!;
    final c = _selectedCol!;

    setState(() {
      _board[r][c] = symbol;
    });

    // Doğruluk kontrolü
    _checkSolution();
  }

  void _checkSolution() {
    bool allFilled = true;
    bool allCorrect = true;

    for (int r = 0; r < _gridSize; r++) {
      for (int c = 0; c < _gridSize; c++) {
        if (_board[r][c] == null) {
          allFilled = false;
        } else if (_board[r][c] != _solution[r][c]) {
          allCorrect = false;
        }
      }
    }

    if (allFilled && allCorrect) {
      setState(() => _isSolved = true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) widget.onAnswer(true);
      });
    } else if (allFilled && !allCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Satır ve sütunları kontrol et, bazı semboller çakışıyor! 🤔'),
          duration: Duration(milliseconds: 1000),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        children: [
          // Level info header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal.shade300),
                ),
                child: Text(
                  '🔢 Mantık Matrisi • Seviye $_level',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.teal.shade900, fontSize: 13),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Çakışmasız doldur!',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blue, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Matrix Grid Container
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
                ),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_gridSize, (r) {
                      return Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_gridSize, (c) {
                            final val = _board[r][c];
                            final isFixed = _isFixed[r][c];
                            final isSelected = _selectedRow == r && _selectedCol == c;

                            Color cellBg = isFixed ? const Color(0xFFF1F5F9) : Colors.white;
                            if (isSelected) cellBg = const Color(0xFFCCFBF1);
                            if (_isSolved) cellBg = const Color(0xFFD1FAE5);

                            return Expanded(
                              child: GestureDetector(
                                onTap: () => _selectCell(r, c),
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: cellBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF0D9488)
                                          : (val == null ? const Color(0xFFCBD5E1) : const Color(0xFF94A3B8)),
                                      width: isSelected ? 3 : 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: val == null
                                      ? const Icon(Icons.help_outline, color: Color(0xFF94A3B8), size: 24)
                                      : Text(
                                          val,
                                          style: TextStyle(
                                            fontSize: _gridSize == 4 ? 26 : 34,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Symbol Picker Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _symbols.map((sym) {
                return ElevatedButton(
                  onPressed: _selectedRow != null && !_isSolved ? () => _fillSymbol(sym) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 3,
                  ),
                  child: Text(
                    sym,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
