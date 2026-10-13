import 'package:flutter/material.dart';
import 'child_profile.dart';

enum SubjectCategory {
  math,
  language,
  stem,
  sel,
  creativity,
}

extension SubjectCategoryExtension on SubjectCategory {
  String get code {
    switch (this) {
      case SubjectCategory.math:
        return 'math';
      case SubjectCategory.language:
        return 'language';
      case SubjectCategory.stem:
        return 'stem';
      case SubjectCategory.sel:
        return 'sel';
      case SubjectCategory.creativity:
        return 'creativity';
    }
  }

  String get displayName {
    switch (this) {
      case SubjectCategory.math:
        return 'Matematik & Mantık';
      case SubjectCategory.language:
        return 'Dil & Okuma';
      case SubjectCategory.stem:
        return 'STEM & Kodlama';
      case SubjectCategory.sel:
        return 'Duygular & Yaşam';
      case SubjectCategory.creativity:
        return 'Sanat & Müzik';
    }
  }
}

enum ActivityType {
  countingDragDrop,
  letterPhonicsMatch,
  logicPattern,
  codeSequence,
  scienceQuiz,
  // 4-6 Yaş ve İleri Yaş Mini Oyunlar:
  memoryMatch,
  mazePath,
  shadowMatch,
  simonSequence,
  balanceScale,
  oddOneOut,
  rhythmRepeat,
  habitatSort,
  sizeOrder,
  colorMix,
  // Yeni Zorlayıcı Oyunlar:
  mathChallenge,
  tangramPuzzle,
  matrixLogic,
  spotDifference,
}

class Activity {
  final String id;
  final String lessonId;
  final String title;
  final String instruction;
  final String? voiceInstruction;
  final ActivityType type;
  final int order;
  final Map<String, dynamic> payload;

  Activity({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.instruction,
    this.voiceInstruction,
    required this.type,
    required this.order,
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'title': title,
      'instruction': instruction,
      'voiceInstruction': voiceInstruction,
      'type': type.name,
      'order': order,
      'payload': payload,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    ActivityType parseType(String? val) {
      switch (val) {
        case 'counting_drag_drop':
        case 'countingDragDrop':
          return ActivityType.countingDragDrop;
        case 'letter_phonics_match':
        case 'letterPhonicsMatch':
          return ActivityType.letterPhonicsMatch;
        case 'logic_pattern':
        case 'logicPattern':
          return ActivityType.logicPattern;
        case 'code_sequence':
        case 'codeSequence':
          return ActivityType.codeSequence;
        case 'memory_match':
        case 'memoryMatch':
          return ActivityType.memoryMatch;
        case 'maze_path':
        case 'mazePath':
          return ActivityType.mazePath;
        case 'shadow_match':
        case 'shadowMatch':
          return ActivityType.shadowMatch;
        case 'simon_sequence':
        case 'simonSequence':
          return ActivityType.simonSequence;
        case 'balance_scale':
        case 'balanceScale':
          return ActivityType.balanceScale;
        case 'odd_one_out':
        case 'oddOneOut':
          return ActivityType.oddOneOut;
        case 'rhythm_repeat':
        case 'rhythmRepeat':
          return ActivityType.rhythmRepeat;
        case 'habitat_sort':
        case 'habitatSort':
          return ActivityType.habitatSort;
        case 'size_order':
        case 'sizeOrder':
          return ActivityType.sizeOrder;
        case 'color_mix':
        case 'colorMix':
          return ActivityType.colorMix;
        case 'math_challenge':
        case 'mathChallenge':
          return ActivityType.mathChallenge;
        case 'tangram_puzzle':
        case 'tangramPuzzle':
          return ActivityType.tangramPuzzle;
        case 'matrix_logic':
        case 'matrixLogic':
          return ActivityType.matrixLogic;
        case 'spot_difference':
        case 'spotDifference':
          return ActivityType.spotDifference;
        case 'science_quiz':
        case 'scienceQuiz':
        default:
          return ActivityType.scienceQuiz;
      }
    }

    return Activity(
      id: map['id'] ?? '',
      lessonId: map['lessonId'] ?? '',
      title: map['title'] ?? '',
      instruction: map['instruction'] ?? '',
      voiceInstruction: map['voiceInstruction'],
      type: parseType(map['type']),
      order: map['order'] ?? 1,
      payload: Map<String, dynamic>.from(map['payload'] ?? {}),
    );
  }
}

class Lesson {
  final String id;
  final String moduleId;
  final String curriculumId;
  final String title;
  final String description;
  final int estimatedDurationMinutes;
  final int xpReward;
  final int order;
  final String difficultyLevel; // beginner | intermediate | advanced
  final List<Activity> activities;

  Lesson({
    required this.id,
    required this.moduleId,
    required this.curriculumId,
    required this.title,
    required this.description,
    this.estimatedDurationMinutes = 5,
    this.xpReward = 40,
    required this.order,
    this.difficultyLevel = 'beginner',
    required this.activities,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moduleId': moduleId,
      'curriculumId': curriculumId,
      'title': title,
      'description': description,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'xpReward': xpReward,
      'order': order,
      'difficultyLevel': difficultyLevel,
      'activities': activities.map((a) => a.toMap()).toList(),
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] ?? '',
      moduleId: map['moduleId'] ?? '',
      curriculumId: map['curriculumId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      estimatedDurationMinutes: map['estimatedDurationMinutes'] ?? 5,
      xpReward: map['xpReward'] ?? 40,
      order: map['order'] ?? 1,
      difficultyLevel: map['difficultyLevel'] ?? 'beginner',
      activities: (map['activities'] as List<dynamic>? ?? [])
          .map((item) => Activity.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}

class Module {
  final String id;
  final String curriculumId;
  final String title;
  final String description;
  final String icon;
  final String colorHex;
  final int order;

  Module({
    required this.id,
    required this.curriculumId,
    required this.title,
    required this.description,
    required this.icon,
    required this.colorHex,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'curriculumId': curriculumId,
      'title': title,
      'description': description,
      'icon': icon,
      'colorHex': colorHex,
      'order': order,
    };
  }

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
      id: map['id'] ?? '',
      curriculumId: map['curriculumId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '📚',
      colorHex: map['colorHex'] ?? '#3B82F6',
      order: map['order'] ?? 1,
    );
  }
}

class Curriculum {
  final String id;
  final String title;
  final String description;
  final AgeGroup targetAgeGroup;
  final SubjectCategory category;
  final String icon;
  final String gradientCode;
  final int order;
  final bool isPublished;

  Curriculum({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAgeGroup,
    required this.category,
    required this.icon,
    required this.gradientCode,
    required this.order,
    this.isPublished = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAgeGroup': targetAgeGroup.code,
      'category': category.code,
      'icon': icon,
      'gradientCode': gradientCode,
      'order': order,
      'isPublished': isPublished,
    };
  }
}

class GameItem {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String categoryId; // 'all', 'math', 'visual', 'memory', 'logic', 'science'
  final String categoryName;
  final Color primaryColor;
  final List<Color> gradientColors;
  final int maxLevels;
  final Lesson lesson;
  final Module module;

  GameItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.categoryId,
    required this.categoryName,
    required this.primaryColor,
    required this.gradientColors,
    this.maxLevels = 3,
    required this.lesson,
    required this.module,
  });
}
