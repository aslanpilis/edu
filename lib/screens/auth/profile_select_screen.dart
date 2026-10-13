import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/child_profile.dart';
import '../child/child_dashboard_screen.dart';
import '../parent/parent_dashboard_screen.dart';
import '../parent/parental_gate_dialog.dart';
import 'add_child_screen.dart';

class ProfileSelectScreen extends StatelessWidget {
  const ProfileSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final children = auth.children;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A), Color(0xFFF8FAFC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // Top Bar with Parent Portal Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Merhaba, ${auth.currentUser?.displayName.split(' ').first ?? 'Ebeveyn'} 👋',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF475569),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ParentalGateDialog(
                            onSuccess: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ParentDashboardScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.shield_outlined, size: 18),
                      label: const Text('Ebeveyn Paneli'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF475569),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Main Title
                const Text(
                  'Bugün Kim Öğreniyor?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Öğrenme dünyasını açmak için profilini seç 🚀',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 36),

                // Child Profile Cards Grid
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          ...children.map((child) => _buildChildCard(context, auth, child)),
                          _buildAddChildCard(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, AuthProvider auth, ChildProfile child) {
    Color cardBorder;
    Color bgPill;
    String badgeText;

    switch (child.ageGroup) {
      case AgeGroup.age3To5:
        cardBorder = const Color(0xFFF59E0B);
        bgPill = const Color(0xFFFEF3C7);
        badgeText = '3-5 Yaş (Keşif)';
        break;
      case AgeGroup.age6To8:
        cardBorder = const Color(0xFF10B981);
        bgPill = const Color(0xFFD1FAE5);
        badgeText = '6-8 Yaş (Macera)';
        break;
      case AgeGroup.age9To12:
        cardBorder = const Color(0xFF6366F1);
        bgPill = const Color(0xFFE0E7FF);
        badgeText = '9-12 Yaş (Ustalık)';
        break;
    }

    return InkWell(
      onTap: () async {
        await auth.selectChild(child.id);
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const ChildDashboardScreen(),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 170,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: cardBorder, width: 3),
          boxShadow: [
            BoxShadow(
              color: cardBorder.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: bgPill,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(child.avatarUrl, style: const TextStyle(fontSize: 42)),
            ),
            const SizedBox(height: 14),
            Text(
              child.nickname,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: bgPill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: cardBorder,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  '${child.totalXp} XP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddChildCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddChildScreen()),
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 170,
        height: 215,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 2, style: BorderStyle.solid),
        ),
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 48, color: Color(0xFF94A3B8)),
            SizedBox(height: 12),
            Text(
              'Yeni Çocuk\nProfili Ekle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
