class ChildProgress {
  final String id; // '${childId}_${lessonId}'
  final String childId;
  final String lessonId;
  final String moduleId;
  final String curriculumId;
  final String status; // not_started | in_progress | completed | mastered
  final int scorePercentage;
  final int timeSpentSeconds;
  final int attemptsCount;
  final int starsEarned; // 1, 2, or 3
  final DateTime? completedAt;
  final DateTime lastAttemptAt;

  ChildProgress({
    required this.id,
    required this.childId,
    required this.lessonId,
    required this.moduleId,
    required this.curriculumId,
    this.status = 'completed',
    this.scorePercentage = 100,
    this.timeSpentSeconds = 60,
    this.attemptsCount = 1,
    this.starsEarned = 3,
    this.completedAt,
    required this.lastAttemptAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'lessonId': lessonId,
      'moduleId': moduleId,
      'curriculumId': curriculumId,
      'status': status,
      'scorePercentage': scorePercentage,
      'timeSpentSeconds': timeSpentSeconds,
      'attemptsCount': attemptsCount,
      'starsEarned': starsEarned,
      'completedAt': completedAt?.toIso8601String(),
      'lastAttemptAt': lastAttemptAt.toIso8601String(),
    };
  }

  factory ChildProgress.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ChildProgress(
      id: docId ?? map['id'] ?? '',
      childId: map['childId'] ?? '',
      lessonId: map['lessonId'] ?? '',
      moduleId: map['moduleId'] ?? '',
      curriculumId: map['curriculumId'] ?? '',
      status: map['status'] ?? 'completed',
      scorePercentage: map['scorePercentage'] ?? 100,
      timeSpentSeconds: map['timeSpentSeconds'] ?? 60,
      attemptsCount: map['attemptsCount'] ?? 1,
      starsEarned: map['starsEarned'] ?? 3,
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'])
          : null,
      lastAttemptAt: map['lastAttemptAt'] != null
          ? DateTime.tryParse(map['lastAttemptAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class Achievement {
  final String id;
  final String childId;
  final String badgeId;
  final String title;
  final String description;
  final String icon;
  final String category;
  final DateTime unlockedAt;

  Achievement({
    required this.id,
    required this.childId,
    required this.badgeId,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.unlockedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'badgeId': badgeId,
      'title': title,
      'description': description,
      'icon': icon,
      'category': category,
      'unlockedAt': unlockedAt.toIso8601String(),
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Achievement(
      id: docId ?? map['id'] ?? '',
      childId: map['childId'] ?? '',
      badgeId: map['badgeId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '🏆',
      category: map['category'] ?? 'explorer',
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.tryParse(map['unlockedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class DailyLog {
  final String id;
  final String childId;
  final String date; // YYYY-MM-DD
  final int minutesSpent;
  final int lessonsCompleted;
  final int xpEarned;
  final List<String> skillsExercised;

  DailyLog({
    required this.id,
    required this.childId,
    required this.date,
    required this.minutesSpent,
    required this.lessonsCompleted,
    required this.xpEarned,
    required this.skillsExercised,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'date': date,
      'minutesSpent': minutesSpent,
      'lessonsCompleted': lessonsCompleted,
      'xpEarned': xpEarned,
      'skillsExercised': skillsExercised,
    };
  }

  factory DailyLog.fromMap(Map<String, dynamic> map, {String? docId}) {
    return DailyLog(
      id: docId ?? map['id'] ?? '',
      childId: map['childId'] ?? '',
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      minutesSpent: map['minutesSpent'] ?? 0,
      lessonsCompleted: map['lessonsCompleted'] ?? 0,
      xpEarned: map['xpEarned'] ?? 0,
      skillsExercised: List<String>.from(map['skillsExercised'] ?? []),
    );
  }
}
