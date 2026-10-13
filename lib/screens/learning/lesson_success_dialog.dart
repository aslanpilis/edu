import 'package:flutter/material.dart';
import '../../services/progress_service.dart';
import '../../widgets/custom_button.dart';

class LessonSuccessDialog extends StatelessWidget {
  final LessonCompletionResult result;
  final VoidCallback onContinue;

  const LessonSuccessDialog({
    super.key,
    required this.result,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: const Color(0xFFFDE68A), width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stars Animation Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (idx) {
                final isFilled = idx < result.starsEarned;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    isFilled ? '⭐' : '⚪',
                    style: TextStyle(fontSize: idx == 1 ? 52 : 40),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            const Text(
              'Tebrikler Kâşif! 🎉',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Bu görevi başarıyla tamamladın!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),

            // XP and Duration Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text('Kazanılan XP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF92400E))),
                        const SizedBox(height: 4),
                        Text(
                          '+${result.xpEarned} XP',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFD97706)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text('Başarı Skoru', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF065F46))),
                        const SizedBox(height: 4),
                        Text(
                          '%${result.progress.scorePercentage}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: CustomChildButton(
                text: 'Devam Et 🚀',
                onPressed: onContinue,
                backgroundColor: const Color(0xFF10B981),
                shadowColor: const Color(0xFF059669),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
