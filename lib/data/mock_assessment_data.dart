import 'package:flutter/material.dart';

import '../models/assessment_models.dart';

AssessmentResult mockResultFor(String assessmentId) {
  return AssessmentResult(
    assessmentId: assessmentId,
    score: 78,
    maxScore: 100,
    level: 'Strong problem-solving skills',
    takenAt: DateTime(2026, 3, 3),
    skillBreakdowns: const [
      SkillBreakdown(name: 'Critical Thinking', score: 82.0, maxScore: 100.0),
      SkillBreakdown(name: 'Pattern Recognition', score: 75.0, maxScore: 100.0),
      SkillBreakdown(name: 'Logical Reasoning', score: 79.0, maxScore: 100.0),
      SkillBreakdown(name: 'Decision Speed', score: 70.0, maxScore: 100.0),
    ],
    keyInsights: const [
      'You excel at identifying patterns under pressure.',
      'Your logical reasoning is above average for this role category.',
      'Consider practising time-limited decision scenarios to improve speed.',
    ],
    previousResults: [
      AssessmentResult(
        assessmentId: assessmentId,
        score: 60,
        maxScore: 100,
        level: 'Developing',
        takenAt: DateTime(2025, 9, 1),
        skillBreakdowns: const [],
        keyInsights: const [],
      ),
      AssessmentResult(
        assessmentId: assessmentId,
        score: 41,
        maxScore: 100,
        level: 'Beginner',
        takenAt: DateTime(2024, 9, 1),
        skillBreakdowns: const [],
        keyInsights: const [],
      ),
    ],
  );
}

const List<Question> mockAssessmentQuestions = [
  SingleSelectQuestion(
    id: 'q1',
    text: 'Which of the following best describes your primary work style?',
    options: [
      'I prefer working independently on focused tasks',
      'I thrive in collaborative team environments',
      'I adapt easily between solo and team work',
      'I prefer leading and coordinating others',
    ],
  ),
  MultiSelectQuestion(
    id: 'q2',
    text: 'Which tools do you use regularly in your work? (Select up to 3)',
    options: [
      'Spreadsheets (Excel / Google Sheets)',
      'Project management software (Jira, Trello, etc.)',
      'Communication platforms (Slack, Teams)',
      'Design tools (Figma, Adobe XD)',
      'Code editors (VS Code, IntelliJ)',
      'Data analysis tools (Python, R)',
    ],
    maxSelections: 3,
  ),
  ImageSelectQuestion(
    id: 'q3',
    text: 'Looking at the scenario depicted, which response would you choose?',
    imageAsset: 'assets/images/ai_banner_bg.png',
    options: [
      'Escalate to a manager immediately',
      'Gather more information before acting',
      'Implement a quick interim solution',
      'Consult colleagues for their perspective',
    ],
  ),
  RangeNumberQuestion(
    id: 'q4',
    text: 'How comfortable are you working under tight deadlines?',
    min: 1,
    max: 5,
    minLabel: 'Very uncomfortable',
    maxLabel: 'Very comfortable',
  ),
  RangeSymbolQuestion(
    id: 'q5',
    text: 'How do you feel when you receive unexpected changes to a project?',
    options: [
      SymbolOption(emoji: '😞', label: 'Very stressed', color: Colors.red),
      SymbolOption(
        emoji: '😟',
        label: 'Somewhat stressed',
        color: Colors.orange,
      ),
      SymbolOption(emoji: '😐', label: 'Neutral', color: Colors.amber),
      SymbolOption(
        emoji: '🙂',
        label: 'Fairly comfortable',
        color: Colors.lightGreen,
      ),
      SymbolOption(
        emoji: '😄',
        label: 'Very comfortable',
        color: Colors.green,
      ),
    ],
  ),
];

const List<Assessment> mockAssessments = [
  Assessment(
    id: 'digital-skills',
    title: 'Digital Skills',
    category: 'Technology',
    description:
        'Assess your proficiency with digital tools and technologies used in modern workplaces.',
    iconName: 'assessment',
    questionCount: 5,
    durationMinutes: 8,
    language: 'English',
    status: AssessmentStatus.inProgress,
    usedFor: ['Tech roles', 'Administrative roles', 'Remote work positions'],
    beforeYouStart: [
      'Find a quiet place with no distractions.',
      'Read each question carefully before answering.',
    ],
  ),
  Assessment(
    id: 'decision-making',
    title: 'Decision Making',
    category: 'Cognitive',
    description:
        'Evaluate your ability to make sound decisions quickly and under pressure.',
    iconName: 'assessment',
    questionCount: 5,
    durationMinutes: 10,
    language: 'English',
    status: AssessmentStatus.inProgress,
    usedFor: ['Management roles', 'Leadership positions', 'Operations'],
    beforeYouStart: [
      'Answer honestly — there are no universally right answers.',
      'Trust your instincts on time-pressured questions.',
    ],
  ),
  Assessment(
    id: 'problem-solving',
    title: 'Problem Solving',
    category: 'Cognitive',
    description:
        'Test your analytical thinking and creative problem-solving capabilities.',
    iconName: 'assessment',
    questionCount: 5,
    durationMinutes: 12,
    language: 'English',
    status: AssessmentStatus.notStarted,
    usedFor: ['Engineering roles', 'Consulting', 'Research positions'],
    beforeYouStart: [
      'You can go back and change answers before submitting.',
      'There is no time limit — take your time.',
    ],
  ),
  Assessment(
    id: 'work-pace',
    title: 'Work Pace & Focus',
    category: 'Work Style',
    description:
        'Understand your preferred working rhythm and concentration style.',
    iconName: 'assessment',
    questionCount: 5,
    durationMinutes: 7,
    language: 'English',
    status: AssessmentStatus.notStarted,
    usedFor: ['All roles', 'Remote work', 'Self-management'],
    beforeYouStart: [
      'Reflect on your typical day at work.',
      'Choose the answer that best matches your natural tendencies.',
    ],
  ),
  Assessment(
    id: 'adaptability',
    title: 'Adaptability',
    category: 'Soft Skills',
    description:
        'Measure how well you respond to change, uncertainty, and new environments.',
    iconName: 'assessment',
    questionCount: 5,
    durationMinutes: 8,
    language: 'English',
    status: AssessmentStatus.completed,
    usedFor: [
      'Dynamic work environments',
      'Startups',
      'Cross-functional roles'
    ],
    beforeYouStart: [
      'Think about real situations you have faced when answering.',
    ],
  ),
  Assessment(
    id: 'teamwork',
    title: 'Teamwork & Collaboration',
    category: 'Soft Skills',
    description:
        'Explore your teamwork style and how you contribute to group success.',
    iconName: 'assessment',
    questionCount: 5,
    durationMinutes: 9,
    language: 'English',
    status: AssessmentStatus.completed,
    usedFor: ['Team-based roles', 'Customer-facing roles', 'Project work'],
    beforeYouStart: [
      'Consider how you actually behave in teams, not how you think you should.',
    ],
  ),
  Assessment(
    id: 'english',
    title: 'English Proficiency',
    category: 'Language',
    description:
        'Evaluate your reading, comprehension, and communication skills in English.',
    iconName: 'assessment',
    questionCount: 5,
    durationMinutes: 15,
    language: 'English',
    status: AssessmentStatus.completed,
    usedFor: [
      'International roles',
      'Client-facing positions',
      'Documentation roles'
    ],
    beforeYouStart: [
      'Complete this assessment without using a dictionary or translation tool.',
      'Read each passage carefully before answering comprehension questions.',
    ],
  ),
];
