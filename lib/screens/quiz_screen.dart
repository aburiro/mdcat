import 'dart:async';
import 'package:flutter/material.dart';
import 'result_screen.dart';

// ─── Data Model ──────────────────────────────────────────────────────────────
class QuizQuestion {
  final String question;
  final String? imageAsset; // optional image path
  final String? imageLabel;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    this.imageAsset,
    this.imageLabel,
    required this.options,
    required this.correctIndex,
  });
}

// ─── Quiz Screen ─────────────────────────────────────────────────────────────
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Sample questions list
  final List<QuizQuestion> _questions = const [
    QuizQuestion(
      question: 'Which of the following is a function of the Golgi apparatus?',
      imageLabel: 'Golgi Apparatus',
      options: [
        'Synthesizing proteins',
        'Producing ATP',
        'Transporting and modifying proteins',
        'Digesting worn-out organelles',
      ],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: 'Which organelle is known as the powerhouse of the cell?',
      options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Lysosome'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'DNA replication occurs during which phase of the cell cycle?',
      options: ['G1 phase', 'M phase', 'S phase', 'G2 phase'],
      correctIndex: 2,
    ),
  ];

  int _currentIndex = 13; // display as "Question 14 of 50"
  int? _selectedOption;
  bool _flagged = false;
  final Set<int> _flaggedQuestions = {};

  // Timer
  int _secondsLeft = 45 * 60 + 12; // 45:12
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  QuizQuestion get _current => _questions[_currentIndex % _questions.length];

  void _selectOption(int i) => setState(() => _selectedOption = i);

  void _goNext() {
    setState(() {
      _currentIndex++;
      _selectedOption = null;
      _flagged = _flaggedQuestions.contains(_currentIndex);
    });
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedOption = null;
        _flagged = _flaggedQuestions.contains(_currentIndex);
      });
    }
  }

  void _toggleFlag() {
    setState(() {
      _flagged = !_flagged;
      if (_flagged) {
        _flaggedQuestions.add(_currentIndex);
      } else {
        _flaggedQuestions.remove(_currentIndex);
      }
    });
  }

  void _submitTest() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Submit Test?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Are you sure you want to submit the test?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/results');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3A6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = 50;
    final questionNumber = _currentIndex + 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(questionNumber, totalQuestions),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Text
                    _buildQuestionText(),
                    const SizedBox(height: 14),

                    // Image Card (if available)
                    if (_current.imageLabel != null) _buildImageCard(),
                    const SizedBox(height: 16),

                    // Options
                    ..._buildOptions(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            _buildBottomNav(),

            // Submit Bar
            _buildSubmitBar(),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────
  Widget _buildAppBar(int current, int total) {
    return Container(
      color: const Color(0xFF1A3A6B),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Close
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.close, color: Colors.white, size: 24),
          ),
          // Title
          Expanded(
            child: Text(
              'Question $current of $total',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.amber, size: 16),
                const SizedBox(width: 5),
                Text(
                  _timerText,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Question Text ─────────────────────────────────────────────────────────
  Widget _buildQuestionText() {
    return Text(
      _current.question,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
        height: 1.45,
      ),
    );
  }

  // ─── Image Card ────────────────────────────────────────────────────────────
  Widget _buildImageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Placeholder illustration for Golgi Apparatus
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              size: const Size(double.infinity, 160),
              painter: _GolgiApparatusPainter(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _current.imageLabel!,
            style: const TextStyle(
              color: Color(0xFF1E6BB8),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Options ───────────────────────────────────────────────────────────────
  List<Widget> _buildOptions() {
    const labels = ['A', 'B', 'C', 'D'];
    return List.generate(_current.options.length, (i) {
      final isSelected = _selectedOption == i;
      return GestureDetector(
        onTap: () => _selectOption(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEBF2FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1A3A6B)
                  : const Color(0xFFDDDDDD),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Label Badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A3A6B)
                      : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _current.options[i],
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFF1A3A6B)
                        : const Color(0xFF2A2A2A),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ─── Bottom Navigation ────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Previous
          TextButton.icon(
            onPressed: _currentIndex > 0 ? _goPrevious : null,
            icon: const Icon(Icons.arrow_back_ios, size: 14),
            label: const Text(
              'Previous',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF555555),
              disabledForegroundColor: Colors.grey.shade300,
            ),
          ),

          const Spacer(),

          // Flag Button
          GestureDetector(
            onTap: _toggleFlag,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _flagged
                    ? const Color(0xFF1A3A6B)
                    : const Color(0xFFF0F4FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCCCCCC)),
              ),
              child: Icon(
                Icons.flag,
                color: _flagged ? Colors.white : const Color(0xFF888888),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Next Button
          ElevatedButton(
            onPressed: _goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE87722),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Row(
              children: [
                Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Submit Bar ───────────────────────────────────────────────────────────
  Widget _buildSubmitBar() {
    return Container(
      color: const Color(0xFF1A3A6B),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: _submitTest,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30),
              ),
              child: const Row(
                children: [
                  Text(
                    'Submit Test',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 13),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Golgi Apparatus Illustration Painter ─────────────────────────────────
class _GolgiApparatusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Draw stacked curved cisternae (Golgi membranes)
    final greenPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final darkGreenPaint = Paint()
      ..color = const Color(0xFF388E3C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    for (int i = -2; i <= 2; i++) {
      final offsetY = cy + i * 14.0;
      final paint = i.isEven ? greenPaint : darkGreenPaint;
      final path = Path();
      path.moveTo(cx - 70, offsetY);
      path.cubicTo(
        cx - 30,
        offsetY - 10,
        cx + 30,
        offsetY - 10,
        cx + 70,
        offsetY,
      );
      canvas.drawPath(path, paint);
    }

    // Vesicles on the left (blue dots)
    final blueDotPaint = Paint()..color = const Color(0xFF1976D2);
    final positions = [
      Offset(cx - 90, cy - 20),
      Offset(cx - 105, cy),
      Offset(cx - 88, cy + 18),
    ];
    for (final p in positions) {
      canvas.drawCircle(p, 7, blueDotPaint);
      // small connector line
      canvas.drawLine(
        p,
        Offset(cx - 72, cy),
        Paint()
          ..color = const Color(0xFF1976D2).withOpacity(0.5)
          ..strokeWidth = 1.5,
      );
    }

    // Vesicles on the right (orange)
    final orangePaint = Paint()..color = const Color(0xFFE87722);
    final rightPos = [Offset(cx + 90, cy - 18), Offset(cx + 105, cy + 2)];
    for (final p in rightPos) {
      canvas.drawCircle(p, 9, orangePaint);
    }

    // Small green dots floating above
    final lightGreen = Paint()..color = const Color(0xFF81C784);
    final greenDots = [
      Offset(cx - 20, cy - 42),
      Offset(cx + 10, cy - 48),
      Offset(cx + 40, cy - 38),
    ];
    for (final p in greenDots) {
      canvas.drawCircle(p, 5, lightGreen);
    }

    // Arrow pointing right
    final arrowPaint = Paint()
      ..color = const Color(0xFF90A4AE)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final arrowPath = Path();
    arrowPath.moveTo(cx + 72, cy + 20);
    arrowPath.quadraticBezierTo(cx + 90, cy + 35, cx + 78, cy + 50);
    canvas.drawPath(arrowPath, arrowPaint);

    // Arrowhead
    final headPaint = Paint()..color = const Color(0xFF90A4AE);
    final arrowHead = Path();
    arrowHead.moveTo(cx + 73, cy + 50);
    arrowHead.lineTo(cx + 83, cy + 48);
    arrowHead.lineTo(cx + 78, cy + 58);
    arrowHead.close();
    canvas.drawPath(arrowHead, headPaint);
  }

  @override
  bool shouldRepaint(_GolgiApparatusPainter _) => false;
}
