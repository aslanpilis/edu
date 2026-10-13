import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MathChallengeActivityWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final ValueChanged<bool> onAnswer;

  const MathChallengeActivityWidget({
    super.key,
    required this.payload,
    required this.onAnswer,
  });

  @override
  State<MathChallengeActivityWidget> createState() => _MathChallengeActivityWidgetState();
}

class _MathQuestion {
  final String prompt;
  final int correctAnswer;
  final List<int> options;
  final String explanation;

  _MathQuestion({
    required this.prompt,
    required this.correctAnswer,
    required this.options,
    required this.explanation,
  });
}

class _MathChallengeActivityWidgetState extends State<MathChallengeActivityWidget> {
  late int _level;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;
  late List<_MathQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _level = widget.payload['level'] is int ? widget.payload['level'] : 1;
    _generateQuestions();
  }

  void _generateQuestions() {
    final rng = Random();
    _questions = [];

    if (_level == 1) {
      // Level 1: Basit Toplama & Çıkarma (1-10)
      for (int i = 0; i < 4; i++) {
        bool isAdd = rng.nextBool();
        int a = rng.nextInt(6) + 1;
        int b = rng.nextInt(5) + 1;
        if (!isAdd && a < b) {
          int tmp = a; a = b; b = tmp;
        }
        int ans = isAdd ? a + b : a - b;
        List<int> opts = [ans];
        while (opts.length < 4) {
          int fake = ans + (rng.nextInt(5) - 2);
          if (fake >= 0 && !opts.contains(fake)) opts.add(fake);
        }
        opts.shuffle();
        _questions.add(_MathQuestion(
          prompt: isAdd ? '$a + $b = ?' : '$a - $b = ?',
          correctAnswer: ans,
          options: opts,
          explanation: '$a ${isAdd ? "+" : "-"} $b işleminin sonucu $ans eder!',
        ));
      }
    } else if (_level == 2) {
      // Level 2: Eksik Sayı Bulma (1-20)
      for (int i = 0; i < 4; i++) {
        int a = rng.nextInt(10) + 2;
        int target = a + rng.nextInt(9) + 1;
        int missing = target - a;
        List<int> opts = [missing];
        while (opts.length < 4) {
          int fake = missing + (rng.nextInt(7) - 3);
          if (fake > 0 && !opts.contains(fake)) opts.add(fake);
        }
        opts.shuffle();
        _questions.add(_MathQuestion(
          prompt: '$a +  ?  = $target',
          correctAnswer: missing,
          options: opts,
          explanation: '$a sayısına $missing eklersek $target olur!',
        ));
      }
    } else if (_level == 3) {
      // Level 3: Çarpma & İki Basamaklı İşlem
      for (int i = 0; i < 4; i++) {
        bool isMul = rng.nextBool();
        if (isMul) {
          int a = rng.nextInt(7) + 3;
          int b = rng.nextInt(8) + 2;
          int ans = a * b;
          List<int> opts = [ans];
          while (opts.length < 4) {
            int fake = ans + (rng.nextBool() ? 1 : -1) * (rng.nextInt(4) + 1) * a;
            if (fake > 0 && !opts.contains(fake)) opts.add(fake);
          }
          opts.shuffle();
          _questions.add(_MathQuestion(
            prompt: '$a × $b = ?',
            correctAnswer: ans,
            options: opts,
            explanation: '$a kere $b, $ans yapar!',
          ));
        } else {
          int a = rng.nextInt(35) + 15;
          int b = rng.nextInt(25) + 10;
          int ans = a + b;
          List<int> opts = [ans];
          while (opts.length < 4) {
            int fake = ans + (rng.nextInt(11) - 5);
            if (fake > 0 && !opts.contains(fake)) opts.add(fake);
          }
          opts.shuffle();
          _questions.add(_MathQuestion(
            prompt: '$a + $b = ?',
            correctAnswer: ans,
            options: opts,
            explanation: '$a + $b = $ans',
          ));
        }
      }
    } else {
      // Level 4: Çoklu İşlemler ((a x b) + c)
      for (int i = 0; i < 4; i++) {
        int a = rng.nextInt(6) + 2;
        int b = rng.nextInt(5) + 2;
        int c = rng.nextInt(10) + 1;
        int ans = (a * b) + c;
        List<int> opts = [ans];
        while (opts.length < 4) {
          int fake = ans + (rng.nextInt(9) - 4);
          if (fake > 0 && !opts.contains(fake)) opts.add(fake);
        }
        opts.shuffle();
        _questions.add(_MathQuestion(
          prompt: '($a × $b) + $c = ?',
          correctAnswer: ans,
          options: opts,
          explanation: '$a × $b = ${a * b}, üzerine $c eklersek $ans olur!',
        ));
      }
    }
  }

  void _onOptionSelected(int answer) {
    if (_isAnswered) return;
    final currentQ = _questions[_currentQuestionIndex];
    final isCorrect = answer == currentQ.correctAnswer;

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
      _isCorrect = isCorrect;
      if (isCorrect) _score++;
    });

    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (_currentQuestionIndex + 1 < _questions.length) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswer = null;
          _isAnswered = false;
        });
      } else {
        // Tamamlandı
        widget.onAnswer(_score >= (_questions.length * 0.75).ceil());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentQuestionIndex];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Header Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade400),
                ),
                child: Row(
                  children: [
                    const Text('⚡ Seviye: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber)),
                    Text(
                      _level == 1 ? '1 (Kolay)' : _level == 2 ? '2 (Orta)' : _level == 3 ? '3 (Zor)' : '4 (Usta)',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.orange.shade800),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Soru ${_currentQuestionIndex + 1} / ${_questions.length}',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.indigo.shade700, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text('🧮 Hızlı Matematik', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                Text(
                  currentQ.prompt,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Options Grid (4 large buttons)
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              physics: const NeverScrollableScrollPhysics(),
              children: currentQ.options.map((opt) {
                final isSelected = _selectedAnswer == opt;
                final isThisCorrect = opt == currentQ.correctAnswer;

                Color bgColor = Colors.white;
                Color textColor = const Color(0xFF1E293B);
                Border border = Border.all(color: const Color(0xFFE2E8F0), width: 2);

                if (_isAnswered) {
                  if (isThisCorrect) {
                    bgColor = const Color(0xFF10B981);
                    textColor = Colors.white;
                    border = Border.all(color: const Color(0xFF059669), width: 3);
                  } else if (isSelected) {
                    bgColor = const Color(0xFFEF4444);
                    textColor = Colors.white;
                    border = Border.all(color: const Color(0xFFDC2626), width: 3);
                  }
                }

                return Material(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(24),
                  elevation: isSelected ? 8 : 2,
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _isAnswered ? null : () => _onOptionSelected(opt),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: border,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$opt',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          if (_isAnswered)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: _isCorrect ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
              ),
              child: Row(
                children: [
                  Text(_isCorrect ? '🎉' : '💡', style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isCorrect ? 'Harika! Doğru cevap!' : currentQ.explanation,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _isCorrect ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
