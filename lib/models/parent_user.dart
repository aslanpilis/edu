class ParentUser {
  final String uid;
  final String email;
  final String displayName;
  final String role; // parent | educator | admin
  final String subscriptionTier; // free | premium | family
  final DateTime createdAt;
  final Map<String, dynamic> settings;

  ParentUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.role = 'parent',
    this.subscriptionTier = 'free',
    required this.createdAt,
    this.settings = const {
      'notifications': true,
      'soundEnabled': true,
      'language': 'tr',
    },
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'subscriptionTier': subscriptionTier,
      'createdAt': createdAt.toIso8601String(),
      'settings': settings,
    };
  }

  factory ParentUser.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ParentUser(
      uid: docId ?? map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'Ebeveyn',
      role: map['role'] ?? 'parent',
      subscriptionTier: map['subscriptionTier'] ?? 'free',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }

  ParentUser copyWith({
    String? email,
    String? displayName,
    String? subscriptionTier,
    Map<String, dynamic>? settings,
  }) {
    return ParentUser(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      createdAt: createdAt,
      settings: settings ?? this.settings,
    );
  }
}
