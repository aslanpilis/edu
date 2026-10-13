import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/curriculum_models.dart';
import '../providers/learning_provider.dart';
import '../screens/learning/lesson_player_screen.dart';

class LevelSelectDialog extends StatelessWidget {
  final Lesson lesson;
  final Module module;
  final String categoryName;
  final int maxLevels;

  const LevelSelectDialog({
    super.key,
    required this.lesson,
    required this.module,
    required this.categoryName,
    this.maxLevels = 3,
  });

  static void show(BuildContext context, {
    required Lesson lesson,
    required Module module,
    required String categoryName,
    int maxLevels = 3,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LevelSelectDialog(
        lesson: lesson,
        module: module,
        categoryName: categoryName,
        maxLevels: maxLevels,
      ),
    );
  }

  void _startLevel(BuildContext context, int level) {
    final navigator = Navigator.of(context);
    final learning = context.read<LearningProvider>();
    navigator.pop();

    // Lesson aktivitelerinin payload'ına level parametresini enjekte edip başlatıyoruz
    final updatedActivities = lesson.activities.map((act) {
      final updatedPayload = Map<String, dynamic>.from(act.payload);
      updatedPayload['level'] = level;
      return Activity(
        id: '${act.id}_lvl$level',
        lessonId: act.lessonId,
        title: '${act.title} (Seviye $level)',
        instruction: act.instruction,
        voiceInstruction: act.voiceInstruction,
        type: act.type,
        order: act.order,
        payload: updatedPayload,
      );
    }).toList();

    final updatedLesson = Lesson(
      id: '${lesson.id}_lvl$level',
      moduleId: lesson.moduleId,
      curriculumId: lesson.curriculumId,
      title: '${lesson.title} • Seviye $level',
      description: lesson.description,
      xpReward: 30 + (level * 20),
      order: lesson.order,
      difficultyLevel: level == 1 ? 'beginner' : level == 2 ? 'intermediate' : 'advanced',
      activities: updatedActivities,
    );

    learning.startLesson(updatedLesson);
    navigator.push(
      MaterialPageRoute(builder: (_) => const LessonPlayerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levelsInfo = [
      {'level': 1, 'title': 'Seviye 1: Kolay', 'emoji': '🌱', 'color': const Color(0xFF10B981), 'xp': 50, 'desc': 'Temel kavramları keşfet ve ısın!'},
      {'level': 2, 'title': 'Seviye 2: Orta', 'emoji': '⭐', 'color': const Color(0xFFF59E0B), 'xp': 70, 'desc': 'Biraz daha dikkat ve hız gerektirir!'},
      {'level': 3, 'title': 'Seviye 3: Zor', 'emoji': '🔥', 'color': const Color(0xFFEF4444), 'xp': 90, 'desc': 'Zorlu görev! Gerçek bir zeka kurgusu.'},
      if (maxLevels >= 4)
        {'level': 4, 'title': 'Seviye 4: Usta', 'emoji': '👑', 'color': const Color(0xFF8B5CF6), 'xp': 120, 'desc': 'Şampiyonlar için en zorlu aşama!'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Game Header
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(module.icon, style: const TextStyle(fontSize: 32)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        categoryName.toUpperCase(),
                        style: const TextStyle(color: Color(0xFF4F46E5), fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Seviye Seç ve Başla! 🚀',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 12),

          // Levels list
          ...levelsInfo.map((lvl) {
            final levelNum = lvl['level'] as int;
            final title = lvl['title'] as String;
            final emoji = lvl['emoji'] as String;
            final color = lvl['color'] as Color;
            final xp = lvl['xp'] as int;
            final desc = lvl['desc'] as String;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _startLevel(context, levelNum),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(emoji, style: const TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                desc,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+$xp XP',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
