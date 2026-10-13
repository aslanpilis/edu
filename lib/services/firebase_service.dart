import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/parent_user.dart';
import '../models/child_profile.dart';
import '../models/progress_models.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isFirebaseLive = false;
  bool get isFirebaseLive => _isFirebaseLive;

  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  Future<void> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        _isFirebaseLive = true;
        debugPrint('🔥 Firebase Connected Successfully');
      } else {
        _isFirebaseLive = false;
        debugPrint('ℹ️ Running in Local Persistence / Simulation Mode');
      }
    } catch (e) {
      _isFirebaseLive = false;
      debugPrint('Firebase init notice (local mode active): $e');
    }
  }

  // --- Parent User Authentication & Store ---
  Future<ParentUser> signIn(String email, String password) async {
    if (_isFirebaseLive && _auth != null && _firestore != null) {
      final userCred = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _firestore!.collection('users').doc(userCred.user!.uid).get();
      if (doc.exists && doc.data() != null) {
        final parent = ParentUser.fromMap(doc.data()!, docId: doc.id);
        await _saveLocalUser(parent);
        return parent;
      }
    }

    // Local / Demo Parent User
    final demoParent = ParentUser(
      uid: 'parent_demo_101',
      email: email.isNotEmpty ? email : 'veli@egitim.com',
      displayName: 'Ahmet Yılmaz (Ebeveyn)',
      role: 'parent',
      subscriptionTier: 'family',
      createdAt: DateTime.now(),
    );
    await _saveLocalUser(demoParent);
    return demoParent;
  }

  Future<ParentUser> signUp(String email, String password, String name) async {
    if (_isFirebaseLive && _auth != null && _firestore != null) {
      final userCred = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final parent = ParentUser(
        uid: userCred.user!.uid,
        email: email,
        displayName: name,
        createdAt: DateTime.now(),
      );
      await _firestore!.collection('users').doc(parent.uid).set(parent.toMap());
      await _saveLocalUser(parent);
      return parent;
    }

    final localParent = ParentUser(
      uid: 'parent_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: name.isNotEmpty ? name : 'Ebeveyn',
      createdAt: DateTime.now(),
    );
    await _saveLocalUser(localParent);
    return localParent;
  }

  Future<void> signOut() async {
    if (_isFirebaseLive && _auth != null) {
      await _auth!.signOut();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('edu_current_user');
    await prefs.remove('edu_active_child_id');
  }

  Future<ParentUser?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('edu_current_user');
    if (raw != null) {
      try {
        return ParentUser.fromMap(jsonDecode(raw));
      } catch (e) {
        debugPrint('Error parsing saved user: $e');
      }
    }
    return null;
  }

  Future<void> _saveLocalUser(ParentUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('edu_current_user', jsonEncode(user.toMap()));
  }

  // --- Children Profiles (users/{parentId}/children/{childId}) ---
  Future<List<ChildProfile>> getChildren(String parentId) async {
    if (_isFirebaseLive && _firestore != null) {
      try {
        final snap = await _firestore!
            .collection('users')
            .doc(parentId)
            .collection('children')
            .get();
        if (snap.docs.isNotEmpty) {
          final list = snap.docs
              .map((d) => ChildProfile.fromMap(d.data(), docId: d.id))
              .toList();
          await _saveLocalChildren(list);
          return list;
        }
      } catch (e) {
        debugPrint('Firestore getChildren error: $e');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('edu_children_list');
    if (raw != null) {
      try {
        final List<dynamic> decoded = jsonDecode(raw);
        return decoded.map((item) => ChildProfile.fromMap(item)).toList();
      } catch (e) {
        debugPrint('Error parsing children: $e');
      }
    }

    // Default pre-seeded multi-age profiles for immediate demonstration
    final defaultChildren = [
      ChildProfile(
        id: 'child_demo_1',
        parentId: parentId,
        nickname: 'Ece (4 Yaş)',
        avatarUrl: '🦊',
        age: 4,
        ageGroup: AgeGroup.age3To5,
        totalXp: 120,
        currentStreakDays: 2,
        lastActiveAt: DateTime.now(),
        createdAt: DateTime.now(),
        preferences: {'soundEffects': true, 'voiceOver': true, 'theme': 'playful'},
        screenTimeLimits: ScreenTimeLimits(
          dailyMinutesLimit: 25,
          usedMinutesToday: 8,
          lastDateUsed: DateTime.now().toIso8601String().split('T')[0],
        ),
      ),
      ChildProfile(
        id: 'child_demo_2',
        parentId: parentId,
        nickname: 'Can (7 Yaş)',
        avatarUrl: '🚀',
        age: 7,
        ageGroup: AgeGroup.age6To8,
        totalXp: 340,
        currentStreakDays: 4,
        lastActiveAt: DateTime.now(),
        createdAt: DateTime.now(),
        preferences: {'soundEffects': true, 'voiceOver': true, 'theme': 'adventure'},
        screenTimeLimits: ScreenTimeLimits(
          dailyMinutesLimit: 35,
          usedMinutesToday: 12,
          lastDateUsed: DateTime.now().toIso8601String().split('T')[0],
        ),
      ),
      ChildProfile(
        id: 'child_demo_3',
        parentId: parentId,
        nickname: 'Deniz (10 Yaş)',
        avatarUrl: '🤖',
        age: 10,
        ageGroup: AgeGroup.age9To12,
        totalXp: 780,
        currentStreakDays: 6,
        lastActiveAt: DateTime.now(),
        createdAt: DateTime.now(),
        preferences: {'soundEffects': true, 'voiceOver': false, 'theme': 'cyber'},
        screenTimeLimits: ScreenTimeLimits(
          dailyMinutesLimit: 45,
          usedMinutesToday: 20,
          lastDateUsed: DateTime.now().toIso8601String().split('T')[0],
        ),
      ),
    ];

    await _saveLocalChildren(defaultChildren);
    return defaultChildren;
  }

  Future<void> saveChild(ChildProfile child) async {
    final list = await getChildren(child.parentId);
    final idx = list.indexWhere((c) => c.id == child.id);
    if (idx >= 0) {
      list[idx] = child;
    } else {
      list.add(child);
    }
    await _saveLocalChildren(list);

    if (_isFirebaseLive && _firestore != null) {
      try {
        await _firestore!
            .collection('users')
            .doc(child.parentId)
            .collection('children')
            .doc(child.id)
            .set(child.toMap(), SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore saveChild error: $e');
      }
    }
  }

  Future<void> _saveLocalChildren(List<ChildProfile> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((c) => c.toMap()).toList();
    await prefs.setString('edu_children_list', jsonEncode(jsonList));
  }

  // --- Progress & Analytics Storage ---
  Future<List<ChildProgress>> getChildProgress(String childId) async {
    if (_isFirebaseLive && _firestore != null) {
      try {
        final snap = await _firestore!
            .collection('progress')
            .where('childId', isEqualTo: childId)
            .get();
        return snap.docs
            .map((d) => ChildProgress.fromMap(d.data(), docId: d.id))
            .toList();
      } catch (e) {
        debugPrint('Firestore getChildProgress error: $e');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('edu_progress_$childId');
    if (raw != null) {
      try {
        final List<dynamic> decoded = jsonDecode(raw);
        return decoded.map((item) => ChildProgress.fromMap(item)).toList();
      } catch (e) {}
    }
    return [];
  }

  Future<void> saveChildProgress(ChildProgress progress) async {
    final list = await getChildProgress(progress.childId);
    final idx = list.indexWhere((p) => p.id == progress.id);
    if (idx >= 0) {
      list[idx] = progress;
    } else {
      list.add(progress);
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((p) => p.toMap()).toList();
    await prefs.setString('edu_progress_${progress.childId}', jsonEncode(jsonList));

    if (_isFirebaseLive && _firestore != null) {
      try {
        await _firestore!
            .collection('progress')
            .doc(progress.id)
            .set(progress.toMap(), SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore saveChildProgress error: $e');
      }
    }
  }

  // --- Achievements ---
  Future<List<Achievement>> getAchievements(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('edu_achievements_$childId');
    if (raw != null) {
      try {
        final List<dynamic> decoded = jsonDecode(raw);
        return decoded.map((item) => Achievement.fromMap(item)).toList();
      } catch (e) {}
    }
    return [];
  }

  Future<void> saveAchievement(Achievement achievement) async {
    final list = await getAchievements(achievement.childId);
    if (!list.any((a) => a.id == achievement.id)) {
      list.add(achievement);
      final prefs = await SharedPreferences.getInstance();
      final jsonList = list.map((a) => a.toMap()).toList();
      await prefs.setString('edu_achievements_${achievement.childId}', jsonEncode(jsonList));

      if (_isFirebaseLive && _firestore != null) {
        try {
          await _firestore!
              .collection('achievements')
              .doc(achievement.id)
              .set(achievement.toMap(), SetOptions(merge: true));
        } catch (e) {
          debugPrint('Firestore saveAchievement error: $e');
        }
      }
    }
  }
}
