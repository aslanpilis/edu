import 'package:flutter/material.dart';
import '../models/progress_models.dart';
import '../services/progress_service.dart';
import '../services/firebase_service.dart';

class ParentProvider extends ChangeNotifier {
  final ProgressService _progressService = ProgressService();
  final FirebaseService _firebaseService = FirebaseService();

  Map<String, dynamic>? _analytics;
  List<Achievement> _achievements = [];
  bool _isLoading = false;

  Map<String, dynamic>? get analytics => _analytics;
  List<Achievement> get achievements => _achievements;
  bool get isLoading => _isLoading;

  Future<void> loadChildAnalytics(String childId) async {
    _isLoading = true;
    notifyListeners();

    _analytics = await _progressService.getAnalytics(childId);
    _achievements = await _firebaseService.getAchievements(childId);

    _isLoading = false;
    notifyListeners();
  }
}
