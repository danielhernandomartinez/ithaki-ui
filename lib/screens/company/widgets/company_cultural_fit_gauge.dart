import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';

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
    switch (label.trim().toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
      default:
        return 1;
    }
  }

  List<Color> get _gaugeGradientColors {
    switch (label.trim().toLowerCase()) {
      case 'high':
        return [IthakiTheme.matchGradientHighStart, IthakiTheme.matchGreen];
      case 'medium':
        return [
          IthakiTheme.matchGradientGoodStart,
          IthakiTheme.matchGradientGoodEnd,
        ];
      case 'low':
      default:
        return [
          IthakiTheme.matchGradientWeakStart,
          IthakiTheme.matchGradientWeakEnd,
        ];
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
                gradientColors: _gaugeGradientColors,
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
                      AppLocalizations.of(context)!.culturalFitLabel,
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
  const _CompanyCulturalFitGaugePainter({
    required this.activeSegments,
    required this.gradientColors,
  });

  final int activeSegments;
  final List<Color> gradientColors;

  @override
  void paint(Canvas canvas, Size size) {
    const segmentCount = 3;
    const gapAngle = 0.36;
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
    final capInsetAngle =
        math.asin((strokeWidth / (radius * 2)).clamp(0.0, 1.0));
    final adjustedSweepAngle = sweepPerSegment - capInsetAngle * 0.35;

    if (adjustedSweepAngle <= 0) {
      return;
    }

    final visibleSegments = activeSegments.clamp(0, segmentCount).toInt();
    for (var index = 0; index < visibleSegments; index++) {
      final baseStartAngle = math.pi + index * (sweepPerSegment + gapAngle);
      final startAngle = baseStartAngle + capInsetAngle * 0.175;

      final segmentPath = _buildSegmentPath(
        center: center,
        radius: radius,
        thickness: strokeWidth,
        startAngle: startAngle,
        sweepAngle: adjustedSweepAngle,
      );
      final bounds = segmentPath.getBounds();
      final segmentPaint = Paint()
        ..shader = ui.Gradient.linear(
          bounds.topLeft,
          bounds.bottomRight,
          gradientColors,
        )
        ..isAntiAlias = true;

      canvas.drawPath(segmentPath, segmentPaint);

      canvas.save();
      canvas.clipPath(segmentPath);

      final stripePaint = Paint()
        ..color = IthakiTheme.backgroundWhite.withValues(alpha: 0.28)
        ..strokeWidth = math.max(2.5, strokeWidth * 0.16)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;
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
    if (oldDelegate.activeSegments != activeSegments ||
        oldDelegate.gradientColors.length != gradientColors.length) {
      return true;
    }

    for (var i = 0; i < gradientColors.length; i++) {
      if (oldDelegate.gradientColors[i] != gradientColors[i]) {
        return true;
      }
    }

    return false;
  }
}
