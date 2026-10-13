enum AgeGroup {
  age3To5,
  age6To8,
  age9To12,
}

extension AgeGroupExtension on AgeGroup {
  String get code {
    switch (this) {
      case AgeGroup.age3To5:
        return '3-5';
      case AgeGroup.age6To8:
        return '6-8';
      case AgeGroup.age9To12:
        return '9-12';
    }
  }

  static AgeGroup fromCode(String code) {
    switch (code) {
      case '3-5':
        return AgeGroup.age3To5;
      case '6-8':
        return AgeGroup.age6To8;
      case '9-12':
      default:
        return AgeGroup.age9To12;
    }
  }

  static AgeGroup fromAge(int age) {
    if (age <= 5) return AgeGroup.age3To5;
    if (age <= 8) return AgeGroup.age6To8;
    return AgeGroup.age9To12;
  }
}

class ScreenTimeLimits {
  final bool enabled;
  final int dailyMinutesLimit;
  final int usedMinutesToday;
  final String lastDateUsed;

  ScreenTimeLimits({
    this.enabled = true,
    this.dailyMinutesLimit = 30,
    this.usedMinutesToday = 0,
    required this.lastDateUsed,
  });

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'dailyMinutesLimit': dailyMinutesLimit,
      'usedMinutesToday': usedMinutesToday,
      'lastDateUsed': lastDateUsed,
    };
  }

  factory ScreenTimeLimits.fromMap(Map<String, dynamic> map) {
    return ScreenTimeLimits(
      enabled: map['enabled'] ?? true,
      dailyMinutesLimit: map['dailyMinutesLimit'] ?? 30,
      usedMinutesToday: map['usedMinutesToday'] ?? 0,
      lastDateUsed: map['lastDateUsed'] ?? DateTime.now().toIso8601String().split('T')[0],
    );
  }

  ScreenTimeLimits copyWith({
    bool? enabled,
    int? dailyMinutesLimit,
    int? usedMinutesToday,
    String? lastDateUsed,
  }) {
    return ScreenTimeLimits(
      enabled: enabled ?? this.enabled,
      dailyMinutesLimit: dailyMinutesLimit ?? this.dailyMinutesLimit,
      usedMinutesToday: usedMinutesToday ?? this.usedMinutesToday,
      lastDateUsed: lastDateUsed ?? this.lastDateUsed,
    );
  }
}

class ChildProfile {
  final String id;
  final String parentId;
  final String nickname;
  final String avatarUrl; // Emoji or asset path
  final int age;
  final AgeGroup ageGroup;
  final int totalXp;
  final int currentStreakDays;
  final DateTime lastActiveAt;
  final DateTime createdAt;
  final Map<String, dynamic> preferences;
  final ScreenTimeLimits screenTimeLimits;

  ChildProfile({
    required this.id,
    required this.parentId,
    required this.nickname,
    required this.avatarUrl,
    required this.age,
    required this.ageGroup,
    this.totalXp = 0,
    this.currentStreakDays = 1,
    required this.lastActiveAt,
    required this.createdAt,
    this.preferences = const {
      'soundEffects': true,
      'voiceOver': true,
      'theme': 'playful',
    },
    required this.screenTimeLimits,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentId': parentId,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
      'age': age,
      'ageGroup': ageGroup.code,
      'totalXp': totalXp,
      'currentStreakDays': currentStreakDays,
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'preferences': preferences,
      'screenTimeLimits': screenTimeLimits.toMap(),
    };
  }

  factory ChildProfile.fromMap(Map<String, dynamic> map, {String? docId}) {
    final ageVal = map['age'] ?? 4;
    return ChildProfile(
      id: docId ?? map['id'] ?? 'child_${DateTime.now().millisecondsSinceEpoch}',
      parentId: map['parentId'] ?? '',
      nickname: map['nickname'] ?? 'Kâşif',
      avatarUrl: map['avatarUrl'] ?? '🦊',
      age: ageVal,
      ageGroup: map['ageGroup'] != null
          ? AgeGroupExtension.fromCode(map['ageGroup'])
          : AgeGroupExtension.fromAge(ageVal),
      totalXp: map['totalXp'] ?? 0,
      currentStreakDays: map['currentStreakDays'] ?? 1,
      lastActiveAt: map['lastActiveAt'] != null
          ? DateTime.tryParse(map['lastActiveAt']) ?? DateTime.now()
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      screenTimeLimits: map['screenTimeLimits'] != null
          ? ScreenTimeLimits.fromMap(Map<String, dynamic>.from(map['screenTimeLimits']))
          : ScreenTimeLimits(lastDateUsed: DateTime.now().toIso8601String().split('T')[0]),
    );
  }

  ChildProfile copyWith({
    String? nickname,
    String? avatarUrl,
    int? age,
    AgeGroup? ageGroup,
    int? totalXp,
    int? currentStreakDays,
    DateTime? lastActiveAt,
    Map<String, dynamic>? preferences,
    ScreenTimeLimits? screenTimeLimits,
  }) {
    return ChildProfile(
      id: id,
      parentId: parentId,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      ageGroup: ageGroup ?? this.ageGroup,
      totalXp: totalXp ?? this.totalXp,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt,
      preferences: preferences ?? this.preferences,
      screenTimeLimits: screenTimeLimits ?? this.screenTimeLimits,
    );
  }
}
