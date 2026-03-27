import 'package:flutter/material.dart';

class JobListing {
  final String id;
  final String jobTitle;
  final String companyName;
  final String companyInitials;
  final Color companyColor;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String category;
  final String? location;
  final String? workMode;
  final String? employmentType;
  final String? level;
  final String postedAgo;
  final bool isSaved;

  const JobListing({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.companyInitials,
    required this.companyColor,
    required this.salary,
    required this.matchPercentage,
    required this.matchLabel,
    required this.category,
    this.location,
    this.workMode,
    this.employmentType,
    this.level,
    this.postedAgo = 'Posted 1 day ago',
    this.isSaved = false,
  });
}
