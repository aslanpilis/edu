import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/child_profile.dart';
import '../../widgets/xp_progress_bar.dart';
import '../../widgets/screen_time_banner.dart';
import '../parent/parental_gate_dialog.dart';
import '../parent/parent_dashboard_screen.dart';
import '../auth/profile_select_screen.dart';
import 'age_3_5_view.dart';
import 'age_6_8_view.dart';
import 'age_9_12_view.dart';

class ChildDashboardScreen extends StatelessWidget {
  const ChildDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final activeChild = auth.activeChild;

    if (activeChild == null) {
      return const ProfileSelectScreen();
    }

    Widget childView;
    switch (activeChild.ageGroup) {
      case AgeGroup.age3To5:
        childView = Age3To5View(child: activeChild);
        break;
      case AgeGroup.age6To8:
        childView = Age6To8View(child: activeChild);
        break;
      case AgeGroup.age9To12:
        childView = Age9To12View(child: activeChild);
        break;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Top Action Row
              Row(
                children: [
                  Expanded(
                    child: XpProgressBar(
                      totalXp: activeChild.totalXp,
                      streakDays: activeChild.currentStreakDays,
                      avatarEmoji: activeChild.avatarUrl,
                      nickname: activeChild.nickname,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Switch Child Button
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const ProfileSelectScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.swap_horiz, size: 28),
                    tooltip: 'Profil Değiştir',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF475569),
                    ),
                  ),

                  // Parental Gate Lock
                  IconButton(
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
                    icon: const Icon(Icons.shield, size: 28),
                    tooltip: 'Ebeveyn Paneli',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Screen time limit bar
              ScreenTimeBanner(limits: activeChild.screenTimeLimits),

              // Dynamic Age Group Body
              Expanded(child: childView),
            ],
          ),
        ),
      ),
    );
  }
}
