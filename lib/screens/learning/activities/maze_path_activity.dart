import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';

class MazePathActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const MazePathActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<MazePathActivityWidget> createState() => _MazePathActivityWidgetState();
}

class _MazePathActivityWidgetState extends State<MazePathActivityWidget> {
  late int _rabbitRow;
  late int _rabbitCol;
  late int _targetRow;
  late int _targetCol;
  late List<List<int>> _grid; // 0: empty, 1: obstacle
  final List<String> _commands = [];
  bool _isMoving = false;
  bool? _isSuccess;

  @override
  void initState() {
    super.initState();
    _initGrid();
  }

  void _initGrid() {
    _rabbitRow = widget.payload['startRow'] ?? 0;
    _rabbitCol = widget.payload['startCol'] ?? 0;
    _targetRow = widget.payload['targetRow'] ?? 2;
    _targetCol = widget.payload['targetCol'] ?? 2;

    _grid = [
      [0, 0, 0],
      [0, 1, 0],
      [0, 0, 0],
    ];
    _commands.clear();
    _isMoving = false;
    _isSuccess = null;
  }

  void _addCommand(String dir) {
    if (_commands.length < 8 && !_isMoving) {
      setState(() => _commands.add(dir));
    }
  }

  void _clearCommands() {
    if (!_isMoving) {
      setState(() {
        _commands.clear();
        _rabbitRow = widget.payload['startRow'] ?? 0;
        _rabbitCol = widget.payload['startCol'] ?? 0;
        _isSuccess = null;
      });
    }
  }

  Future<void> _runSimulation() async {
    if (_commands.isEmpty || _isMoving) return;

    setState(() {
      _isMoving = true;
      _rabbitRow = widget.payload['startRow'] ?? 0;
      _rabbitCol = widget.payload['startCol'] ?? 0;
      _isSuccess = null;
    });

    int curR = _rabbitRow;
    int curC = _rabbitCol;
    bool hitObstacle = false;

    for (final cmd in _commands) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      if (cmd == 'UP' && curR > 0) curR--;
      else if (cmd == 'DOWN' && curR < 2) curR++;
      else if (cmd == 'LEFT' && curC > 0) curC--;
      else if (cmd == 'RIGHT' && curC < 2) curC++;

      if (_grid[curR][curC] == 1) {
        hitObstacle = true;
        setState(() {
          _rabbitRow = curR;
          _rabbitCol = curC;
        });
        break;
      }

      setState(() {
        _rabbitRow = curR;
        _rabbitCol = curC;
      });
    }

    final reachedTarget = !hitObstacle && curR == _targetRow && curC == _targetCol;

    setState(() {
      _isMoving = false;
      _isSuccess = reachedTarget;
    });

    widget.onAnswer(reachedTarget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Grid Arena
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFF59E0B), width: 3),
          ),
          child: Column(
            children: List.generate(3, (r) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (c) {
                  final isRabbit = _rabbitRow == r && _rabbitCol == c;
                  final isTarget = _targetRow == r && _targetCol == c;
                  final isObstacle = _grid[r][c] == 1;

                  return Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isObstacle
                          ? const Color(0xFF94A3B8)
                          : isTarget
                              ? const Color(0xFFFED7AA)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isRabbit
                            ? const Color(0xFF10B981)
                            : isTarget
                                ? const Color(0xFFF97316)
                                : const Color(0xFFE2E8F0),
                        width: isRabbit ? 3 : 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isRabbit
                          ? '🐰'
                          : isTarget
                              ? '🥕'
                              : isObstacle
                                  ? '🪨'
                                  : '',
                      style: const TextStyle(fontSize: 34),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // Command Sequence Pipeline
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: _commands.isEmpty
              ? const Center(
                  child: Text(
                    'Adımları ekle: Tavşanı havuca ulaştır 🥕',
                    style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                  ),
                )
              : Wrap(
                  spacing: 6,
                  children: _commands.map((c) {
                    String icon = '➡️';
                    if (c == 'UP') icon = '⬆️';
                    if (c == 'DOWN') icon = '⬇️';
                    if (c == 'LEFT') icon = '⬅️';
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF10B981)),
                      ),
                      child: Text(icon, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 12),

        // Directional Control Pad
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildArrowButton('UP', '⬆️'),
            const SizedBox(width: 8),
            _buildArrowButton('DOWN', '⬇️'),
            const SizedBox(width: 8),
            _buildArrowButton('LEFT', '⬅️'),
            const SizedBox(width: 8),
            _buildArrowButton('RIGHT', '➡️'),
            const SizedBox(width: 12),
            IconButton(
              onPressed: _clearCommands,
              icon: const Icon(Icons.refresh, color: Color(0xFFEF4444)),
              tooltip: 'Temizle',
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_isSuccess != null) ...[
          Text(
            _isSuccess! ? '🎉 Nefis! Tavşan havuca ulaştı!' : '🤔 Engele çarptı veya hedefe ulaşamadı, tekrar dene!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _isSuccess! ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
            ),
          ),
          const SizedBox(height: 8),
        ],

        SizedBox(
          width: double.infinity,
          child: CustomChildButton(
            text: _isMoving ? 'Tavşan İlerliyor...' : 'Tavşanı Koştur 🚀',
            onPressed: _runSimulation,
            backgroundColor: const Color(0xFF10B981),
            shadowColor: const Color(0xFF059669),
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton(String dir, String label) {
    return ElevatedButton(
      onPressed: () => _addCommand(dir),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }
}
