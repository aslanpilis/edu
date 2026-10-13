export type LessonStatus = 'not_started' | 'in_progress' | 'completed' | 'mastered';

export interface ChildProgress {
  id: string; // `${childId}_${lessonId}`
  childId: string;
  lessonId: string;
  moduleId: string;
  curriculumId: string;
  status: LessonStatus;
  scorePercentage: number; // 0 - 100
  timeSpentSeconds: number;
  attemptsCount: number;
  starsEarned: number; // 1, 2, or 3
  completedAt?: string;
  lastAttemptAt: string;
}

export interface Achievement {
  id: string; // `${childId}_${badgeId}`
  childId: string;
  badgeId: string;
  title: string;
  description: string;
  icon: string;
  category: 'streak' | 'math' | 'reading' | 'stem' | 'explorer' | 'mastery';
  unlockedAt: string;
}

export interface DailyLog {
  id: string; // `${childId}_${dateString}`
  childId: string;
  date: string; // YYYY-MM-DD
  minutesSpent: number;
  lessonsCompleted: number;
  xpEarned: number;
  skillsExercised: string[];
}

export interface ChildAnalyticsSummary {
  totalLessonsCompleted: number;
  totalTimeSpentMinutes: number;
  totalXp: number;
  currentStreakDays: number;
  masteryPercentage: number;
  categoryBreakdown: {
    math: { completed: number; total: number; score: number };
    language: { completed: number; total: number; score: number };
    stem: { completed: number; total: number; score: number };
    sel: { completed: number; total: number; score: number };
    creativity: { completed: number; total: number; score: number };
  };
  recentActivities: {
    lessonId: string;
    lessonTitle: string;
    moduleTitle: string;
    starsEarned: number;
    scorePercentage: number;
    completedAt: string;
  }[];
}
