import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_detail_models.dart';

final jobDetailProvider =
    Provider.family<JobDetail?, String>((ref, id) => _mockDetails[id]);

const _mockCompany = JobDetailCompany(
  name: 'TechWave Group',
  industry: 'IT and Web Development',
  logoColor: Color(0xFF1E88E5),
  logoInitials: 'TW',
  totalReviews: '24 total reviews',
  averageRating: 4.5,
  description:
      'TechWave is a dynamic software company focused on creating modern web applications and digital tools. Our team values clean design, efficient code, and a collaborative culture.',
);

const _mockRecommended = RecommendedJob(
  jobTitle: 'Junior Front-End Developer',
  companyName: 'Nexora',
  companyInitials: 'NX',
  companyColor: Color(0xFF905CFF),
  salary: '2,000 € / month',
  matchPercentage: 100,
  matchLabel: 'STRONG MATCH',
  location: 'Athens',
  employmentType: 'Full-Time',
);

final _mockDetails = <String, JobDetail>{
  '1': const JobDetail(
    id: '1',
    appliedAt: 'You applied today, 09:30',
    statusLabel: 'Submitted',
    deadline: 'It has a deadline Application - 19 November 2025',
    postedDate: 'Posted 10-11-2025',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechWave Group',
    companyLogoColor: Color(0xFF1E88E5),
    companyLogoInitials: 'TW',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    location: 'Thessaloniki',
    jobType: 'Full-Time',
    salaryRange: '€1,000–€1,400',
    workplace: 'Office',
    experienceLevel: 'Entry',
    languages: 'English, Greek',
    description:
        'TechWave is looking for a motivated Junior Front-End Developer to join our growing team and collaborate closely with designers and developers to bring digital products to life.\n\nAs a Junior Front-End Developer you will work with HTML, CSS, JavaScript, and React. You will report to a Senior Developer who will guide and mentor you in best practices. The team uses modern tools with agile development.\n\nThis is a great opportunity for someone with a passion for front-end development and who is eager to grow in a professional setting.',
    requirements: [
      'Basic understanding of HTML, CSS, and JavaScript',
      'Basic understanding of any front-end framework is a plus',
      'Willingness to learn and grow in a fast-paced environment',
      'Experience with version control tools like Git or similar',
      'Familiarity with version control systems (Git or similar)',
      'Willingness to learn and accept feedback gracefully',
    ],
    skills: [
      'English',
      'Greek',
      'HTML',
      'CSS',
      'JavaScript',
      'React',
      'NEXT.js',
      'TypeScript',
    ],
    communication: 'Responsive Design',
    niceToHave:
        'Experience with Git or GitHub\nFamiliarity with any CSS framework (Bootstrap, Tailwind)\nBasic knowledge of RESTful APIs',
    whatWeOffer:
        'Cosy office in the city center\nCareer growth opportunities in line with company growth\nModern tech stack and a collaborative culture',
    reviews: [
      JobReview(
        authorName: 'Eva Karitsas',
        authorRole: 'IT — Employee',
        authorInitials: 'EK',
        authorColor: Color(0xFF905CFF),
        rating: 5.0,
        text: 'This role offers a good opportunity for growth and skill building.',
      ),
      JobReview(
        authorName: 'Nikos Papadakis',
        authorRole: 'IT — Employee',
        authorInitials: 'NP',
        authorColor: Color(0xFF1E88E5),
        rating: 4.0,
        text: 'Good team, friendly environment and interesting projects.',
      ),
    ],
    recommended: _mockRecommended,
    company: _mockCompany,
    salary: '1,500 € / month',
  ),
  '2': const JobDetail(
    id: '2',
    appliedAt: 'You applied on 16 November, 11:30',
    statusLabel: 'Viewed',
    deadline: 'It has a deadline Application - 19 November 2025',
    postedDate: 'Posted 10-11-2025',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechWave Group',
    companyLogoColor: Color(0xFF1E88E5),
    companyLogoInitials: 'TW',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    location: 'Thessaloniki',
    jobType: 'Full-Time',
    salaryRange: '€1,000–€1,400',
    workplace: 'Office',
    experienceLevel: 'Entry',
    languages: 'English, Greek',
    description:
        'TechWave is looking for a motivated Junior Front-End Developer to join our growing team and collaborate closely with designers and developers to bring digital products to life.\n\nAs a Junior Front-End Developer you will work with HTML, CSS, JavaScript, and React. You will report to a Senior Developer who will guide and mentor you.',
    requirements: [
      'Basic understanding of HTML, CSS, and JavaScript',
      'Basic understanding of any front-end framework is a plus',
      'Willingness to learn and grow in a fast-paced environment',
      'Experience with version control tools like Git or similar',
    ],
    skills: ['English', 'Greek', 'HTML', 'CSS', 'JavaScript', 'React'],
    communication: 'Responsive Design',
    niceToHave:
        'Experience with Git or GitHub\nFamiliarity with any CSS framework',
    whatWeOffer:
        'Cosy office in the city center\nCareer growth opportunities in line with company growth',
    reviews: [
      JobReview(
        authorName: 'Eva Karitsas',
        authorRole: 'IT — Employee',
        authorInitials: 'EK',
        authorColor: Color(0xFF905CFF),
        rating: 5.0,
        text: 'This role offers a good opportunity for growth and skill building.',
      ),
    ],
    recommended: _mockRecommended,
    company: _mockCompany,
    salary: '1,500 € / month',
  ),
};
