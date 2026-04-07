import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/application_detail_models.dart';
import 'profile_provider.dart';

final applicationDetailProvider =
    Provider.family<ApplicationDetail?, String>((ref, id) {
  final detail = _mockDetails[id];
  if (detail == null) return null;

  final basics = ref.watch(profileBasicsProvider).value;
  if (basics == null || basics.firstName.isEmpty) return detail;

  final candidate = detail.candidate.copyWith(
    name: '${basics.firstName} ${basics.lastName}'.trim(),
    email: basics.email.isNotEmpty ? basics.email : null,
    phone: basics.phone.isNotEmpty ? basics.phone : null,
    gender: basics.gender.isNotEmpty ? basics.gender : null,
    citizenship: basics.citizenship.isNotEmpty ? basics.citizenship : null,
    photoUrl: basics.photoUrl,
  );

  return detail.copyWith(candidate: candidate);
});

const _mockCandidate = CandidateProfile(
  name: '',
  title: 'Frontend Developer',
  availabilityLabel: 'Available for hire from Dec 2025',
  email: '',
  phone: '',
  gender: '',
  age: '45',
  citizenship: '',
  location: 'Thessaloniki, Greece',
  workplacePreference: 'On-site',
  employmentPreference: 'Full-Time',
  experienceLevel: 'Senior (25 years)',
  salaryExpectation: '1,500 € / month',
);

const _mockCompany = CompanyInfo(
  name: 'TechWave',
  industry: 'IT and Web Development',
  logoColor: Color(0xFF1E88E5),
  logoInitials: 'TW',
  teamSize: '100-150 members',
  location: 'Athens',
  description:
      'TechWave is a dynamic software company focused on creating modern web applications and digital tools. Our team values clean design, efficient code..',
);

final _mockDetails = <String, ApplicationDetail>{
  '2': ApplicationDetail(
    id: '2',
    appliedAt: 'You applied on 16 November, 11:30',
    statusLabel: 'Viewed',
    appliedWithNote:
        'You applied with your Ithaki CV. On average, employers review applications within the first week.',
    postedDate: 'Posted 10-11-2025',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechWave',
    companyLogoColor: const Color(0xFF1E88E5),
    companyLogoInitials: 'TW',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    location: 'Thessaloniki',
    jobType: 'Full-Time',
    industry: 'Transportation & Logistics',
    salaryRange: '€1,000–€1,400',
    workplace: 'Office',
    experienceLevel: 'Entry',
    languages: 'English, Greek',
    candidate: _mockCandidate,
    coverLetter:
        "I'm excited to apply for this position and start my career in your team. I'm eager to learn, contribute, and grow while working on real projects and improving my skills every day.",
    screeningQuestions: const [
      ScreeningQuestion(
        question:
            'What skills or experience make you a good fit for this role?',
        answer:
            "I'm a fast learner with a strong interest in front-end development. I've completed several courses and built small projects to practice HTML, CSS, and JavaScript. I enjoy solving problems, improving UI details, and learning modern frameworks to grow as a developer.",
      ),
      ScreeningQuestion(
        question: 'What type of work environment do you prefer?',
        answer: 'Hybrid',
      ),
      ScreeningQuestion(
        question: 'Which front-end tools have you used before?',
        answer: 'VS Code, Git/Github',
      ),
    ],
    company: _mockCompany,
  ),
  '1': const ApplicationDetail(
    id: '1',
    appliedAt: 'You applied today, 09:30',
    statusLabel: 'Submitted',
    appliedWithNote:
        'You applied with your Ithaki CV. On average, employers review applications within the first week.',
    postedDate: 'Posted 10-11-2025',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechWave',
    companyLogoColor: Color(0xFF1E88E5),
    companyLogoInitials: 'TW',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    location: 'Thessaloniki',
    jobType: 'Full-Time',
    industry: 'Transportation & Logistics',
    salaryRange: '€1,000–€1,400',
    workplace: 'Office',
    experienceLevel: 'Entry',
    languages: 'English, Greek',
    candidate: _mockCandidate,
    coverLetter:
        "I'm excited to apply for this position and start my career in your team. I'm eager to learn, contribute, and grow while working on real projects and improving my skills every day.",
    screeningQuestions: [
      ScreeningQuestion(
        question:
            'What skills or experience make you a good fit for this role?',
        answer:
            "I'm a fast learner with a strong interest in front-end development. I've completed several courses and built small projects to practice HTML, CSS, and JavaScript. I enjoy solving problems, improving UI details, and learning modern frameworks to grow as a developer.",
      ),
      ScreeningQuestion(
        question: 'What type of work environment do you prefer?',
        answer: 'Hybrid',
      ),
      ScreeningQuestion(
        question: 'Which front-end tools have you used before?',
        answer: 'VS Code, Git/Github',
      ),
    ],
    company: _mockCompany,
  ),
};
