import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'biology_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              _buildProgressCard(context),
              const SizedBox(height: 20),
              const Text(
                'Subject Grid',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3A6B),
                ),
              ),
              const SizedBox(height: 12),
              _buildSubjectGrid(context),
              const SizedBox(height: 20),
              _buildQuizButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Good morning, Future Doctor!',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A3A6B),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A3A6B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Text('🔥', style: TextStyle(fontSize: 14)),
              SizedBox(width: 4),
              Text(
                '3 Days',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A6B), Color(0xFF2457A4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A3A6B).withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _CircularProgressPainter(progress: 0.45),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '45%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Total Syllabus\nCompleted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You are on track for the MDCAT 2026!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/subject/biology');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE87722),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resume Biology: Bioenergetics',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectGrid(BuildContext context) {
    void openBiology() => Navigator.pushNamed(context, '/subject/biology');

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SubjectCard(
                title: 'Biology',
                icon: Icons.biotech,
                progress: 0.60,
                color: const Color(0xFF2E8B57),
                iconEmoji: '🧬',
                onTap: openBiology,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SubjectCard(
                title: 'Chemistry',
                icon: Icons.science,
                progress: 0.40,
                color: const Color(0xFF1E6BB8),
                iconEmoji: '🧪',
                onTap: openBiology,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SubjectCard(
                title: 'Physics',
                icon: Icons.atm,
                progress: 0.30,
                color: const Color(0xFF2E5CA8),
                iconEmoji: '⚙️',
                onTap: openBiology,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SubjectCard(
                title: 'English',
                icon: Icons.menu_book,
                progress: 0.80,
                color: const Color(0xFF8B1A1A),
                iconEmoji: '📖',
                onTap: openBiology,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SubjectCard(
                title: 'Logical Reasoning',
                icon: Icons.psychology,
                progress: 0.10,
                color: const Color(0xFF5B2D8E),
                iconEmoji: '🧠',
                smallTitle: true,
                onTap: openBiology,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuizButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E5AAB), Color(0xFF2457A4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A3A6B).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pushNamed(context, '/quiz'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('📝', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Take a Quick 20-MCQ Mix Quiz',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double progress;
  final Color color;
  final String iconEmoji;
  final bool smallTitle;
  final VoidCallback? onTap;

  const _SubjectCard({
    required this.title,
    required this.icon,
    required this.progress,
    required this.color,
    required this.iconEmoji,
    this.smallTitle = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toInt();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(iconEmoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: smallTitle ? 11 : 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '$percent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE8A020),
                  ),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const startAngle = -math.pi / 2;
    const strokeWidth = 14.0;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final bluePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress * 0.7,
      false,
      bluePaint,
    );

    final orangePaint = Paint()
      ..color = const Color(0xFFE87722)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + 2 * math.pi * progress * 0.7,
      2 * math.pi * progress * 0.3,
      false,
      orangePaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
