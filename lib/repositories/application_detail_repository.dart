import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/application_detail_models.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;

abstract class ApplicationDetailRepository {
  Future<ApplicationDetail?> getApplicationDetail(String id);
}

class ApiApplicationDetailRepository implements ApplicationDetailRepository {
  ApiApplicationDetailRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  @override
  Future<ApplicationDetail?> getApplicationDetail(String id) async {
    final response = await _api.get('/job-seeker/me/applications/$id');

    if (response.statusCode == 404) {
      return null;
    }
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load application detail: ${response.statusCode}',
      );
    }

    final body = jsonDecode(response.body);
    if (body is! Map) return null;

    return _parseApplicationDetail(body.cast<String, dynamic>());
  }

  static ApplicationDetail _parseApplicationDetail(Map<String, dynamic> json) {
    final jobFields = mapper.parseJobFields(json);
    final job = _map(json['job']) ?? json;
    final company = _map(job['company']) ?? _map(json['company']);
    final candidate = _map(json['candidate']) ??
        _map(json['applicant']) ??
        _map(json['jobSeeker']) ??
        _map(json['profile']);
    final screeningQuestions =
        _list(json['screeningQuestions'] ?? json['questions'])
            .map(_parseQuestion)
            .whereType<ScreeningQuestion>()
            .toList();
    final companyName = jobFields.companyName.isNotEmpty
        ? jobFields.companyName
        : _string(company?['name']);
    final companyKey = companyName.isNotEmpty ? companyName : jobFields.jobId;
    final matchPercentage =
        jobFields.matchPercentage > 0 ? jobFields.matchPercentage : 0;
    final matchLabel = jobFields.matchLabel.isNotEmpty
        ? jobFields.matchLabel
        : mapper.matchLabel(matchPercentage);

    return ApplicationDetail(
      id: _string(json['id']),
      appliedAt: mapper.apiDateString(json['createdAt'] ?? json['appliedAt']),
      statusLabel: _statusLabel(json['status']),
      appliedWithNote: _string(
        json['appliedWithNote'] ?? json['applicationNote'],
      ),
      postedDate: mapper.apiDateString(job['postedAt'] ?? job['createdAt']),
      jobTitle: jobFields.jobTitle,
      companyName: companyName,
      companyLogoColor: mapper.colorFromString(companyKey),
      companyLogoInitials: mapper.initials(companyName),
      matchPercentage: matchPercentage,
      matchLabel: matchLabel,
      location: jobFields.location,
      jobType: jobFields.employmentType,
      industry: jobFields.category,
      salaryRange: jobFields.salary,
      workplace: jobFields.workplaceType,
      experienceLevel: jobFields.experienceLevel,
      languages: _languages(job['languages'] ?? json['languages']),
      candidate: _parseCandidate(candidate),
      coverLetter: _string(
        json['coverLetter'] ?? json['motivationLetter'] ?? json['note'],
      ),
      screeningQuestions: screeningQuestions,
      company: CompanyInfo(
        id: _string(company?['id']),
        name: companyName,
        industry: jobFields.category,
        logoColor: mapper.colorFromString(companyKey),
        logoInitials: mapper.initials(companyName),
        teamSize: _string(company?['teamSize'] ?? company?['size']),
        location: _string(company?['location']),
        description: _string(company?['description']),
      ),
    );
  }

  static CandidateProfile _parseCandidate(Map<String, dynamic>? json) {
    final firstName = _string(json?['firstName']);
    final lastName = _string(json?['lastName']);
    final fallbackName = [firstName, lastName].where((s) => s.isNotEmpty).join(
          ' ',
        );

    return CandidateProfile(
      name: _string(json?['name'], fallback: fallbackName),
      title: _string(json?['title'] ?? json?['positionTitle']),
      photoUrl: _stringOrNull(json?['photoUrl'] ?? json?['photo']),
      availabilityLabel: _string(json?['availabilityLabel']),
      email: _string(json?['email']),
      phone: _string(json?['phone']),
      gender: mapper.enumTitle(json?['gender']),
      age: _string(json?['age']),
      citizenship: mapper.countryName(json?['citizenship']),
      location: _string(json?['location']),
      workplacePreference: mapper.enumTitle(json?['workplacePreference']),
      employmentPreference: mapper.enumTitle(json?['employmentPreference']),
      experienceLevel: mapper.enumTitle(json?['experienceLevel']),
      salaryExpectation: _string(json?['salaryExpectation']),
    );
  }

  static ScreeningQuestion? _parseQuestion(dynamic value) {
    final json = _map(value);
    if (json == null) return null;
    final question = _string(json['question'] ?? json['text'] ?? json['title']);
    final answer = _string(json['answer'] ?? json['response'] ?? json['value']);
    if (question.isEmpty && answer.isEmpty) return null;
    return ScreeningQuestion(question: question, answer: answer);
  }

  static String _statusLabel(dynamic status) {
    if (status is Map) {
      final title = mapper.enumTitle(status);
      if (title.isNotEmpty) return title;
    }

    final value = mapper.enumValue(status).toUpperCase();
    switch (value) {
      case 'VIEWED':
      case 'REVIEWED':
        return 'Viewed';
      case 'INTERVIEW':
        return 'Interview';
      case 'REJECTED':
        return 'Rejected';
      case 'OFFER':
      case 'ACCEPTED':
        return 'Offer';
      case 'DRAFT':
        return 'Draft';
      case 'CLOSED':
        return 'Closed';
      default:
        return 'Submitted';
    }
  }

  static String _languages(dynamic value) {
    final items = _list(value)
        .map((item) {
          if (item is Map) {
            return item['title'] ?? item['name'] ?? item['value'];
          }
          return item;
        })
        .map(_string)
        .where((item) => item.isNotEmpty)
        .toList();
    if (items.isNotEmpty) return items.join(', ');
    return _string(value);
  }

  static Map<String, dynamic>? _map(dynamic value) =>
      value is Map ? value.cast<String, dynamic>() : null;

  static List<dynamic> _list(dynamic value) => value is List ? value : const [];

  static String _string(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return fallback;
    return text;
  }

  static String? _stringOrNull(dynamic value) {
    final text = _string(value);
    return text.isEmpty ? null : text;
  }
}

class MockApplicationDetailRepository implements ApplicationDetailRepository {
  @override
  Future<ApplicationDetail?> getApplicationDetail(String id) async =>
      _mockDetails[id];
}

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
  salaryExpectation: '1,500 â‚¬ / month',
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
    appliedAt: '2025-11-16T11:30:00',
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
    salaryRange: 'â‚¬1,000â€“â‚¬1,400',
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
    appliedAt: '2026-05-18T09:30:00',
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
    salaryRange: 'â‚¬1,000â€“â‚¬1,400',
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
