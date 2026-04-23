import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/applications_provider.dart';
import '../providers/job_search_data_provider.dart';
import '../providers/tour_provider.dart';
import '../routes.dart';
import '../router.dart';
import 'tour_steps.dart';
import 'tour_skip_modal.dart';
import 'tour_complete_modal.dart';

/// Returns the screen-space [Rect] of a widget via its [GlobalKey].
Rect _getWidgetRect(GlobalKey key) {
  final ctx = key.currentContext;
  if (ctx == null) return Rect.zero;
  final box = ctx.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return Rect.zero;
  return box.localToGlobal(Offset.zero) & box.size;
}

// ── Spotlight painter ─────────────────────────────────────────────────────────

class _SpotlightPainter extends CustomPainter {
  final Rect spotlight;
  const _SpotlightPainter({required this.spotlight});

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Paint()..color = Colors.black.withValues(alpha: 0.55);
    if (spotlight == Rect.zero) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), scrim);
      return;
    }
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
          spotlight.inflate(6), const Radius.circular(14)));
    canvas.drawPath(path, scrim);
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.spotlight != spotlight;
}

// ── Dark tooltip ──────────────────────────────────────────────────────────────

class _TourTooltip extends StatelessWidget {
  final TourStep step;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TourTooltip({
    required this.step,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = step.stepNumber == kTourTotalSteps;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${step.stepNumber} Step / $kTourTotalSteps',
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 13,
              color: Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            step.title,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step.body,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: Color(0xFFCCCCCC),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _OutlineButton(
                  label: 'Skip and Close',
                  onTap: onSkip,
                ),
              ),
              const SizedBox(width: 10),
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

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ── Main overlay widget ───────────────────────────────────────────────────────

/// Wraps [child] and renders the tour overlay on top when the tour is active.
class TourOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final Map<int, GlobalKey> keys; // step number → GlobalKey

  const TourOverlay({super.key, required this.child, required this.keys});

  @override
  ConsumerState<TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends ConsumerState<TourOverlay> {
  String _jobSearchTourJobId() {
    final jobs = ref.read(jobSearchDataProvider).maybeWhen(
          data: (value) => value.jobs,
          orElse: () => null,
        );
    if (jobs != null && jobs.isNotEmpty) {
      return jobs.first.id;
    }
    return 'job-1';
  }

  String _tourInvitationId() {
    final invitations = ref.read(invitationsProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    if (invitations == null || invitations.isEmpty) {
      return 'inv-1';
    }
    for (final invitation in invitations) {
      if (!invitation.isDismissed) {
        return invitation.id;
      }
    }
    return invitations.first.id;
  }

  void _goToStep(int step) {
    switch (step) {
      case 1:
      case 12:
        IthakiRouter.router.go(Routes.home);
        return;
      case 2:
      case 3:
        IthakiRouter.router.go(Routes.jobSearch);
        return;
      case 4:
      case 5:
      case 6:
        IthakiRouter.router
            .go(Routes.jobSearchDetailFor(_jobSearchTourJobId()));
        return;
      case 7:
      case 8:
        IthakiRouter.router.go(Routes.myApplications);
        return;
      case 9:
        IthakiRouter.router
            .go(Routes.invitationJobDetailFor(_tourInvitationId()));
        return;
      case 10:
        IthakiRouter.router.go(Routes.profile);
        return;
      case 11:
        IthakiRouter.router.go(Routes.careerAssistant);
        return;
      case 13:
        IthakiRouter.router.go(Routes.assessments);
        return;
    }
  }

  Future<void> _advanceTour() async {
    final currentStep = ref.read(tourProvider).maybeWhen(
          data: (value) => value.currentStep,
          orElse: () => 0,
        );
    final nextStep = currentStep + 1;
    await ref.read(tourProvider.notifier).nextStep();
    if (!mounted || nextStep > kTourTotalSteps) {
      return;
    }
    _goToStep(nextStep);
  }

  @override
  Widget build(BuildContext context) {
    final navContext = IthakiRouter.navigatorKey.currentContext;
    ref.listen<AsyncValue<TourState>>(tourProvider, (prev, next) {
      if (navContext == null) return;
      if (next case AsyncData(:final value)) {
        final TourState? prevData = switch (prev) {
          AsyncData(:final value) => value,
          _ => null,
        };
        if (value.skipConfirmVisible &&
            !(prevData?.skipConfirmVisible ?? false)) {
          TourSkipModal.show(navContext);
        }
        if (value.completionVisible &&
            !(prevData?.completionVisible ?? false)) {
          TourCompleteModal.show(navContext);
        }
      }
    });

    return ref.watch(tourProvider).when(
          loading: () => widget.child,
          error: (_, __) => widget.child,
          data: (tourState) {
            final notifier = ref.read(tourProvider.notifier);
            final step = tourState.currentStep;
            final isActive = !tourState.tourCompleted &&
                step >= 1 &&
                step <= kTourTotalSteps;

            if (!isActive) return widget.child;

            final stepDef = tourSteps[step - 1];
            final targetKey = widget.keys[step];
            final targetRect =
                targetKey != null ? _getWidgetRect(targetKey) : Rect.zero;

            final bottomPad = MediaQuery.of(context).padding.bottom;
            // Tooltip always anchored to the bottom
            const tooltipBottomMargin = 16.0;
            final tooltipBottom = bottomPad + tooltipBottomMargin;

            return Stack(
              children: [
                widget.child,

                // Scrim + spotlight
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {}, // absorb taps
                    child: CustomPaint(
                      painter: _SpotlightPainter(spotlight: targetRect),
                    ),
                  ),
                ),

                // Tooltip — always at bottom
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: tooltipBottom,
                  child: Material(
                    color: Colors.transparent,
                    child: _TourTooltip(
                      step: stepDef,
                      onNext: _advanceTour,
                      onSkip: () => notifier.showSkipConfirm(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
  }
}
