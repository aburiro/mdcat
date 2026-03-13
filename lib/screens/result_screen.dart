import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────
enum QuestionResult { correct, incorrect, skipped }

class QuestionBreakdownItem {
  final int questionNumber;
  final String topic;
  final QuestionResult result;

  const QuestionBreakdownItem({
    required this.questionNumber,
    required this.topic,
    required this.result,
  });
}

class TestResult {
  final int score;
  final int total;
  final int correct;
  final int incorrect;
  final int skipped;
  final int timeTakenSeconds;
  final int avgSecondsPerQuestion;
  final List<QuestionBreakdownItem> breakdown;

  const TestResult({
    required this.score,
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.skipped,
    required this.timeTakenSeconds,
    required this.avgSecondsPerQuestion,
    required this.breakdown,
  });

  double get percentage => score / total;

  String get timeFormatted {
    final m = timeTakenSeconds ~/ 60;
    final s = timeTakenSeconds % 60;
    return '${m}m ${s}s';
  }
}

// ─── Result Screen ────────────────────────────────────────────────────────────
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _progressAnim;

  final TestResult result = const TestResult(
    score: 160,
    total: 200,
    correct: 40,
    incorrect: 8,
    skipped: 2,
    timeTakenSeconds: 42 * 60 + 15,
    avgSecondsPerQuestion: 50,
    breakdown: [
      QuestionBreakdownItem(
        questionNumber: 12,
        topic: 'Biology – Enzymes',
        result: QuestionResult.incorrect,
      ),
      QuestionBreakdownItem(
        questionNumber: 14,
        topic: 'Biology – Bioenergetics',
        result: QuestionResult.correct,
      ),
      QuestionBreakdownItem(
        questionNumber: 15,
        topic: 'Biology – Bioenergetics',
        result: QuestionResult.skipped,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnim = Tween<double>(
      begin: 0,
      end: result.percentage,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeadline(),
                    const SizedBox(height: 14),
                    _buildScoreCard(),
                    const SizedBox(height: 16),
                    _buildReviewMistakesButton(),
                    const SizedBox(height: 10),
                    _buildReviewAllButton(),
                    const SizedBox(height: 20),
                    _buildBreakdownSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: const Color(0xFF1A3A6B),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Row(
              children: [
                Icon(Icons.close, color: Colors.white, size: 20),
                SizedBox(width: 6),
                Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Headline ──────────────────────────────────────────────────────────────
  Widget _buildHeadline() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 18, color: Color(0xFF1A1A2E), height: 1.4),
        children: [
          TextSpan(
            text: 'Test Complete! ',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: 'Here is how you did.',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  // ─── Score Card ────────────────────────────────────────────────────────────
  Widget _buildScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated circular chart
          AnimatedBuilder(
            animation: _progressAnim,
            builder: (_, __) => SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: _ScoreRingPainter(progress: _progressAnim.value),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${result.score}/${result.total}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 14),
                          children: [
                            const TextSpan(
                              text: 'Score: ',
                              style: TextStyle(color: Color(0xFF555555)),
                            ),
                            TextSpan(
                              text: '${(result.percentage * 100).toInt()}%',
                              style: const TextStyle(
                                color: Color(0xFF2E8B57),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Score label below ring
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
              children: [
                const TextSpan(text: 'Score: '),
                TextSpan(
                  text: '${(result.percentage * 100).toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFF2E8B57),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.check,
                iconColor: Colors.white,
                iconBg: const Color(0xFF2E8B57),
                value: '${result.correct}',
                label: 'Correct',
                valueColor: const Color(0xFF2E8B57),
              ),
              _buildDivider(),
              _buildStatItem(
                icon: Icons.close,
                iconColor: Colors.white,
                iconBg: const Color(0xFFD32F2F),
                value: '${result.incorrect}',
                label: 'Incorrect',
                valueColor: const Color(0xFFD32F2F),
              ),
              _buildDivider(),
              _buildStatItem(
                icon: Icons.remove,
                iconColor: const Color(0xFF555555),
                iconBg: const Color(0xFFEEEEEE),
                value: '${result.skipped}',
                label: 'Skipped',
                valueColor: const Color(0xFF333333),
              ),
              _buildDivider(),
              _buildTimeItem(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: const Color(0xFFEEEEEE));
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
        ),
      ],
    );
  }

  Widget _buildTimeItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              size: 18,
              color: Color(0xFF555555),
            ),
            const SizedBox(width: 4),
            const Text(
              'Time:',
              style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          result.timeFormatted,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        Text(
          '(Avg. ${result.avgSecondsPerQuestion} sec/question)',
          style: const TextStyle(fontSize: 10, color: Color(0xFF999999)),
        ),
      ],
    );
  }

  // ─── Review Mistakes Button ────────────────────────────────────────────────
  Widget _buildReviewMistakesButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE87722),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('💡', style: TextStyle(fontSize: 18)),
            SizedBox(width: 10),
            Text(
              'Review Mistakes & Explanations',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  // ─── Review All Button ─────────────────────────────────────────────────────
  Widget _buildReviewAllButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1A1A2E),
          side: const BorderSide(color: Color(0xFFCCCCCC)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Review All Questions',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }

  // ─── Question Breakdown ────────────────────────────────────────────────────
  Widget _buildBreakdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Question Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A3A6B),
          ),
        ),
        const SizedBox(height: 12),
        ...result.breakdown.map((item) => _BreakdownTile(item: item)).toList(),
      ],
    );
  }

  // ─── Bottom Bar ────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Previous
          Expanded(
            flex: 2,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_ios, size: 13),
              label: const Text(
                'Previous',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF555555),
                side: const BorderSide(color: Color(0xFFCCCCCC)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Review All Questions
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🚩', style: TextStyle(fontSize: 15)),
                  SizedBox(width: 6),
                  Text(
                    'Review All Questions',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Breakdown Tile ───────────────────────────────────────────────────────────
class _BreakdownTile extends StatelessWidget {
  final QuestionBreakdownItem item;

  const _BreakdownTile({required this.item});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color iconColor;
    IconData iconData;
    Color textColor = const Color(0xFF1A1A2E);

    switch (item.result) {
      case QuestionResult.correct:
        bgColor = const Color(0xFF2E8B57);
        iconColor = Colors.white;
        iconData = Icons.check;
        break;
      case QuestionResult.incorrect:
        bgColor = const Color(0xFFD32F2F);
        iconColor = Colors.white;
        iconData = Icons.close;
        break;
      case QuestionResult.skipped:
        bgColor = const Color(0xFFEEEEEE);
        iconColor = const Color(0xFF555555);
        iconData = Icons.remove;
        textColor = const Color(0xFF555555);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status Badge
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(iconData, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),

          // Question info
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: textColor),
                children: [
                  TextSpan(
                    text: 'Question ${item.questionNumber}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: ' (${item.topic})',
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Color(0xFF999999),
          ),
        ],
      ),
    );
  }
}

