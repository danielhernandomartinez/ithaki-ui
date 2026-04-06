import 'package:flutter/material.dart';

class ScreeningQuestion {
  final String question;
  final String answer;
  const ScreeningQuestion({required this.question, required this.answer});
}

class CandidateProfile {
  final String name;
  final String title;
  final String? photoUrl;
  final String availabilityLabel;
  final String email;
  final String phone;
  final String gender;
  final String age;
  final String citizenship;
  final String location;
  final String workplacePreference;
  final String employmentPreference;
  final String experienceLevel;
  final String salaryExpectation;

  const CandidateProfile({
    required this.name,
    required this.title,
    this.photoUrl,
    required this.availabilityLabel,
    required this.email,
    required this.phone,
    required this.gender,
    required this.age,
    required this.citizenship,
    required this.location,
    required this.workplacePreference,
    required this.employmentPreference,
    required this.experienceLevel,
    required this.salaryExpectation,
  });
}

class CompanyInfo {
  final String name;
  final String industry;
  final Color logoColor;
  final String logoInitials;
  final String teamSize;
  final String location;
  final String description;

  const CompanyInfo({
    required this.name,
    required this.industry,
    required this.logoColor,
    required this.logoInitials,
    required this.teamSize,
    required this.location,
    required this.description,
  });
}

class ApplicationDetail {
  final String id;
  final String appliedAt;
  final String statusLabel;
  final String appliedWithNote;
  final String postedDate;
  final String jobTitle;
  final String companyName;
  final Color companyLogoColor;
  final String companyLogoInitials;
  final int matchPercentage;
  final String matchLabel;
  // Job details
  final String location;
  final String jobType;
  final String industry;
  final String salaryRange;
  final String workplace;
  final String experienceLevel;
  final String languages;
  // Candidate
  final CandidateProfile candidate;
  // Application content
  final String coverLetter;
  final List<ScreeningQuestion> screeningQuestions;
  // Company
  final CompanyInfo company;

  const ApplicationDetail({
    required this.id,
    required this.appliedAt,
    required this.statusLabel,
    required this.appliedWithNote,
    required this.postedDate,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogoColor,
    required this.companyLogoInitials,
    required this.matchPercentage,
    required this.matchLabel,
    required this.location,
    required this.jobType,
    required this.industry,
    required this.salaryRange,
    required this.workplace,
    required this.experienceLevel,
    required this.languages,
    required this.candidate,
    required this.coverLetter,
    required this.screeningQuestions,
    required this.company,
  });
}
