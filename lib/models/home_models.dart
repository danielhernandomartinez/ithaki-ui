import 'package:flutter/material.dart';

class JobRecommendation {
  final String companyName;
  final String companyInitials;
  final Color companyColor;
  final String jobTitle;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String location;
  final String workMode;
  final String employmentType;
  final String level;

  const JobRecommendation({
    required this.companyName,
    required this.companyInitials,
    required this.companyColor,
    required this.jobTitle,
    required this.salary,
    required this.matchPercentage,
    required this.matchLabel,
    required this.location,
    required this.workMode,
    required this.employmentType,
    required this.level,
  });
}

class Course {
  final String title;
  final List<String> tags;
  final String description;
  final String format;
  final String duration;
  final String level;

  const Course({
    required this.title,
    required this.tags,
    required this.description,
    required this.format,
    required this.duration,
    required this.level,
  });
}

class NewsItem {
  final String tag;
  final String date;
  final String title;

  const NewsItem({
    required this.tag,
    required this.date,
    required this.title,
  });
}

class ProfileItem {
  final String label;
  final bool completed;
  const ProfileItem({required this.label, required this.completed});
}

class CvStats {
  final int views;
  final int? viewsChange;
  final int invitations;
  final int? invitationsChange;
  final int applicationsSent;
  final int interviews;

  const CvStats({
    required this.views,
    this.viewsChange,
    required this.invitations,
    this.invitationsChange,
    required this.applicationsSent,
    required this.interviews,
  });
}