// ─── Score Ring Painter ───────────────────────────────────────────────────────
class _ScoreRingPainter extends CustomPainter {
  final double progress;

  _ScoreRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 10;
    final innerRadius = outerRadius - 22;
    const startAngle = -math.pi / 2;
    const strokeWidth = 22.0;

    // Outer background ring
    final bgPaint = Paint()
      ..color = const Color(0xFFE8EEF5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, outerRadius, bgPaint);

    // Blue-to-green gradient progress arc
    final rect = Rect.fromCircle(center: center, radius: outerRadius);
    final progressPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          Color(0xFF1565C0),
          Color(0xFF1E88E5),
          Color(0xFF43A047),
          Color(0xFFCDDC39),
        ],
        stops: [0.0, 0.4, 0.7, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Inner shadow ring for depth
    final shadowPaint = Paint()
      ..color = const Color(0x221A3A6B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(
      rect,
      startAngle,
      2 * math.pi * progress,
      false,
      shadowPaint,
    );

    // Confetti dots around the ring
    final random = math.Random(42);
    final confettiColors = [
      const Color(0xFFE87722),
      const Color(0xFF1E88E5),
      const Color(0xFF43A047),
      const Color(0xFFCDDC39),
      const Color(0xFFD32F2F),
    ];

    for (int i = 0; i < 18; i++) {
      final angle = (i / 18) * 2 * math.pi - math.pi / 2;
      final dist = outerRadius + 18 + random.nextDouble() * 14;
      final x = center.dx + dist * math.cos(angle);
      final y = center.dy + dist * math.sin(angle);
      final dotPaint = Paint()
        ..color = confettiColors[i % confettiColors.length].withOpacity(0.7);
      canvas.drawCircle(Offset(x, y), 3 + random.nextDouble() * 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ScoreRingPainter old) => old.progress != progress;
}
