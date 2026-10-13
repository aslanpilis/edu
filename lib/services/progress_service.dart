import '../models/child_profile.dart';
import '../models/curriculum_models.dart';
import '../models/progress_models.dart';
import 'firebase_service.dart';

class LessonCompletionResult {
  final ChildProgress progress;
  final ChildProfile updatedChild;
  final List<Achievement> newAchievements;
  final int xpEarned;
  final int starsEarned;

  LessonCompletionResult({
    required this.progress,
    required this.updatedChild,
    required this.newAchievements,
    required this.xpEarned,
    required this.starsEarned,
  });
}

class ProgressService {
  final FirebaseService _firebaseService = FirebaseService();

  Future<LessonCompletionResult> completeLesson({
    required ChildProfile child,
    required Lesson lesson,
    required int scorePercentage,
    required int timeSpentSeconds,
  }) async {
    final starsEarned = scorePercentage >= 90 ? 3 : scorePercentage >= 60 ? 2 : 1;
    final progressId = '${child.id}_${lesson.id}';

    final existingList = await _firebaseService.getChildProgress(child.id);
    final existing = existingList.where((p) => p.id == progressId).firstOrNull;

    final isFirstCompletion = existing == null || existing.status != 'completed';
    final xpBonus = isFirstCompletion ? lesson.xpReward : (lesson.xpReward * 0.4).round();

    final progress = ChildProgress(
      id: progressId,
      childId: child.id,
      lessonId: lesson.id,
      moduleId: lesson.moduleId,
      curriculumId: lesson.curriculumId,
      status: 'completed',
      scorePercentage: existing != null && existing.scorePercentage > scorePercentage
          ? existing.scorePercentage
          : scorePercentage,
      timeSpentSeconds: (existing?.timeSpentSeconds ?? 0) + timeSpentSeconds,
      attemptsCount: (existing?.attemptsCount ?? 0) + 1,
      starsEarned: existing != null && existing.starsEarned > starsEarned
          ? existing.starsEarned
          : starsEarned,
      completedAt: DateTime.now(),
      lastAttemptAt: DateTime.now(),
    );

    await _firebaseService.saveChildProgress(progress);

    // Screen time and streak update
    final today = DateTime.now().toIso8601String().split('T')[0];
    final minutesSpent = (timeSpentSeconds / 60).ceil();

    int usedToday = child.screenTimeLimits.usedMinutesToday;
    if (child.screenTimeLimits.lastDateUsed == today) {
      usedToday += minutesSpent;
    } else {
      usedToday = minutesSpent;
    }

    final updatedChild = child.copyWith(
      totalXp: child.totalXp + xpBonus,
      lastActiveAt: DateTime.now(),
      screenTimeLimits: child.screenTimeLimits.copyWith(
        usedMinutesToday: usedToday,
        lastDateUsed: today,
      ),
    );

    await _firebaseService.saveChild(updatedChild);

    // Badge unlocks
    final newAchievements = <Achievement>[];
    final existingBadges = await _firebaseService.getAchievements(child.id);

    if (!existingBadges.any((a) => a.badgeId == 'first_lesson')) {
      final ach = Achievement(
        id: '${child.id}_first_lesson',
        childId: child.id,
        badgeId: 'first_lesson',
        title: 'İlk Adım Kâşifi',
        description: 'İlk dersini başarıyla tamamladın!',
        icon: '🌟',
        category: 'explorer',
        unlockedAt: DateTime.now(),
      );
      await _firebaseService.saveAchievement(ach);
      newAchievements.add(ach);
    }

    if (lesson.curriculumId.contains('math') && starsEarned == 3) {
      if (!existingBadges.any((a) => a.badgeId == 'math_wizard')) {
        final ach = Achievement(
          id: '${child.id}_math_wizard',
          childId: child.id,
          badgeId: 'math_wizard',
          title: 'Sayılar Büyücüsü',
          description: 'Matematik dersinde 3 yıldız aldın!',
          icon: '🧮',
          category: 'math',
          unlockedAt: DateTime.now(),
        );
        await _firebaseService.saveAchievement(ach);
        newAchievements.add(ach);
      }
    }

    return LessonCompletionResult(
      progress: progress,
      updatedChild: updatedChild,
      newAchievements: newAchievements,
      xpEarned: xpBonus,
      starsEarned: starsEarned,
    );
  }

  Future<Map<String, dynamic>> getAnalytics(String childId) async {
    final progressList = await _firebaseService.getChildProgress(childId);
    final completed = progressList.where((p) => p.status == 'completed').toList();

    int totalSeconds = 0;
    int totalScore = 0;

    int mathCompleted = 0;
    int langCompleted = 0;
    int stemCompleted = 0;

    for (final p in completed) {
      totalSeconds += p.timeSpentSeconds;
      totalScore += p.scorePercentage;
      if (p.curriculumId.contains('math')) mathCompleted++;
      if (p.curriculumId.contains('lang')) langCompleted++;
      if (p.curriculumId.contains('stem') || p.curriculumId.contains('sci')) stemCompleted++;
    }

    final masteryAvg = completed.isNotEmpty ? (totalScore / completed.length).round() : 0;

    return {
      'completedCount': completed.length,
      'totalMinutesSpent': (totalSeconds / 60).round(),
      'masteryPercentage': masteryAvg,
      'mathProgress': {'completed': mathCompleted, 'total': 4},
      'langProgress': {'completed': langCompleted, 'total': 3},
      'stemProgress': {'completed': stemCompleted, 'total': 4},
      'recentList': completed.reversed.take(4).toList(),
    };
  }
}
