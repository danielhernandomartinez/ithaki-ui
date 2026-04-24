import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class CompanyCulturalFitGauge extends StatelessWidget {
  const CompanyCulturalFitGauge({
    super.key,
    required this.label,
    this.width = 244,
    this.height = 146,
    this.titleFontSize,
    this.subtitleFontSize,
    this.labelWidthFactor,
    this.textAlignment,
  });

  final String label;
  final double width;
  final double height;
  final double? titleFontSize;
  final double? subtitleFontSize;
  final double? labelWidthFactor;
  final Alignment? textAlignment;

  int get _activeSegments {
    switch (label.toLowerCase()) {
      case 'high':
        return 4;
      case 'medium':
        return 3;
      case 'low':
        return 2;
      default:
        return 1;
    }
  }

  String get _displayLabel {
    final normalized = label.trim();
    if (normalized.isEmpty) {
      return 'Low';
    }

    return normalized[0].toUpperCase() + normalized.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = width <= 140 || height <= 90;
    final resolvedLabelWidth =
        width * (labelWidthFactor ?? (isCompact ? 0.76 : 0.42));
    final resolvedTitleFontSize = titleFontSize ?? (isCompact ? 16.0 : 24.0);
    final resolvedSubtitleFontSize =
        subtitleFontSize ?? (isCompact ? 8.5 : 12.0);
    final textSpacing = isCompact ? 4.0 : 8.0;
    final resolvedTextAlignment = textAlignment ??
        (isCompact ? const Alignment(0, 0.5) : const Alignment(0, 0.42));

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _CompanyCulturalFitGaugePainter(
                activeSegments: _activeSegments,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: resolvedTextAlignment,
              child: SizedBox(
                width: resolvedLabelWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _displayLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: IthakiTheme.bodySmall.copyWith(
                        fontSize: resolvedTitleFontSize,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: IthakiTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: textSpacing),
                    Text(
                      'Cultural Fit',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: IthakiTheme.bodySmall.copyWith(
                        fontSize: resolvedSubtitleFontSize,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: IthakiTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyCulturalFitGaugePainter extends CustomPainter {
  const _CompanyCulturalFitGaugePainter({required this.activeSegments});

  final int activeSegments;

  @override
  void paint(Canvas canvas, Size size) {
    const segmentCount = 4;
    const gapAngle = 0.24;
    const capTrimAngle = 0.08;
    const verticalInset = 6.0;
    final strokeWidth =
        math.min(32.0, math.min(size.width * 0.22, size.height * 0.42));

    final center = Offset(size.width / 2, size.height - verticalInset);
    final radius = math.min(
      (size.width - strokeWidth) / 2,
      size.height - strokeWidth / 2 - verticalInset,
    );
    final sweepPerSegment =
        (math.pi - gapAngle * (segmentCount - 1)) / segmentCount;

    for (var index = 0; index < segmentCount; index++) {
      final baseStartAngle = math.pi + index * (sweepPerSegment + gapAngle);
      final startAngle = baseStartAngle + capTrimAngle / 2;
      final adjustedSweepAngle = sweepPerSegment - capTrimAngle;
      final isActive = index < activeSegments;

      final segmentPath = _buildSegmentPath(
        center: center,
        radius: radius,
        thickness: strokeWidth,
        startAngle: startAngle,
        sweepAngle: adjustedSweepAngle,
      );

      final sweepPath = Path()
        ..addArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          adjustedSweepAngle,
        );

      final basePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = isActive
            ? IthakiTheme.matchGreen.withValues(alpha: 0.72)
            : IthakiTheme.softGray.withValues(alpha: 0.75)
        ..isAntiAlias = true;

      canvas.drawPath(sweepPath, basePaint);

      canvas.save();
      canvas.clipPath(segmentPath);

      final stripePaint = Paint()
        ..color = isActive
            ? IthakiTheme.backgroundWhite.withValues(alpha: 0.28)
            : IthakiTheme.backgroundWhite.withValues(alpha: 0.16)
        ..strokeWidth = math.max(2.5, strokeWidth * 0.16)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      final bounds = segmentPath.getBounds();
      final stripeSpacing = math.max(7.0, strokeWidth * 0.38);

      for (double x = bounds.left - bounds.height;
          x <= bounds.right + bounds.height;
          x += stripeSpacing) {
        canvas.drawLine(
          Offset(x, bounds.bottom + strokeWidth * 0.56),
          Offset(x + bounds.height, bounds.top - strokeWidth * 0.56),
          stripePaint,
        );
      }

      canvas.restore();
    }
  }

  Path _buildSegmentPath({
    required Offset center,
    required double radius,
    required double thickness,
    required double startAngle,
    required double sweepAngle,
  }) {
    final outerRadius = radius + thickness / 2;
    final innerRadius = radius - thickness / 2;
    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);
    final endAngle = startAngle + sweepAngle;
    final startMidpoint = Offset(
      center.dx + math.cos(startAngle) * radius,
      center.dy + math.sin(startAngle) * radius,
    );
    final endMidpoint = Offset(
      center.dx + math.cos(endAngle) * radius,
      center.dy + math.sin(endAngle) * radius,
    );

    final ringSlice = Path()
      ..addArc(outerRect, startAngle, sweepAngle)
      ..arcTo(innerRect, endAngle, -sweepAngle, false)
      ..close();

    final startCap = Path()
      ..addOval(Rect.fromCircle(center: startMidpoint, radius: thickness / 2));
    final endCap = Path()
      ..addOval(Rect.fromCircle(center: endMidpoint, radius: thickness / 2));

    final roundedStart =
        Path.combine(ui.PathOperation.union, ringSlice, startCap);

    return Path.combine(ui.PathOperation.union, roundedStart, endCap);
  }

  @override
  bool shouldRepaint(covariant _CompanyCulturalFitGaugePainter oldDelegate) {
    return oldDelegate.activeSegments != activeSegments;
  }
}
