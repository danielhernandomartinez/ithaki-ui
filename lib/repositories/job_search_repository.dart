import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_search_models.dart';

abstract class JobSearchRepository {
  int get totalJobs;
  int get savedCount;
  int get totalPages;
  List<JobListing> get jobs;
}

class MockJobSearchRepository implements JobSearchRepository {
  @override
  final int totalJobs = 1500;

  @override
  final int savedCount = 5;

  @override
  final int totalPages = 25;

  @override
  final List<JobListing> jobs = const [
    JobListing(
      jobTitle: 'Office Secretary',
      companyName: 'HelioForce Studio',
      companyInitials: 'HS',
      companyColor: Color(0xFF6B4EAA),
      salary: '2,000 \u20ac/ month',
      matchPercentage: 90,
      matchLabel: 'STRONG MATCH',
      category: 'Design and Creative',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Junior Front-End Developer',
      companyName: 'TechWave',
      companyInitials: 'TW',
      companyColor: Color(0xFF2E7D32),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 82,
      matchLabel: 'GREAT MATCH',
      category: 'IT and Web Development',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Pianist',
      companyName: 'Aegean Waves Hotel & Restaurant',
      companyInitials: 'AW',
      companyColor: Color(0xFF795548),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 35,
      matchLabel: 'WEAK MATCH',
      category: 'Arts, Entertainment and Music',
      location: 'Chalkida',
      workMode: 'On-site',
      employmentType: 'Part-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Cashier - Grocery Store',
      companyName: 'MarketGR',
      companyInitials: 'MG',
      companyColor: Color(0xFF1B5E20),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 78,
      matchLabel: 'GREAT MATCH',
      category: 'Sales',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Office Assistant',
      companyName: 'PixelPerfect Imaging',
      companyInitials: 'PP',
      companyColor: Color(0xFF37474F),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 0,
      matchLabel: 'NO BENEFICIARIES MATCH',
      category: 'Logistics and Supply Chain',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Junior Photographer',
      companyName: 'PixelPerfect Imaging',
      companyInitials: 'PP',
      companyColor: Color(0xFF37474F),
      salary: '1,800 \u20ac/ month',
      matchPercentage: 80,
      matchLabel: 'GREAT MATCH',
      category: 'Design and Creative',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Part-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Cashier',
      companyName: 'MarketGR',
      companyInitials: 'MG',
      companyColor: Color(0xFF1B5E20),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 65,
      matchLabel: 'GOOD MATCH',
      category: 'Customer Service',
      location: 'Thessaloniki',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Administrative Assistant',
      companyName: 'Global Solutions Corp',
      companyInitials: 'GS',
      companyColor: Color(0xFF0D47A1),
      salary: '2,800 \u20ac/ month',
      matchPercentage: 92,
      matchLabel: 'STRONG MATCH',
      category: 'Admin and Secretarial',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Data Entry Clerk',
      companyName: 'MyTech Solutions',
      companyInitials: 'MT',
      companyColor: Color(0xFF4A148C),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 68,
      matchLabel: 'GOOD MATCH',
      category: 'Admin and Secretarial',
      workMode: 'Remote',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      jobTitle: 'Marketing Intern',
      companyName: 'Creative Agency',
      companyInitials: 'CA',
      companyColor: Color(0xFFE65100),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 62,
      matchLabel: 'GOOD MATCH',
      category: 'Marketing',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
  ];
}

final jobSearchRepositoryProvider = Provider<JobSearchRepository>(
  (_) => MockJobSearchRepository(),
);
