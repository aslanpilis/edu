import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/learning_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/curriculum_models.dart';
import 'activities/counting_activity.dart';
import 'activities/phonics_activity.dart';
import 'activities/logic_pattern_activity.dart';
import 'activities/robot_code_activity.dart';
import 'activities/quiz_activity.dart';
import 'activities/memory_match_activity.dart';
import 'activities/maze_path_activity.dart';
import 'activities/shadow_match_activity.dart';
import 'activities/simon_sequence_activity.dart';
import 'activities/balance_scale_activity.dart';
import 'activities/odd_one_out_activity.dart';
import 'activities/rhythm_repeat_activity.dart';
import 'activities/habitat_sort_activity.dart';
import 'activities/size_order_activity.dart';
import 'activities/color_mix_activity.dart';
import 'activities/math_challenge_activity.dart';
import 'activities/tangram_puzzle_activity.dart';
import 'activities/matrix_logic_activity.dart';
import 'activities/spot_difference_activity.dart';
import 'lesson_success_dialog.dart';

class LessonPlayerScreen extends StatelessWidget {
  const LessonPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final learning = context.watch<LearningProvider>();
    final auth = context.read<AuthProvider>();

    final lesson = learning.activeLesson;
    final currentActivity = learning.currentActivity;

    if (lesson == null || currentActivity == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ana Ekrana Dön'),
          ),
        ),
      );
    }

    Widget activityWidget;
    switch (currentActivity.type) {
      case ActivityType.countingDragDrop:
        activityWidget = CountingActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.letterPhonicsMatch:
        activityWidget = PhonicsActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.logicPattern:
        activityWidget = LogicPatternActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.codeSequence:
        activityWidget = RobotCodeActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.memoryMatch:
        activityWidget = MemoryMatchActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.mazePath:
        activityWidget = MazePathActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.shadowMatch:
        activityWidget = ShadowMatchActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.simonSequence:
        activityWidget = SimonSequenceActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.balanceScale:
        activityWidget = BalanceScaleActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.oddOneOut:
        activityWidget = OddOneOutActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.rhythmRepeat:
        activityWidget = RhythmRepeatActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.habitatSort:
        activityWidget = HabitatSortActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.sizeOrder:
        activityWidget = SizeOrderActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.colorMix:
        activityWidget = ColorMixActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.mathChallenge:
        activityWidget = MathChallengeActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.tangramPuzzle:
        activityWidget = TangramPuzzleActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.matrixLogic:
        activityWidget = MatrixLogicActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.spotDifference:
        activityWidget = SpotDifferenceActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
      case ActivityType.scienceQuiz:
        activityWidget = QuizActivityWidget(
          key: ValueKey(currentActivity.id),
          payload: currentActivity.payload,
          onAnswer: (correct) => learning.submitAnswer(correct),
        );
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Top Progress & Navigation Bar
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      learning.exitLesson();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Progress Steps
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (learning.currentActivityIndex + 1) / learning.totalActivities,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        minHeight: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      '${learning.currentActivityIndex + 1}/${learning.totalActivities}',
                      style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF475569)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Instruction Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Text('📢', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        currentActivity.instruction,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Activity Body
              Expanded(child: activityWidget),
              const SizedBox(height: 16),

              // Next Activity / Finish Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final activeChild = auth.activeChild;
                    if (activeChild != null) {
                      await learning.nextActivity(
                        activeChild,
                        (updated) => auth.updateChildProfile(updated),
                      );

                      if (learning.isFinished && learning.lastResult != null && context.mounted) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => LessonSuccessDialog(
                            result: learning.lastResult!,
                            onContinue: () {
                              learning.exitLesson();
                              Navigator.of(context).pop(); // close dialog
                              Navigator.of(context).pop(); // close lesson player
                            },
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    learning.currentActivityIndex + 1 < learning.totalActivities
                        ? 'Sonraki Soru'
                        : 'Dersi Bitir 🏁',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
