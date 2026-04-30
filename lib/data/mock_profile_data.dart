import '../models/profile_models.dart';

const mockProfileBasics = ProfileBasics(
  firstName: 'Christos',
  lastName: 'Ioannides',
  email: 'c.ioannidis@gmail.com',
  phone: '+30 123 456 78 90',
  dateOfBirth: '15-06-1995',
  gender: 'Male',
  citizenship: 'Greek',
  citizenshipCode: 'GR',
  residence: 'Chalkidiki, Greece',
  residenceCode: 'GR',
  status: 'Citizen',
  relocationReadiness: 'No',
);

const mockProfileAboutMe = ProfileAboutMe(
  bio:
      'Passionate Frontend Developer from Greece with extensive experience building responsive, user-friendly web applications. Skilled in HTML, CSS, JavaScript, and React, with a strong focus on clean, maintainable code and high performance. Enjoys collaborating with designers and backend teams to create seamless and engaging user experiences. Constantly learning new technologies, exploring modern frameworks, and improving workflows to deliver top-quality solutions.',
  videoUrl: 'https://example.com/christos-introduction.mp4',
);

const mockProfileHardSkills = [
  'Web Development',
  'HTML5 / CSS3',
  'JavaScript (ES6+)',
  'React / Vue / Angular',
  'Node.js / Express.js',
  'Webflow',
  'Github',
  'RESTful APIs',
  'GraphQL',
];

const mockProfileSoftSkills = [
  'Problem Solving',
  'Attention to Detail',
  'Teamwork',
  'Responsibility',
  'Continuous Learning',
  'Time Management',
  'Critical Thinking',
  'Communication',
  'Adaptability',
];

const mockCvSkills = [
  ...mockProfileHardSkills,
  ...mockProfileSoftSkills,
];

const mockProfileLanguages = [
  Language(language: 'English', proficiency: 'Conversational'),
  Language(language: 'Greek', proficiency: 'Fluent'),
];

const mockProfileCompetencies = {
  'Computer Skills': 'Professional',
  'Driving Licence': 'Category B (Manual & Automatic)',
  'Willing to relocate': 'No',
  'Work Permit': 'Not required',
};

const mockProfileSkills = ProfileSkills(
  hardSkills: mockProfileHardSkills,
  softSkills: mockProfileSoftSkills,
  languages: mockProfileLanguages,
  competencies: mockProfileCompetencies,
);

const mockProfileWorkExperiences = [
  WorkExperience(
    jobTitle: 'Web Developer',
    companyName: 'Amazing Dev',
    location: 'Athens, Greece',
    experienceLevel: 'Middle',
    workplace: 'On-site',
    jobType: 'Full time',
    startDate: '05-2024',
    currentlyWorkHere: true,
    summary:
        'Developed and maintained responsive web applications using React, JavaScript, and Node.js. Collaborated with designers and backend developers to deliver seamless user experiences. Improved site performance and implemented new features based on client requirements.',
  ),
  WorkExperience(
    jobTitle: 'Internship Web Developer',
    companyName: 'Canveaa',
    location: 'Athens, Greece',
    experienceLevel: 'Entry',
    workplace: 'On-site',
    jobType: 'Part time',
    startDate: '05-2014',
    endDate: '01-2019',
    summary:
        'Assisted in developing and maintaining web applications using HTML, CSS, and JavaScript. Collaborated with the team on frontend features, fixed bugs, and gained hands-on experience in responsive design and web development best practices.',
  ),
];

const mockProfileEducations = [
  Education(
    institutionName: 'National Technical University of Athens',
    fieldOfStudy: 'Computer Science',
    location: 'Athens, Greece',
    degreeType: "Bachelor's Degree",
    startDate: '09-2017',
    endDate: '07-2021',
  ),
];

const mockProfileFiles = [
  UploadedFile(name: 'CV_Christos.pdf', size: '1.4 Mb'),
  UploadedFile(name: 'Comp.Science_Diploma.pdf', size: '1.4 Mb'),
];

const mockProfileJobPreferences = ProfileJobPreferences(
  jobInterests: [
    JobInterest(title: 'Frontend Developer', category: 'IT & Development'),
  ],
  positionLevel: 'Middle (3 years)',
  jobType: 'Full-Time',
  workplace: 'On-site',
  expectedSalary: 21500,
);
