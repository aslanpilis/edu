import 'package:flutter/material.dart';
import '../models/child_profile.dart';
import '../models/curriculum_models.dart';
import '../services/progress_service.dart';
import '../services/audio_service.dart';

class LearningProvider extends ChangeNotifier {
  final ProgressService _progressService = ProgressService();
  final AudioService _audioService = AudioService();

  Lesson? _activeLesson;
  int _currentActivityIndex = 0;
  DateTime? _sessionStartTime;
  int _correctAnswersCount = 0;
  bool _isFinished = false;
  LessonCompletionResult? _lastResult;

  Lesson? get activeLesson => _activeLesson;
  int get currentActivityIndex => _currentActivityIndex;
  Activity? get currentActivity =>
      _activeLesson != null && _currentActivityIndex < _activeLesson!.activities.length
          ? _activeLesson!.activities[_currentActivityIndex]
          : null;
  int get totalActivities => _activeLesson?.activities.length ?? 0;
  bool get isFinished => _isFinished;
  LessonCompletionResult? get lastResult => _lastResult;

  void startLesson(Lesson lesson) {
    _activeLesson = lesson;
    _currentActivityIndex = 0;
    _correctAnswersCount = 0;
    _sessionStartTime = DateTime.now();
    _isFinished = false;
    _lastResult = null;
    _audioService.playPop();
    notifyListeners();
  }

  void submitAnswer(bool isCorrect) {
    if (isCorrect) {
      _correctAnswersCount++;
      _audioService.playSuccess();
    } else {
      _audioService.playTryAgain();
    }
  }

  Future<void> nextActivity(ChildProfile child, Function(ChildProfile) onChildUpdated) async {
    if (_activeLesson == null) return;

    if (_currentActivityIndex + 1 < _activeLesson!.activities.length) {
      _currentActivityIndex++;
      _audioService.playPop();
      notifyListeners();
    } else {
      // Lesson Complete!
      final secondsSpent = _sessionStartTime != null
          ? DateTime.now().difference(_sessionStartTime!).inSeconds
          : 60;
      final scorePct = totalActivities > 0
          ? ((_correctAnswersCount / totalActivities) * 100).round()
          : 100;

      _lastResult = await _progressService.completeLesson(
        child: child,
        lesson: _activeLesson!,
        scorePercentage: scorePct,
        timeSpentSeconds: secondsSpent < 15 ? 15 : secondsSpent,
      );

      onChildUpdated(_lastResult!.updatedChild);
      _isFinished = true;
      _audioService.playStar();
      notifyListeners();
    }
  }

  void exitLesson() {
    _activeLesson = null;
    _currentActivityIndex = 0;
    _isFinished = false;
    _lastResult = null;
    notifyListeners();
  }
}
