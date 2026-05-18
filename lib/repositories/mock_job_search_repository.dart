import '../models/job_search_filters.dart';
import '../models/job_search_models.dart';
import '../utils/api_mappers.dart' as mapper;
import 'job_search_repository.dart';
import 'saved_jobs_store.dart';

class MockJobSearchRepository implements JobSearchRepository {
  MockJobSearchRepository(
      {SavedJobsStore savedJobsStore = const SavedJobsStore()})
      : _savedJobsStore = savedJobsStore;

  final SavedJobsStore _savedJobsStore;

  static final _allJobs = [
    JobListing(
      id: 'job-1',
      jobTitle: 'Office Secretary',
      companyName: 'HelioForce Studio',
      companyInitials: 'HS',
      companyColor: mapper.colorFromString('HelioForce Studio'),
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
      id: 'job-2',
      jobTitle: 'Junior Front-End Developer',
      companyName: 'TechWave',
      companyInitials: 'TW',
      companyColor: mapper.colorFromString('TechWave'),
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
      id: 'job-3',
      jobTitle: 'Pianist',
      companyName: 'Aegean Waves Hotel & Restaurant',
      companyInitials: 'AW',
      companyColor: mapper.colorFromString('Aegean Waves Hotel & Restaurant'),
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
      id: 'job-4',
      jobTitle: 'Cashier - Grocery Store',
      companyName: 'MarketGR',
      companyInitials: 'MG',
      companyColor: mapper.colorFromString('MarketGR'),
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
      id: 'job-5',
      jobTitle: 'Office Assistant',
      companyName: 'PixelPerfect Imaging',
      companyInitials: 'PP',
      companyColor: mapper.colorFromString('PixelPerfect Imaging'),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 0,
      matchLabel: 'NO BENEFICIARIES MATCH',
      category: 'Logistics and Supply Chain',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-6',
      jobTitle: 'Junior Photographer',
      companyName: 'PixelPerfect Imaging',
      companyInitials: 'PP',
      companyColor: mapper.colorFromString('PixelPerfect Imaging'),
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
      id: 'job-7',
      jobTitle: 'Cashier',
      companyName: 'MarketGR',
      companyInitials: 'MG',
      companyColor: mapper.colorFromString('MarketGR'),
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
      id: 'job-8',
      jobTitle: 'Administrative Assistant',
      companyName: 'Global Solutions Corp',
      companyInitials: 'GS',
      companyColor: mapper.colorFromString('Global Solutions Corp'),
      salary: '2,800 \u20ac/ month',
      matchPercentage: 92,
      matchLabel: 'STRONG MATCH',
      category: 'Admin and Secretarial',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-9',
      jobTitle: 'Data Entry Clerk',
      companyName: 'MyTech Solutions',
      companyInitials: 'MT',
      companyColor: mapper.colorFromString('MyTech Solutions'),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 68,
      matchLabel: 'GOOD MATCH',
      category: 'Admin and Secretarial',
      workMode: 'Remote',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-10',
      jobTitle: 'Marketing Intern',
      companyName: 'Creative Agency',
      companyInitials: 'CA',
      companyColor: mapper.colorFromString('Creative Agency'),
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

  @override
  Future<JobSearchResult> search({
    String query = '',
    Map<JobSearchFilter, Set<String>> filters = const {},
    JobSearchSort sort = JobSearchSort.dateRecent,
    int page = 1,
  }) async {
    final q = query.trim().toLowerCase();
    final filteredJobs = q.isEmpty
        ? _allJobs
        : _allJobs
            .where(
              (job) =>
                  job.jobTitle.toLowerCase().contains(q) ||
                  job.companyName.toLowerCase().contains(q) ||
                  job.category.toLowerCase().contains(q),
            )
            .toList();

    return JobSearchResult(
      jobs: filteredJobs,
      totalJobs: filteredJobs.length,
      totalPages: 25,
    );
  }

  @override
  Future<Set<String>> getSavedJobIds() => _savedJobsStore.load();

  @override
  Future<void> saveJob(String jobId) async {
    final savedIds = await _savedJobsStore.load();
    savedIds.add(jobId);
    await _savedJobsStore.save(savedIds);
  }

  @override
  Future<void> unsaveJob(String jobId) async {
    final savedIds = await _savedJobsStore.load();
    savedIds.remove(jobId);
    await _savedJobsStore.save(savedIds);
  }
}
