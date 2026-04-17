import 'package:flutter/material.dart';

class CompanyEvent {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final String address;
  final String registrationLink;

  const CompanyEvent({
    required this.id,
    required this.title,
    required this.date,
    this.time = '',
    this.location = '',
    this.description = '',
    this.address = '',
    this.registrationLink = '',
  });
}

class CompanyPost {
  final String id;
  final String content;
  final String postedAgo;
  final int likes;

  const CompanyPost({
    required this.id,
    required this.content,
    this.postedAgo = '',
    this.likes = 0,
  });
}

class CompanyVacancy {
  final String id;
  final String jobTitle;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String location;
  final String workMode;
  final String employmentType;
  final String category;
  final String postedAgo;

  const CompanyVacancy({
    required this.id,
    required this.jobTitle,
    required this.salary,
    this.matchPercentage = 0,
    this.matchLabel = '',
    this.location = '',
    this.workMode = '',
    this.employmentType = '',
    this.category = '',
    this.postedAgo = '',
  });
}

class CulturalMatch {
  final String label;   // 'High', 'Medium', 'Low'
  final List<String> sharedValues;
  final String description;

  const CulturalMatch({
    required this.label,
    this.sharedValues = const [],
    this.description = '',
  });
}

class CompanyProfile {
  final String id;
  final String name;
  final String industry;
  final Color logoColor;
  final String logoInitials;
  final String teamSize;
  final String location;
  final String phone;
  final String email;
  final String website;
  final String aboutText;
  final List<String> perks;
  final String odysseaRating;
  final CulturalMatch? culturalMatch;
  final List<CompanyEvent> events;
  final List<CompanyPost> posts;
  final List<CompanyVacancy> vacancies;

  const CompanyProfile({
    required this.id,
    required this.name,
    required this.industry,
    required this.logoColor,
    required this.logoInitials,
    this.teamSize = '',
    this.location = '',
    this.phone = '',
    this.email = '',
    this.website = '',
    this.aboutText = '',
    this.perks = const [],
    this.odysseaRating = '',
    this.culturalMatch,
    this.events = const [],
    this.posts = const [],
    this.vacancies = const [],
  });
}
