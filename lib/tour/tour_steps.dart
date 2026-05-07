import '../l10n/app_localizations.dart';

/// Describes one step in the product tour.
class TourStep {
  final int stepNumber;
  final String title;
  final String body;

  const TourStep({
    required this.stepNumber,
    required this.title,
    required this.body,
  });
}

const int kTourTotalSteps = 13;

List<TourStep> tourSteps(AppLocalizations l) => <TourStep>[
      TourStep(
        stepNumber: 1,
        title: l.tourStep1Title,
        body: l.tourStep1Body,
      ),
      TourStep(
        stepNumber: 2,
        title: l.tourStep2Title,
        body: l.tourStep2Body,
      ),
      TourStep(
        stepNumber: 3,
        title: l.tourStep3Title,
        body: l.tourStep3Body,
      ),
      TourStep(
        stepNumber: 4,
        title: l.tourStep4Title,
        body: l.tourStep4Body,
      ),
      TourStep(
        stepNumber: 5,
        title: l.tourStep5Title,
        body: l.tourStep5Body,
      ),
      TourStep(
        stepNumber: 6,
        title: l.tourStep6Title,
        body: l.tourStep6Body,
      ),
      TourStep(
        stepNumber: 7,
        title: l.tourStep7Title,
        body: l.tourStep7Body,
      ),
      TourStep(
        stepNumber: 8,
        title: l.tourStep8Title,
        body: l.tourStep8Body,
      ),
      TourStep(
        stepNumber: 9,
        title: l.tourStep9Title,
        body: l.tourStep9Body,
      ),
      TourStep(
        stepNumber: 10,
        title: l.tourStep10Title,
        body: l.tourStep10Body,
      ),
      TourStep(
        stepNumber: 11,
        title: l.tourStep11Title,
        body: l.tourStep11Body,
      ),
      TourStep(
        stepNumber: 12,
        title: l.tourStep12Title,
        body: l.tourStep12Body,
      ),
      TourStep(
        stepNumber: 13,
        title: l.tourStep13Title,
        body: l.tourStep13Body,
      ),
    ];
