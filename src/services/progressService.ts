import { ChildProfile } from '../types/auth';
import { Lesson } from '../types/curriculum';
import { ChildProgress, Achievement, DailyLog, ChildAnalyticsSummary } from '../types/progress';
import { SYSTEM_BADGES } from '../config/constants';
import { storageService } from './storageService';

export class ProgressService {
  // Tamamlanan Dersi Kaydet ve İlerlemeyi Güncelle
  public async recordLessonCompletion(
    child: ChildProfile,
    lesson: Lesson,
    scorePercentage: number,
    timeSpentSeconds: number
  ): Promise<{
    progress: ChildProgress;
    updatedChild: ChildProfile;
    newAchievements: Achievement[];
    xpEarned: number;
    starsEarned: number;
  }> {
    const starsEarned = scorePercentage >= 90 ? 3 : scorePercentage >= 60 ? 2 : 1;
    const progressId = `${child.id}_${lesson.id}`;

    const existingProgressList = await storageService.getChildProgress(child.id);
    const existing = existingProgressList.find((p) => p.id === progressId);

    const isFirstTime = !existing || existing.status !== 'completed';
    const xpBonus = isFirstTime ? lesson.xpReward : Math.floor(lesson.xpReward * 0.3);

    const progress: ChildProgress = {
      id: progressId,
      childId: child.id,
      lessonId: lesson.id,
      moduleId: lesson.moduleId,
      curriculumId: lesson.curriculumId,
      status: 'completed',
      scorePercentage: Math.max(existing?.scorePercentage || 0, scorePercentage),
      timeSpentSeconds: (existing?.timeSpentSeconds || 0) + timeSpentSeconds,
      attemptsCount: (existing?.attemptsCount || 0) + 1,
      starsEarned: Math.max(existing?.starsEarned || 0, starsEarned),
      completedAt: new Date().toISOString(),
      lastAttemptAt: new Date().toISOString(),
    };

    await storageService.saveProgress(progress);

    // Günlük streak ve süre güncellemesi
    const today = new Date().toISOString().split('T')[0];
    let newStreak = child.currentStreakDays;
    const lastActiveDate = child.lastActiveAt ? child.lastActiveAt.split('T')[0] : '';

    if (lastActiveDate !== today) {
      const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0];
      if (lastActiveDate === yesterday) {
        newStreak += 1;
      } else if (!lastActiveDate) {
        newStreak = 1;
      }
    }

    const minutesSpent = Math.max(1, Math.round(timeSpentSeconds / 60));
    const usedToday = (child.screenTimeLimits.lastDateUsed === today ? child.screenTimeLimits.usedMinutesToday : 0) + minutesSpent;

    const updatedChild: ChildProfile = {
      ...child,
      totalXp: child.totalXp + xpBonus,
      currentStreakDays: Math.max(1, newStreak),
      lastActiveAt: new Date().toISOString(),
      screenTimeLimits: {
        ...child.screenTimeLimits,
        usedMinutesToday: usedToday,
        lastDateUsed: today,
      },
    };

    await storageService.saveChild(updatedChild);

    // Günlük aktivite logu
    await storageService.recordDailyLog(child.id, minutesSpent, xpBonus, lesson.curriculumId);

    // Rozet Kontrolleri (Badge Unlock System)
    const newAchievements: Achievement[] = [];
    const currentAchievements = await storageService.getAchievements(child.id);

    // 1. İlk Ders Rozeti
    if (!currentAchievements.some((a) => a.badgeId === 'first_lesson')) {
      const b = SYSTEM_BADGES.find((b) => b.badgeId === 'first_lesson')!;
      const ach: Achievement = {
        id: `${child.id}_first_lesson`,
        childId: child.id,
        badgeId: b.badgeId,
        title: b.title,
        description: b.description,
        icon: b.icon,
        category: b.category,
        unlockedAt: new Date().toISOString(),
      };
      await storageService.saveAchievement(ach);
      newAchievements.push(ach);
    }

    // 2. 3 Günlük Seri Rozeti
    if (updatedChild.currentStreakDays >= 3 && !currentAchievements.some((a) => a.badgeId === 'streak_3')) {
      const b = SYSTEM_BADGES.find((b) => b.badgeId === 'streak_3')!;
      const ach: Achievement = {
        id: `${child.id}_streak_3`,
        childId: child.id,
        badgeId: b.badgeId,
        title: b.title,
        description: b.description,
        icon: b.icon,
        category: b.category,
        unlockedAt: new Date().toISOString(),
      };
      await storageService.saveAchievement(ach);
      newAchievements.push(ach);
    }

