import 'package:flutter/material.dart';

class JobReview {
  final String authorName;
  final String authorRole;
  final String authorInitials;
  final Color authorColor;
  final double rating;
  final String text;

  const JobReview({
    required this.authorName,
    required this.authorRole,
    required this.authorInitials,
    required this.authorColor,
    required this.rating,
    required this.text,
  });
}

class RecommendedJob {
  final String jobTitle;
  final String companyName;
  final String companyInitials;
  final Color companyColor;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String location;
  final String employmentType;

  const RecommendedJob({
    required this.jobTitle,
    required this.companyName,
    required this.companyInitials,
    required this.companyColor,
    required this.salary,
    required this.matchPercentage,
    required this.matchLabel,
    required this.location,
    required this.employmentType,
  });
}

class JobDetailCompany {
  final String name;
  final String industry;
  final Color logoColor;
  final String logoInitials;
  final String totalReviews;
  final double averageRating;
  final String description;

  const JobDetailCompany({
    required this.name,
    required this.industry,
    required this.logoColor,
    required this.logoInitials,
    required this.totalReviews,
    required this.averageRating,
    required this.description,
  });
}

class JobDetail {
  final String id;
  // Status card
  final String appliedAt;
  final String statusLabel;
  final String deadline;
  // Job header
  final String postedDate;
  final String jobTitle;
  final String companyName;
  final Color companyLogoColor;
  final String companyLogoInitials;
  // Match
  final int matchPercentage;
  final String matchLabel;
  // Details grid
  final String location;
  final String jobType;
  final String salaryRange;
  final String workplace;
  final String experienceLevel;
  final String languages;
  // Content sections
  final String description;
  final List<String> requirements;
  final List<String> skills;
  final String communication;
  final String niceToHave;
  final String whatWeOffer;
  // Reviews
  final List<JobReview> reviews;
  // Recommended
  final RecommendedJob recommended;
  // Company
  final JobDetailCompany company;
  // Sticky bar
  final String salary;

  const JobDetail({
    required this.id,
    required this.appliedAt,
    required this.statusLabel,
    required this.deadline,
    required this.postedDate,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogoColor,
    required this.companyLogoInitials,
    required this.matchPercentage,
    required this.matchLabel,
    required this.location,
    required this.jobType,
    required this.salaryRange,
    required this.workplace,
    required this.experienceLevel,
    required this.languages,
    required this.description,
    required this.requirements,
    required this.skills,
    required this.communication,
    required this.niceToHave,
    required this.whatWeOffer,
    required this.reviews,
    required this.recommended,
    required this.company,
    required this.salary,
  });
}
