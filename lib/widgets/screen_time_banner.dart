import 'package:flutter/material.dart';
import '../models/child_profile.dart';

class ScreenTimeBanner extends StatelessWidget {
  final ScreenTimeLimits limits;

  const ScreenTimeBanner({super.key, required this.limits});

  @override
  Widget build(BuildContext context) {
    if (!limits.enabled) return const SizedBox.shrink();

    final remaining = limits.dailyMinutesLimit - limits.usedMinutesToday;
    final isLimitReached = remaining <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isLimitReached ? const Color(0xFFFEE2E2) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLimitReached ? const Color(0xFFFCA5A5) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        children: [
          Text(
            isLimitReached ? '🌙' : '⏱️',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isLimitReached
                ? 'Bugünkü öğrenme süresi doldu! Maskotumuz uykuya geçti 😴'
                : 'Bugünkü kalan süren: $remaining dakika (${limits.usedMinutesToday}/${limits.dailyMinutesLimit} dk)',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isLimitReached ? const Color(0xFF991B1B) : const Color(0xFF1E40AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
