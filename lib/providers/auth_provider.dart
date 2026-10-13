import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/parent_user.dart';
import '../models/child_profile.dart';
import '../services/firebase_service.dart';
import '../services/audio_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final AudioService _audioService = AudioService();

  ParentUser? _currentUser;
  ChildProfile? _activeChild;
  List<ChildProfile> _children = [];
  bool _isLoading = true;

  ParentUser? get currentUser => _currentUser;
  ChildProfile? get activeChild => _activeChild;
  List<ChildProfile> get children => _children;
  bool get isLoading => _isLoading;
  bool get isFirebaseLive => _firebaseService.isFirebaseLive;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _firebaseService.initialize();
    _currentUser = await _firebaseService.getSavedUser();

    if (_currentUser == null) {
      // Auto-login with initial demo user for friction-free testing
      _currentUser = await _firebaseService.signIn('veli@egitim.com', 'demo123');
    }

    if (_currentUser != null) {
      _children = await _firebaseService.getChildren(_currentUser!.uid);
      final prefs = await SharedPreferences.getInstance();
      final savedChildId = prefs.getString('edu_active_child_id');

      if (savedChildId != null) {
        _activeChild = _children.where((c) => c.id == savedChildId).firstOrNull;
      }
      _activeChild ??= _children.isNotEmpty ? _children.first : null;

      if (_activeChild != null) {
        _audioService.setSoundEnabled(_activeChild!.preferences['soundEffects'] ?? true);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _firebaseService.signIn(email, password);
      _children = await _firebaseService.getChildren(_currentUser!.uid);
      _activeChild = _children.isNotEmpty ? _children.first : null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _firebaseService.signUp(email, password, name);
      _children = await _firebaseService.getChildren(_currentUser!.uid);
      _activeChild = _children.isNotEmpty ? _children.first : null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectChild(String childId) async {
    final found = _children.where((c) => c.id == childId).firstOrNull;
    if (found != null) {
      _activeChild = found;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('edu_active_child_id', found.id);
      _audioService.playPop();
      notifyListeners();
    }
  }

  Future<void> addChild({
    required String nickname,
    required int age,
    required String avatarUrl,
  }) async {
    if (_currentUser == null) return;
    final ageGroup = AgeGroupExtension.fromAge(age);
    final newChild = ChildProfile(
      id: 'child_${DateTime.now().millisecondsSinceEpoch}',
      parentId: _currentUser!.uid,
      nickname: nickname,
      avatarUrl: avatarUrl,
      age: age,
      ageGroup: ageGroup,
      totalXp: 0,
      currentStreakDays: 1,
      lastActiveAt: DateTime.now(),
      createdAt: DateTime.now(),
      preferences: {
        'soundEffects': true,
        'voiceOver': age <= 6,
        'theme': age <= 5 ? 'playful' : age <= 8 ? 'adventure' : 'cyber',
      },
      screenTimeLimits: ScreenTimeLimits(
        dailyMinutesLimit: age <= 5 ? 25 : age <= 8 ? 35 : 50,
        usedMinutesToday: 0,
        lastDateUsed: DateTime.now().toIso8601String().split('T')[0],
      ),
    );

    await _firebaseService.saveChild(newChild);
    _children = await _firebaseService.getChildren(_currentUser!.uid);
    _activeChild = newChild;
    notifyListeners();
  }

  Future<void> updateChildProfile(ChildProfile child) async {
    await _firebaseService.saveChild(child);
    _children = await _firebaseService.getChildren(_currentUser!.uid);
    if (_activeChild?.id == child.id) {
      _activeChild = child;
    }
    notifyListeners();
  }
}
