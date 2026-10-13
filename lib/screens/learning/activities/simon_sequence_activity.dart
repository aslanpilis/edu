import 'package:flutter/material.dart';

class SimonSequenceActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const SimonSequenceActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<SimonSequenceActivityWidget> createState() => _SimonSequenceActivityWidgetState();
}

class _SimonSequenceActivityWidgetState extends State<SimonSequenceActivityWidget> {
  final List<String> _colors = ['🔴 Kırmızı', '🔵 Mavi', '🟡 Sarı', '🟢 Yeşil'];
  final List<Color> _colorValues = [
    const Color(0xFFEF4444),
    const Color(0xFF3B82F6),
    const Color(0xFFF59E0B),
    const Color(0xFF10B981),
  ];

  late List<int> _targetSequence;
  final List<int> _userSequence = [];
  bool _isPlayingSequence = false;
  int? _activeHighlightIndex;
  bool? _isSuccess;

  @override
  void initState() {
    super.initState();
    final rawSeq = widget.payload['sequence'] as List<dynamic>? ?? [0, 2, 1];
    _targetSequence = rawSeq.map((e) => e as int).toList();
    _playDemoSequence();
  }

  Future<void> _playDemoSequence() async {
    setState(() {
      _isPlayingSequence = true;
      _userSequence.clear();
      _isSuccess = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    for (final idx in _targetSequence) {
      if (!mounted) return;
      setState(() => _activeHighlightIndex = idx);
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() => _activeHighlightIndex = null);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (mounted) {
      setState(() => _isPlayingSequence = false);
    }
  }

  void _onColorTap(int index) {
    if (_isPlayingSequence || _userSequence.length >= _targetSequence.length) return;

    setState(() {
      _userSequence.add(index);
    });

    if (_userSequence.length == _targetSequence.length) {
      bool isCorrect = true;
      for (int i = 0; i < _targetSequence.length; i++) {
        if (_userSequence[i] != _targetSequence[i]) {
          isCorrect = false;
          break;
        }
      }

      setState(() => _isSuccess = isCorrect);
      widget.onAnswer(isCorrect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sequence Demo Button & Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF59E0B)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isPlayingSequence ? '👀 Işıkları Dikkatle İzle!' : 'Sırayla Dokun! (${_userSequence.length}/${_targetSequence.length})',
                style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF92400E), fontSize: 14),
              ),
              IconButton(
                onPressed: _isPlayingSequence ? null : _playDemoSequence,
                icon: const Icon(Icons.replay, color: Color(0xFFD97706)),
                tooltip: 'Sırayı Tekrar Göster',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Simon 2x2 Big Buttons
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(4, (idx) {
              final isHighlighted = _activeHighlightIndex == idx;
              final color = _colorValues[idx];

              return InkWell(
                onTap: () => _onColorTap(idx),
                borderRadius: BorderRadius.circular(32),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isHighlighted ? Colors.white : color,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: isHighlighted ? color : Colors.white,
                      width: isHighlighted ? 6 : 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: isHighlighted ? 0.6 : 0.3),
                        blurRadius: isHighlighted ? 20 : 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isHighlighted ? '✨' : _colors[idx].split(' ').first,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              );
            }),
          ),
        ),

        if (_isSuccess != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isSuccess! ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _isSuccess! ? '🎉 Müthiş Hafıza! Sıralamayı tam hatırladın!' : '🤔 Yanlış renk, tekrar izlemek için 🔄 butonuna bas!',
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
