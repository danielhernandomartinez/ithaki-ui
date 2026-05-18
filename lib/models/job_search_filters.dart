enum JobSearchFilter {
  location,
  industry,
  skills,
  jobType,
  workplace,
  experienceLevel,
  salary,
  travel,
}

enum JobSearchSort {
  mostRelevant,
  salaryHighToLow,
  salaryLowToHigh,
  dateRecent,
  dateLatest,
}

const defaultJobSearchFilters = {
  JobSearchFilter.location: <String>{},
  JobSearchFilter.industry: <String>{},
  JobSearchFilter.skills: <String>{},
  JobSearchFilter.jobType: <String>{},
  JobSearchFilter.workplace: <String>{},
  JobSearchFilter.experienceLevel: <String>{},
  JobSearchFilter.salary: <String>{},
  JobSearchFilter.travel: <String>{},
};
