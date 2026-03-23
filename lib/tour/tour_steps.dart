// lib/tour/tour_steps.dart

/// Describes one tooltip in the product tour.
class TourStep {
  final int stepNumber; // 1–13
  final String title;
  final String body;
  final TooltipPlacement placement;

  const TourStep({
    required this.stepNumber,
    required this.title,
    required this.body,
    required this.placement,
  });
}

enum TooltipPlacement { above, below, left, right }

const tourSteps = <TourStep>[
  TourStep(
    stepNumber: 1,
    title: 'Menu',
    body: 'Tap the menu icon to navigate between all sections of the app.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 2,
    title: 'Your Profile',
    body: 'Tap your avatar to access your profile, CV, settings, and log out.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 3,
    title: 'Start the Tour',
    body: 'This card lets you restart the product tour anytime you need a refresher.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 4,
    title: 'Welcome Message',
    body: 'Your personalised greeting — here you can see your daily summary.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 5,
    title: 'Complete Your Profile',
    body: 'Finish these steps to unlock full job-matching and employer visibility.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 6,
    title: 'Job Search',
    body: 'Search for jobs by title or keyword and filter by preference.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 7,
    title: 'Smart Recommendations',
    body: 'AI-powered job cards matched to your profile, skills, and location.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 8,
    title: 'Career Assistant',
    body: 'Not sure where to start? Ask the AI career assistant for guidance.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 9,
    title: 'CV Success Stats',
    body: 'Track how many employers viewed your CV, sent invitations, and more.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 10,
    title: 'Recommended Courses',
    body: 'Level up your skills with curated courses matched to your career goals.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 11,
    title: 'Latest News',
    body: 'Stay up to date with industry news, hiring trends, and career tips.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 12,
    title: 'Have Questions?',
    body: "Reach out to our support team — we're here to help you succeed.",
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 13,
    title: "You're all set!",
    body: "That's the full tour. Start exploring and take the next step in your career.",
    placement: TooltipPlacement.above,
  ),
];
