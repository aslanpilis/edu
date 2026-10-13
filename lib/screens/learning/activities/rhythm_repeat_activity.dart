import 'package:flutter/material.dart';

class RhythmRepeatActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const RhythmRepeatActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<RhythmRepeatActivityWidget> createState() => _RhythmRepeatActivityWidgetState();
}

class _RhythmRepeatActivityWidgetState extends State<RhythmRepeatActivityWidget> {
  final List<Map<String, String>> _instruments = [
    {'emoji': '🥁', 'name': 'Davul'},
    {'emoji': '🎹', 'name': 'Piyano'},
    {'emoji': '🎸', 'name': 'Gitar'},
  ];

  late List<int> _targetRhythm;
  final List<int> _userRhythm = [];
  bool _isPlaying = false;
  int? _activeHighlight;
  bool? _isSuccess;

  @override
  void initState() {
    super.initState();
    final rawSeq = widget.payload['rhythm'] as List<dynamic>? ?? [0, 1, 0, 2];
    _targetRhythm = rawSeq.map((e) => e as int).toList();
    _playDemo();
  }

  Future<void> _playDemo() async {
    setState(() {
      _isPlaying = true;
      _userRhythm.clear();
      _isSuccess = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    for (final idx in _targetRhythm) {
      if (!mounted) return;
      setState(() => _activeHighlight = idx);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() => _activeHighlight = null);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  void _onTap(int index) {
    if (_isPlaying || _userRhythm.length >= _targetRhythm.length) return;

    setState(() {
      _userRhythm.add(index);
    });

    if (_userRhythm.length == _targetRhythm.length) {
      bool isCorrect = true;
      for (int i = 0; i < _targetRhythm.length; i++) {
        if (_userRhythm[i] != _targetRhythm[i]) {
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
        // Ritim Bilgilendirme
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF2F8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF472B6)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isPlaying ? '🎵 Ritmi Dinle ve İzle!' : 'Şimdi Sen Çal! (${_userRhythm.length}/${_targetRhythm.length})',
                style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF9D174D), fontSize: 14),
              ),
              IconButton(
                onPressed: _isPlaying ? null : _playDemo,
                icon: const Icon(Icons.replay, color: Color(0xFFDB2777)),
                tooltip: 'Ritmi Tekrar Çal',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 3 Instrument Cards Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (idx) {
            final isHighlighted = _activeHighlight == idx;
            final inst = _instruments[idx];

            return InkWell(
              onTap: () => _onTap(idx),
              borderRadius: BorderRadius.circular(28),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 95,
                height: 120,
                decoration: BoxDecoration(
                  color: isHighlighted ? const Color(0xFFFCE7F3) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isHighlighted ? const Color(0xFFEC4899) : const Color(0xFFE2E8F0),
                    width: isHighlighted ? 4 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: isHighlighted ? 16 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(inst['emoji']!, style: const TextStyle(fontSize: 42)),
                    const SizedBox(height: 8),
                    Text(
                      inst['name']!,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        if (_isSuccess != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isSuccess! ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _isSuccess! ? '🎉 Harika Müzisyen! Ritmi kusursuz çaldın!' : '🤔 Ritim sırasını kaçırdın, 🔄 ile tekrar dinleyelim!',
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
