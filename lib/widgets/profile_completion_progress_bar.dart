import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class ProfileCompletionProgressBar extends StatelessWidget {
  final double progress;
  final double height;

  const ProfileCompletionProgressBar({
    super.key,
    required this.progress,
    this.height = 28,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final pct = (clampedProgress * 100).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _ProfileCompletionHatchPainter(
                  progress: clampedProgress,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: clampedProgress,
              child: Container(
                decoration: BoxDecoration(
                  color: IthakiTheme.badgeLime,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(height / 2),
                    right: clampedProgress == 1
                        ? Radius.circular(height / 2)
                        : Radius.zero,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  '$pct%',
                  style: IthakiTheme.bodySmallBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCompletionHatchPainter extends CustomPainter {
  final double progress;

  const _ProfileCompletionHatchPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = IthakiTheme.profileCompletionHatchStripe.withValues(alpha: 0.6)
      ..strokeWidth = 4;
    const spacing = 8.0;
    final overscan = size.height * 0.6;
    final lineHeight = size.height + (overscan * 2);
    final horizontalShift = lineHeight * 0.48;
    final hatchStart = size.width * progress;

    for (double x = hatchStart - lineHeight;
        x < size.width + lineHeight;
        x += spacing) {
      canvas.drawLine(
        Offset(x, size.height + overscan),
        Offset(x + horizontalShift, -overscan),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProfileCompletionHatchPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
