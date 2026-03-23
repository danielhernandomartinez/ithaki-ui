// lib/tour/tour_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';
import 'tour_steps.dart';
import 'tour_skip_modal.dart';
import 'tour_complete_modal.dart';

/// Returns the screen-space [Rect] of any widget via its [GlobalKey].
/// Returns [Rect.zero] if the key has no context yet.
Rect _getWidgetRect(GlobalKey key) {
  final ctx = key.currentContext;
  if (ctx == null) return Rect.zero;
  final box = ctx.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return Rect.zero;
  final pos = box.localToGlobal(Offset.zero);
  return pos & box.size;
}

// ── Spotlight painter ─────────────────────────────────────────────────────────

class _SpotlightPainter extends CustomPainter {
  final Rect spotlight;
  const _SpotlightPainter({required this.spotlight});

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
          spotlight.inflate(8), const Radius.circular(12)));
    canvas.drawPath(path, scrim);
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.spotlight != spotlight;
}

// ── Tooltip bubble ────────────────────────────────────────────────────────────

class _TourTooltip extends StatelessWidget {
  final TourStep step;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TourTooltip({
    required this.step,
    required this.totalSteps,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = step.stepNumber == totalSteps;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              Text(
                '${step.stepNumber}/$totalSteps',
                style: const TextStyle(
                  fontSize: 12,
                  color: IthakiTheme.softGraphite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            step.body,
            style: IthakiTheme.bodyRegular.copyWith(
              color: IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onSkip,
                child: Text(
                  'Skip',
                  style: IthakiTheme.bodyRegular.copyWith(
                    color: IthakiTheme.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Expanded(
                child: IthakiButton(
                  isLast ? 'Finish' : 'Next',
                  onPressed: onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Main overlay widget ───────────────────────────────────────────────────────

/// Wraps [child] and renders the tour overlay on top when the tour is active.
///
/// Usage — in `main.dart` MaterialApp.router builder:
/// ```dart
/// builder: (context, child) => TourOverlay(keys: tourKeys, child: child!),
/// ```
class TourOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final Map<int, GlobalKey> keys; // step number → GlobalKey

  const TourOverlay({super.key, required this.child, required this.keys});

  @override
  ConsumerState<TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends ConsumerState<TourOverlay> {
  @override
  Widget build(BuildContext context) {
    // Drive skip/complete modals from state changes
    ref.listen<TourState>(tourProvider, (prev, next) {
      if (next.skipConfirmVisible && !(prev?.skipConfirmVisible ?? false)) {
        TourSkipModal.show(context);
      }
      if (next.completionVisible && !(prev?.completionVisible ?? false)) {
        TourCompleteModal.show(context);
      }
    });

    final tourState = ref.watch(tourProvider);
    final notifier = ref.read(tourProvider.notifier);
    final step = tourState.currentStep;
    final isActive = !tourState.tourCompleted && step >= 1 && step <= 13;

    if (!isActive) return widget.child;

    final stepDef = tourSteps[step - 1];
    final targetKey = widget.keys[step];
    final targetRect = targetKey != null ? _getWidgetRect(targetKey) : Rect.zero;
    final screenH = MediaQuery.of(context).size.height;
    const bubbleHeight = 160.0;
    const sidePadding = 24.0;

    // Decide tooltip placement
    final placeBelow = stepDef.placement == TooltipPlacement.below ||
        targetRect.top < screenH / 2;
    final tooltipTop = placeBelow
        ? targetRect.bottom + 16
        : targetRect.top - bubbleHeight - 16;

    return Stack(
      children: [
        widget.child,

        // Scrim + spotlight cutout
        Positioned.fill(
          child: GestureDetector(
            onTap: () {}, // absorb taps on scrim
            child: CustomPaint(
              painter: _SpotlightPainter(spotlight: targetRect),
            ),
          ),
        ),

        // Tooltip bubble
        Positioned(
          top: tooltipTop.clamp(
            MediaQuery.of(context).padding.top + 8,
            screenH - bubbleHeight - MediaQuery.of(context).padding.bottom - 8,
          ),
          left: sidePadding,
          right: sidePadding,
          child: _TourTooltip(
            step: stepDef,
            totalSteps: 13,
            onNext: () => notifier.nextStep(),
            onSkip: () => notifier.showSkipConfirm(),
          ),
        ),
      ],
    );
  }
}
