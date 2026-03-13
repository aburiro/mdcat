import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── Data Model ──────────────────────────────────────────────────────────────
enum ChapterStatus { completed, inProgress, notStarted }

class ChapterData {
  final String title;
  final int practiced;
  final int total;
  final int? score;
  final ChapterStatus status;

  const ChapterData({
    required this.title,
    required this.practiced,
    required this.total,
    this.score,
    required this.status,
  });
}

// ─── Biology Screen ──────────────────────────────────────────────────────────
class BiologyScreen extends StatefulWidget {
  const BiologyScreen({super.key});

  @override
  State<BiologyScreen> createState() => _BiologyScreenState();
}

class _BiologyScreenState extends State<BiologyScreen> {
  int _selectedTab = 0; // 0=All, 1=Remaining, 2=Completed

  final List<ChapterData> _chapters = const [
    ChapterData(
      title: 'Chapter 1: Cell Structure and Function',
      practiced: 50,
      total: 50,
      score: 92,
      status: ChapterStatus.completed,
    ),
    ChapterData(
      title: 'Chapter 2: Biological Molecules',
      practiced: 20,
      total: 50,
      score: 75,
      status: ChapterStatus.inProgress,
    ),
    ChapterData(
      title: 'Chapter 3: Enzymes',
      practiced: 0,
      total: 45,
      status: ChapterStatus.notStarted,
    ),
    ChapterData(
      title: 'Chapter 4: Bioenergetics',
      practiced: 0,
      total: 60,
      status: ChapterStatus.notStarted,
    ),
    ChapterData(
      title: 'Chapter 5: Nutrition',
      practiced: 0,
      total: 60,
      status: ChapterStatus.notStarted,
    ),
  ];

  List<ChapterData> get _filteredChapters {
    switch (_selectedTab) {
      case 1:
        return _chapters
            .where((c) => c.status != ChapterStatus.completed)
            .toList();
      case 2:
        return _chapters
            .where((c) => c.status == ChapterStatus.completed)
            .toList();
      default:
        return _chapters;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // App Bar
                _buildAppBar(),

                // Progress Bar
                _buildProgressBar(),

                // Tab Bar
                _buildTabBar(),

                // Chapter List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: _filteredChapters.length,
                    itemBuilder: (context, index) {
                      return _ChapterCard(chapter: _filteredChapters[index]);
                    },
                  ),
                ),
              ],
            ),

            // Floating Mock Button
            Positioned(bottom: 20, right: 16, child: _buildMockButton()),
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
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Text(
              'Biology',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text('🏆', style: TextStyle(fontSize: 14)),
                SizedBox(width: 4),
                Text(
                  '60% Mastered',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Progress Bar ──────────────────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: 0.60,
          backgroundColor: const Color(0xFFE0E0E0),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E8B57)),
          minHeight: 10,
        ),
      ),
    );
  }

  // ─── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    final tabs = ['All Chapters', 'Remaining', 'Completed'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: List.generate(tabs.length, (i) {
            final selected = _selectedTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1A3A6B)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tabs[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF666666),
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── Mock Button ───────────────────────────────────────────────────────────
  Widget _buildMockButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E5AAB), Color(0xFF2B74D8)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A3A6B).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🏆', style: TextStyle(fontSize: 18)),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Take a Grand',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Bio Mock',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }
}

// ─── Chapter Card ─────────────────────────────────────────────────────────────
class _ChapterCard extends StatelessWidget {
  final ChapterData chapter;

  const _ChapterCard({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Status Icon
          _buildStatusIcon(),
          const SizedBox(width: 14),

          // Title + Meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: Color(0xFF1A1A2E),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${chapter.practiced}/${chapter.total} MCQs Practiced',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF555555),
                  ),
                ),
                if (chapter.score != null)
                  Text(
                    'Score:  ${chapter.score}%',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF555555),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Action Button
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (chapter.status) {
      case ChapterStatus.completed:
        return Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFF2E8B57),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 26),
        );

      case ChapterStatus.inProgress:
        return SizedBox(
          width: 48,
          height: 48,
          child: CustomPaint(
            painter: _MiniCirclePainter(
              progress: chapter.practiced / chapter.total,
            ),
          ),
        );

      case ChapterStatus.notStarted:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDDDDDD), width: 2.5),
            color: const Color(0xFFF5F5F5),
          ),
        );
    }
  }

  Widget _buildActionButton() {
    switch (chapter.status) {
      case ChapterStatus.completed:
        return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E8B57),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Review',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        );

      case ChapterStatus.inProgress:
        return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE87722),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Resume',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        );

      case ChapterStatus.notStarted:
        return OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward_ios, size: 12),
          label: const Text(
            'Start',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1A3A6B),
            side: const BorderSide(color: Color(0xFFCCCCCC)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
    }
  }
}

// ─── Mini Circle Painter (for in-progress chapters) ──────────────────────────
class _MiniCirclePainter extends CustomPainter {
  final double progress;

  _MiniCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 5.0;
    const startAngle = -math.pi / 2;

    // Background
    final bgPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Blue progress
    final bluePaint = Paint()
      ..color = const Color(0xFF1E88E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress * 0.6,
      false,
      bluePaint,
    );

    // Orange accent
    final orangePaint = Paint()
      ..color = const Color(0xFFE87722)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + 2 * math.pi * progress * 0.6,
      2 * math.pi * progress * 0.4,
      false,
      orangePaint,
    );
  }

  @override
  bool shouldRepaint(_MiniCirclePainter old) => old.progress != progress;
}
