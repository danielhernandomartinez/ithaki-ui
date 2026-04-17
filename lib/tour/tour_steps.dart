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

const tourSteps = <TourStep>[
  TourStep(
    stepNumber: 1,
    title: 'Get on Track!',
    body: "Here you'll see jobs and courses selected for you, CV insights, and tools to help you start your job search.",
  ),
  TourStep(
    stepNumber: 2,
    title: 'Find a Job',
    body: 'Search for jobs by name or choose from categories below. You can find work near your city, or set other parameters to find the job you need.',
  ),
  TourStep(
    stepNumber: 3,
    title: 'Job Post',
    body: 'Each job card shows the main information — position, location, and salary. Tap the card to open full details and apply.',
  ),
  TourStep(
    stepNumber: 4,
    title: 'See how well this job fits for you',
    body: 'This part shows how well your experience and skills match the job. The higher the match — the better your chances to get hired.',
  ),
  TourStep(
    stepNumber: 5,
    title: 'Job Details',
    body: 'Read the full job description, requirements, and what the company offers before you apply.',
  ),
  TourStep(
    stepNumber: 6,
    title: 'Easy to Apply',
    body: 'Application is easy! Select your CV format and add a few words about yourself in the Cover Letter to increase your chances.',
  ),
  TourStep(
    stepNumber: 7,
    title: 'Track the Progress',
    body: "Once you apply for a job, you can find your response in 'My Applications'.",
  ),
  TourStep(
    stepNumber: 8,
    title: 'My Invitations',
    body: 'Employers can invite you directly. You have been invited to explore relevant job invitations from employers who found your profile interesting.',
  ),
  TourStep(
    stepNumber: 9,
    title: 'Get on Track!',
    body: 'You can open the invitation to read job details and accept the offer.',
  ),
  TourStep(
    stepNumber: 10,
    title: 'Build your Profile',
    body: 'Your profile shows your experience, skills, and contact info. A complete profile helps you get better job matches. You can edit or update it anytime.',
  ),
  TourStep(
    stepNumber: 11,
    title: 'Meet your Career Assistant',
    body: 'Pathfinder can help you improve your profile, find the right jobs, and answer your questions about work.',
  ),
  TourStep(
    stepNumber: 12,
    title: 'Learning Hub',
    body: 'Access courses and resources tailored to your career goals and the skills employers are looking for.',
  ),
  TourStep(
    stepNumber: 13,
    title: 'Get to know yourself better',
    body: 'Here you can take different assessments. Your results help employers better understand your strengths and working style.',
  ),
];
