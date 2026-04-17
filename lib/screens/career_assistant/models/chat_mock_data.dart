import 'chat_message.dart';

// ---------------------------------------------------------------------------
// Static mock content
// ---------------------------------------------------------------------------

const kInitialAiText =
    'Hi! I\'m Pathfinder, your Career assistant. I can help you find suitable jobs, set up filters. Just tell me what you\'re looking for — like: "I want to start my healthcare career" or "I need to do a training program from home."';

const kInitialChips = [
  'I don\'t know where to start, guide me through the system',
  'I want to speak with real Ithaki counselor',
];

const _kGuideResponse =
    'Sure — here\'s how things work here 👇\n\n'
    '1. Build your Talent Profile. Add your skills, interests, and experience.\n'
    '2. Explore Jobs. Browse open roles or let me recommend ones that fit your profile.\n'
    '3. Apply in one click. Use your saved CV or upload a new one each time.\n'
    '4. Grow with guidance. You can ask me for CV tips, interview practice, or suggestions to improve your profile.\n\n'
    'Would you like to start by completing your talent profile so we can find your best matches? 🌟\nQuick actions:';

const _kGuideChips = [
  'Analyze my profile and help me to complete it',
  'Help me find jobs recommended for me',
  'What should I learn next?',
];

const _kAnalyzeResponse =
    'Let me take a look at your profile...\n\nYour profile is 60% complete. Here\'s what you can add to improve your matches:\n'
    '• Work experience — add at least 1 role\n'
    '• Skills — add 5+ relevant skills\n'
    '• About Me — write a short summary\n\n'
    'Would you like help with any of these?';

const _kAnalyzeChips = [
  'Help me write my About Me',
  'What skills should I add?',
  'Help me find jobs recommended for me',
];

const _kDefaultResponse =
    'That\'s a great question! Based on your profile, I\'d suggest exploring roles in your area of interest. '
    'You can also complete your talent profile to get better job matches. '
    'Is there anything specific you\'d like help with?';

const _kDefaultChips = [
  'Help me find jobs recommended for me',
  'What should I learn next?',
];

final kArticleCards = [
  const ArticleData(
    title: 'How to Write a CV That Gets Noticed',
    excerpt:
        'Practical tips on structure, layout, and wording for a clean, professional CV. Includes a quick..',
    author: 'Ithaki Team',
    time: 'Today, 19:00',
  ),
  const ArticleData(
    title: 'Top Interview Questions & How to Answer Them',
    excerpt:
        'Prepare for your next interview with these commonly asked questions and expert answers..',
    author: 'Ithaki Team',
    time: 'Yesterday, 10:00',
  ),
];

final kJobCards = [
  const JobData(
    company: 'Athens Logistics Group',
    title: 'Delivery Truck Driver (Athens Region)',
    salary: '1,250 € / month',
    matchPct: 100,
    matchLabel: 'STRONG MATCH',
  ),
  const JobData(
    company: 'Metro Couriers SA',
    title: 'Warehouse Associate',
    salary: '950 € / month',
    matchPct: 85,
    matchLabel: 'GOOD MATCH',
  ),
];

const kHistoryToday = [
  'I want to become front-end developer..',
  'Cover letter tips',
  'Job search suggestions',
  'Rewrite my resume summary',
];

const kHistoryLast7 = [
  'Common HR questions',
  'Job search suggestions',
  'Salary negotiation tips',
  'Job search suggestions',
  'Job search suggestions',
];

// ---------------------------------------------------------------------------
// Response builder
// ---------------------------------------------------------------------------

ChatMessage buildAiResponse(String trigger) {
  final t = trigger.toLowerCase();
  if (t.contains('guide') || t.contains('start')) {
    return const ChatMessage(
      type: MsgType.ai,
      text: _kGuideResponse,
      variant: AiVariant.textWithChips,
      chips: _kGuideChips,
    );
  }
  if (t.contains('find jobs') || t.contains('recommended')) {
    return ChatMessage(
      type: MsgType.ai,
      text: 'I found a few roles that match your profile 👇',
      variant: AiVariant.jobs,
      jobs: kJobCards,
    );
  }
  if (t.contains('learn') || t.contains('article') || t.contains('cv')) {
    return ChatMessage(
      type: MsgType.ai,
      text: 'Here are some quick reads that can help you improve your chances:',
      variant: AiVariant.articles,
      articles: kArticleCards,
    );
  }
  if (t.contains('analyze') || t.contains('complete') || t.contains('profile')) {
    return const ChatMessage(
      type: MsgType.ai,
      text: _kAnalyzeResponse,
      variant: AiVariant.textWithChips,
      chips: _kAnalyzeChips,
    );
  }
  return const ChatMessage(
    type: MsgType.ai,
    text: _kDefaultResponse,
    variant: AiVariant.textWithChips,
    chips: _kDefaultChips,
  );
}
