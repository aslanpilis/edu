import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';

class CountingActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final Function(bool isCorrect) onAnswer;

  const CountingActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<CountingActivityWidget> createState() => _CountingActivityWidgetState();
}

class _CountingActivityWidgetState extends State<CountingActivityWidget> {
  int _collectedCount = 0;
  bool? _isSuccess;

  @override
  void initState() {
    super.initState();
    _collectedCount = 0;
    _isSuccess = null;
  }

  void _addItem() {
    final total = widget.payload['totalAvailable'] ?? 6;
    if (_collectedCount < total) {
      setState(() => _collectedCount++);
    }
  }

  void _removeItem() {
    if (_collectedCount > 0) {
      setState(() => _collectedCount--);
    }
  }

  void _checkResult() {
    final target = widget.payload['targetCount'] ?? 3;
    final isCorrect = _collectedCount == target;
    setState(() => _isSuccess = isCorrect);
    widget.onAnswer(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.payload['targetCount'] ?? 3;
    final emoji = widget.payload['itemEmoji'] ?? '🍎';
    final name = widget.payload['itemName'] ?? 'Elma';

    return Column(
      children: [
        // Target Goal Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF59E0B), width: 2),
          ),
          child: Text(
            'Sepete Tam $target Tane $name Koy 🎯',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF92400E),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Basket Container
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🧺 Sepet',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: List.generate(_collectedCount, (index) {
                    return InkWell(
                      onTap: _removeItem,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEDD5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF97316)),
                        ),
                        alignment: Alignment.center,
                        child: Text(emoji, style: const TextStyle(fontSize: 32)),
                      ),
                    );
                  }),
                ),
                if (_collectedCount == 0)
                  const Text(
                    'Sepet şu an boş. Aşağıdaki meyveye dokunarak ekle!',
                    style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 20),

                // Fruit tap spawner
                InkWell(
                  onTap: _addItem,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 8),
                        Text(
                          '+1 $name Ekle (Dokun)',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        if (_isSuccess != null) ...[
          Text(
            _isSuccess! ? '🎉 Harikasın! Tam $target adet koydun!' : '🤔 Tekrar sayalım mı? Dokunarak ekle veya çıkar.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _isSuccess! ? const Color(0xFF16A34A) : const Color(0xFFEA580C),
            ),
          ),
          const SizedBox(height: 12),
        ],

        SizedBox(
          width: double.infinity,
          child: CustomChildButton(
            text: 'Kontrol Et ⭐',
            onPressed: _checkResult,
            backgroundColor: const Color(0xFFF59E0B),
            shadowColor: const Color(0xFFD97706),
          ),
        ),
      ],
    );
  }
}