    // 3. Matematik 3 Yıldız Rozeti
    if (lesson.curriculumId.includes('math') && starsEarned === 3 && !currentAchievements.some((a) => a.badgeId === 'math_wizard')) {
      const b = SYSTEM_BADGES.find((b) => b.badgeId === 'math_wizard')!;
      const ach: Achievement = {
        id: `${child.id}_math_wizard`,
        childId: child.id,
        badgeId: b.badgeId,
        title: b.title,
        description: b.description,
        icon: b.icon,
        category: b.category,
        unlockedAt: new Date().toISOString(),
      };
      await storageService.saveAchievement(ach);
      newAchievements.push(ach);
    }

    // 4. STEM Kodlama Rozeti
    if (lesson.curriculumId.includes('stem') && !currentAchievements.some((a) => a.badgeId === 'coder_junior')) {
      const b = SYSTEM_BADGES.find((b) => b.badgeId === 'coder_junior')!;
      const ach: Achievement = {
        id: `${child.id}_coder_junior`,
        childId: child.id,
        badgeId: b.badgeId,
        title: b.title,
        description: b.description,
        icon: b.icon,
        category: b.category,
        unlockedAt: new Date().toISOString(),
      };
      await storageService.saveAchievement(ach);
      newAchievements.push(ach);
    }

    return {
      progress,
      updatedChild,
      newAchievements,
      xpEarned: xpBonus,
      starsEarned,
    };
  }

  // Ebeveyn Analitik Özeti Çıkarma
  public async getAnalyticsSummary(childId: string): Promise<ChildAnalyticsSummary> {
    const progressList = await storageService.getChildProgress(childId);
    const dailyLogs = await storageService.getDailyLogs(childId);

    const completed = progressList.filter((p) => p.status === 'completed');
    const totalTimeSpentSeconds = progressList.reduce((acc, curr) => acc + curr.timeSpentSeconds, 0);
    const totalTimeSpentMinutes = Math.round(totalTimeSpentSeconds / 60);

    const totalScore = completed.reduce((acc, curr) => acc + curr.scorePercentage, 0);
    const masteryPercentage = completed.length > 0 ? Math.round(totalScore / completed.length) : 0;

    // Kategori kırılımları
    const categoryBreakdown = {
      math: { completed: 0, total: 4, score: 0 },
      language: { completed: 0, total: 3, score: 0 },
      stem: { completed: 0, total: 4, score: 0 },
      sel: { completed: 0, total: 2, score: 0 },
      creativity: { completed: 0, total: 2, score: 0 },
    };

    completed.forEach((p) => {
      if (p.curriculumId.includes('math')) {
        categoryBreakdown.math.completed += 1;
        categoryBreakdown.math.score = Math.max(categoryBreakdown.math.score, p.scorePercentage);
      } else if (p.curriculumId.includes('lang')) {
        categoryBreakdown.language.completed += 1;
        categoryBreakdown.language.score = Math.max(categoryBreakdown.language.score, p.scorePercentage);
      } else if (p.curriculumId.includes('stem') || p.curriculumId.includes('sci')) {
        categoryBreakdown.stem.completed += 1;
        categoryBreakdown.stem.score = Math.max(categoryBreakdown.stem.score, p.scorePercentage);
      } else if (p.curriculumId.includes('sel')) {
        categoryBreakdown.sel.completed += 1;
        categoryBreakdown.sel.score = Math.max(categoryBreakdown.sel.score, p.scorePercentage);
      }
    });

    const recentActivities = completed
      .sort((a, b) => new Date(b.completedAt || 0).getTime() - new Date(a.completedAt || 0).getTime())
      .slice(0, 5)
      .map((p) => {
        const lesson = storageService.getLessonById(p.lessonId);
        return {
          lessonId: p.lessonId,
          lessonTitle: lesson?.title || 'Eğitim Dersi',
          moduleTitle: p.moduleId,
          starsEarned: p.starsEarned,
          scorePercentage: p.scorePercentage,
          completedAt: p.completedAt || new Date().toISOString(),
        };
      });

    const totalXp = dailyLogs.reduce((acc, l) => acc + l.xpEarned, 0);

    return {
      totalLessonsCompleted: completed.length,
      totalTimeSpentMinutes,
      totalXp,
      currentStreakDays: 1,
      masteryPercentage,
      categoryBreakdown,
      recentActivities,
    };
  }
}

export const progressService = new ProgressService();
