import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';

class RobotCodeActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const RobotCodeActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<RobotCodeActivityWidget> createState() => _RobotCodeActivityWidgetState();
}

class _RobotCodeActivityWidgetState extends State<RobotCodeActivityWidget> {
  final List<String> _userSequence = [];
  bool? _isSuccess;

  void _addBlock(String id) {
    setState(() => _userSequence.add(id));
  }

  void _removeBlock(int index) {
    setState(() => _userSequence.removeAt(index));
  }

  void _runCode() {
    final required = (widget.payload['requiredSequence'] as List<dynamic>? ?? ['FORWARD', 'JUMP', 'FORWARD'])
        .map((e) => e.toString())
        .toList();

    bool isCorrect = _userSequence.length == required.length;
    if (isCorrect) {
      for (int i = 0; i < required.length; i++) {
        if (_userSequence[i] != required[i]) {
          isCorrect = false;
          break;
        }
      }
    }

    setState(() => _isSuccess = isCorrect);
    widget.onAnswer(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    final availableBlocks = (widget.payload['availableBlocks'] as List<dynamic>? ?? [
      {'id': 'FORWARD', 'label': 'İleri Git ➡️'},
      {'id': 'JUMP', 'label': 'Zıpla 🦘'},
      {'id': 'TURN_LEFT', 'label': 'Dön 🔄'},
    ]).map((e) => Map<String, dynamic>.from(e)).toList();

    return Column(
      children: [
        // Simulation Arena
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🤖 Kodlama Arenası', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  Text('Hedef: ⭐ Yıldız', style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('🤖', style: TextStyle(fontSize: 32)),
                  const Text('➡️', style: TextStyle(fontSize: 20, color: Colors.white54)),
                  const Text('🪨', style: TextStyle(fontSize: 28)),
                  const Text('➡️', style: TextStyle(fontSize: 20, color: Colors.white54)),
                  const Text('⭐', style: TextStyle(fontSize: 34)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // User Code Sequence Pipeline
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
          ),
          child: _userSequence.isEmpty
              ? const Center(
                  child: Text(
                    'Aşağıdaki bloklara dokunarak kodunu oluştur!',
                    style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_userSequence.length, (idx) {
                    final blockId = _userSequence[idx];
                    return InkWell(
                      onTap: () => _removeBlock(idx),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF6366F1)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              blockId == 'FORWARD'
                                  ? '➡️ İleri'
                                  : blockId == 'JUMP'
                                      ? '🦘 Zıpla'
                                      : blockId == 'REPEAT_4_FORWARD'
                                          ? '🔁 4x İleri'
                                          : blockId,
                              style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4338CA)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.close, size: 14, color: Color(0xFF4338CA)),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
        ),
        const SizedBox(height: 16),

        // Available Blocks
        Wrap(
          spacing: 10,
          children: availableBlocks.map((b) {
            return ElevatedButton(
              onPressed: () => _addBlock(b['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F5F9),
                foregroundColor: const Color(0xFF1E293B),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('+ ${b['label']}', style: const TextStyle(fontWeight: FontWeight.w700)),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        if (_isSuccess != null) ...[
          Text(
            _isSuccess! ? '🚀 Harika algoritma! Robot hedefe ulaştı!' : '⚠️ Robot engele takıldı, blok sırasını kontrol et!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _isSuccess! ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 12),
        ],

        SizedBox(
          width: double.infinity,
          child: CustomChildButton(
            text: 'Kodu Çalıştır ▶️',
            onPressed: _runCode,
            backgroundColor: const Color(0xFF6366F1),
            shadowColor: const Color(0xFF4F46E5),
          ),
        ),
      ],
    );
  }
}
