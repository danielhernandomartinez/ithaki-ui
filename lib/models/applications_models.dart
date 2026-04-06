import 'package:flutter/material.dart';

enum ApplicationStatus { submitted, viewed, interview, rejected, offer }

extension ApplicationStatusLabel on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.viewed:
        return 'Viewed';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.offer:
        return 'Offer';
    }
  }
}

class Application {
  final String id;
  final String appliedAt;
  final ApplicationStatus status;
  final String postedAgo;
  final String jobTitle;
  final String companyName;
  final String companyInitials;
  final Color companyLogoColor;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String category;
  final String location;
  final String workplaceType;
  final String employmentType;
  final String experienceLevel;

  const Application({
    required this.id,
    required this.appliedAt,
    required this.status,
    required this.postedAgo,
    required this.jobTitle,
    required this.companyName,
    required this.companyInitials,
    required this.companyLogoColor,
    required this.salary,
    required this.matchPercentage,
    required this.matchLabel,
    required this.category,
    required this.location,
    required this.workplaceType,
    required this.employmentType,
    required this.experienceLevel,
  });
}
