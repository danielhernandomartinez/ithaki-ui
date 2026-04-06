import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/applications_models.dart';

final applicationsProvider =
    NotifierProvider<ApplicationsNotifier, List<Application>>(
  ApplicationsNotifier.new,
);

class ApplicationsNotifier extends Notifier<List<Application>> {
  @override
  List<Application> build() => _mockApplications;
}

const _mockApplications = [
  Application(
    id: '1',
    appliedAt: 'Applied today 09:30',
    status: ApplicationStatus.submitted,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'Nexora',
    companyInitials: 'NX',
    companyLogoColor: Color(0xFF905CFF),
    salary: '2,000 € / month',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    category: 'Design and Creative',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
  ),
  Application(
    id: '2',
    appliedAt: 'Applied on 16 November, 11:30',
    status: ApplicationStatus.viewed,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechSound',
    companyInitials: 'TS',
    companyLogoColor: Color(0xFF1E88E5),
    salary: '1,500 € / month',
    matchPercentage: 80,
    matchLabel: 'GREAT MATCH',
    category: 'IT and Web Development',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
  ),
  Application(
    id: '3',
    appliedAt: 'Applied on 15 October, 11:30',
    status: ApplicationStatus.submitted,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'Nexora',
    companyInitials: 'NX',
    companyLogoColor: Color(0xFF905CFF),
    salary: '1,500 € / month',
    matchPercentage: 40,
    matchLabel: 'WEAK MATCH',
    category: 'Arts, Entertainment and Music',
    location: 'Chalkidiki',
    workplaceType: 'On-site',
    employmentType: 'Part-Time',
    experienceLevel: 'Entry',
  ),
];
