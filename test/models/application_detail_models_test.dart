import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/application_detail_models.dart';

void main() {
  group('ApplicationDetail.copyWith', () {
    test('copies every provided field and preserves omitted fields', () {
      const originalCandidate = CandidateProfile(
        name: 'Original Candidate',
        title: 'Junior Developer',
        availabilityLabel: 'Available now',
        email: 'original@example.com',
        phone: '+30 6900000000',
        gender: 'Female',
        age: '24',
        citizenship: 'Greek',
        location: 'Athens',
        workplacePreference: 'Hybrid',
        employmentPreference: 'Full-Time',
        experienceLevel: 'Entry',
        salaryExpectation: '1000 EUR',
      );
      const updatedCandidate = CandidateProfile(
        name: 'Updated Candidate',
        title: 'Frontend Developer',
        availabilityLabel: 'Available in two weeks',
        email: 'updated@example.com',
        phone: '+30 6911111111',
        gender: 'Female',
        age: '25',
        citizenship: 'Greek',
        location: 'Thessaloniki',
        workplacePreference: 'Remote',
        employmentPreference: 'Contract',
        experienceLevel: 'Mid',
        salaryExpectation: '1400 EUR',
      );
      const originalCompany = CompanyInfo(
        id: 'company-1',
        name: 'Original Co',
        industry: 'Retail',
        logoColor: Colors.purple,
        logoInitials: 'OC',
        teamSize: '10-20',
        location: 'Athens',
        description: 'Original company description.',
      );
      const updatedCompany = CompanyInfo(
        id: 'company-2',
        name: 'Updated Co',
        industry: 'Technology',
        logoColor: Colors.green,
        logoInitials: 'UC',
        teamSize: '50-100',
        location: 'Patras',
        description: 'Updated company description.',
      );
      const originalQuestions = [
        ScreeningQuestion(question: 'Original question?', answer: 'Original'),
      ];
      const updatedQuestions = [
        ScreeningQuestion(question: 'Updated question?', answer: 'Updated'),
      ];
      const detail = ApplicationDetail(
        id: '1',
        appliedAt: '2026-05-01',
        statusLabel: 'Applied',
        appliedWithNote: 'Applied with CV',
        postedDate: '2026-04-28',
        jobTitle: 'Junior Developer',
        companyName: 'Original Co',
        companyLogoColor: Colors.purple,
        companyLogoInitials: 'OC',
        matchPercentage: 70,
        matchLabel: 'Good match',
        location: 'Athens',
        jobType: 'Full-Time',
        industry: 'Retail',
        salaryRange: '900-1100 EUR',
        workplace: 'Hybrid',
        experienceLevel: 'Entry',
        languages: 'Greek',
        candidate: originalCandidate,
        coverLetter: 'Original cover letter.',
        screeningQuestions: originalQuestions,
        company: originalCompany,
      );

      final updated = detail.copyWith(
        id: '2',
        appliedAt: '2026-05-18',
        statusLabel: 'Viewed',
        appliedWithNote: 'Applied with profile',
        postedDate: '2026-05-10',
        jobTitle: 'Frontend Developer',
        companyName: 'Updated Co',
        companyLogoColor: Colors.green,
        companyLogoInitials: 'UC',
        matchPercentage: 95,
        matchLabel: 'Excellent match',
        location: 'Patras',
        jobType: 'Contract',
        industry: 'Technology',
        salaryRange: '1300-1500 EUR',
        workplace: 'Remote',
        experienceLevel: 'Mid',
        languages: 'Greek, English',
        candidate: updatedCandidate,
        coverLetter: 'Updated cover letter.',
        screeningQuestions: updatedQuestions,
        company: updatedCompany,
      );

      expect(updated.id, '2');
      expect(updated.appliedAt, '2026-05-18');
      expect(updated.statusLabel, 'Viewed');
      expect(updated.appliedWithNote, 'Applied with profile');
      expect(updated.postedDate, '2026-05-10');
      expect(updated.jobTitle, 'Frontend Developer');
      expect(updated.companyName, 'Updated Co');
      expect(updated.companyLogoColor, Colors.green);
      expect(updated.companyLogoInitials, 'UC');
      expect(updated.matchPercentage, 95);
      expect(updated.matchLabel, 'Excellent match');
      expect(updated.location, 'Patras');
      expect(updated.jobType, 'Contract');
      expect(updated.industry, 'Technology');
      expect(updated.salaryRange, '1300-1500 EUR');
      expect(updated.workplace, 'Remote');
      expect(updated.experienceLevel, 'Mid');
      expect(updated.languages, 'Greek, English');
      expect(updated.candidate, same(updatedCandidate));
      expect(updated.coverLetter, 'Updated cover letter.');
      expect(updated.screeningQuestions, same(updatedQuestions));
      expect(updated.company, same(updatedCompany));

      final candidateOnly = detail.copyWith(candidate: updatedCandidate);
      expect(candidateOnly.candidate, same(updatedCandidate));
      expect(candidateOnly.jobTitle, detail.jobTitle);
      expect(candidateOnly.company, same(originalCompany));
      expect(candidateOnly.screeningQuestions, same(originalQuestions));
    });
  });
}
