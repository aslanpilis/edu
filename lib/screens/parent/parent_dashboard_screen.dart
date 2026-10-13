import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/parent_provider.dart';
import '../../config/constants.dart';
import '../../models/child_profile.dart';
import '../../widgets/badge_card.dart';
import 'firebase_setup_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeChild = context.read<AuthProvider>().activeChild;
      if (activeChild != null) {
        context.read<ParentProvider>().loadChildAnalytics(activeChild.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final parentProv = context.watch<ParentProvider>();
    final activeChild = auth.activeChild;
    final analytics = parentProv.analytics;

    if (activeChild == null) {
      return const Scaffold(body: Center(child: Text('Aktif profil bulunamadı.')));
    }

    final offlineIdeas = SystemConstants.offlineActivitySuggestions[activeChild.ageGroup.code] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Ebeveyn Kontrol & Analitik'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FirebaseSetupScreen()),
              );
            },
            icon: const Icon(Icons.cloud_sync_outlined),
            tooltip: 'Firebase Durumu',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Child Info Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(activeChild.avatarUrl, style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeChild.nickname,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${activeChild.age} Yaş (${activeChild.ageGroup.code}) • Toplam ${activeChild.totalXp} XP',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daily Screen Time Limit Settings
            const Text(
              'Ekran Süresi Yönetimi ⏱️',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Günlük Süre Limiti:',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      Text(
                        '${activeChild.screenTimeLimits.dailyMinutesLimit} Dakika',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                  Slider(
                    value: activeChild.screenTimeLimits.dailyMinutesLimit.toDouble(),
                    min: 15,
                    max: 90,
                    divisions: 15,
                    activeColor: const Color(0xFF10B981),
                    onChanged: (val) {
                      final updated = activeChild.copyWith(
                        screenTimeLimits: activeChild.screenTimeLimits.copyWith(
                          dailyMinutesLimit: val.round(),
                        ),
                      );
                      auth.updateChildProfile(updated);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bugün Harcanan:', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      Text(
                        '${activeChild.screenTimeLimits.usedMinutesToday} dakika',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Performance Analytics Cards
            const Text(
              'Gelişim ve Başarı Karnesi 📊',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Tamamlanan Ders',
                    value: '${analytics?['completedCount'] ?? 0}',
                    icon: '📚',
                    color: const Color(0xFFFEF3C7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Öğrenme Süresi',
                    value: '${analytics?['totalMinutesSpent'] ?? 0} dk',
                    icon: '⏱️',
                    color: const Color(0xFFD1FAE5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Ortalama Başarı',
                    value: '%${analytics?['masteryPercentage'] ?? 0}',
                    icon: '🎯',
                    color: const Color(0xFFE0E7FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kazanılan Rozetler
            const Text(
              'Açılan Rozetler & Başarılar 🏆',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),

            ...SystemConstants.systemBadges.map((b) {
              final isUnlocked = parentProv.achievements.any((a) => a.badgeId == b['badgeId']);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: BadgeCard(
                  title: b['title'],
                  description: b['description'],
                  icon: b['icon'],
                  isUnlocked: isUnlocked,
                ),
              );
            }),
            const SizedBox(height: 24),

            // Evde Birlikte Yapılabilecek Offline Etkinlik Önerileri
            const Text(
              'Evde Birlikte Yapabileceğiniz Etkinlikler 🏠',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                children: offlineIdeas.map((idea) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🌱', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            idea,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF78350F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
