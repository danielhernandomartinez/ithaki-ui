import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/employer_dashboard_models.dart';

List<JobPost> _mockActiveJobPosts() => [
      JobPost(
        id: '1',
        title: 'Sales Manager',
        category: 'Sales & Marketing',
        salary: '1,500 € /month',
        status: JobPostStatus.published,
        views: 169,
        candidates: 7,
        newCandidates: 10,
        createdAt: DateTime(2025, 11, 10),
      ),
      JobPost(
        id: '2',
        title: 'Transport Coordinator',
        category: 'Transportation & Logistics',
        salary: '1,500 € /month',
        status: JobPostStatus.boosted,
        views: 169,
        candidates: 7,
        createdAt: DateTime(2025, 11, 10),
        boostedUntil: 'till 01-12-2025',
      ),
      JobPost(
        id: '3',
        title: 'Truck Driver (CE License) - Athens',
        category: 'Transportation & Logistics',
        salary: '1,600 € /month',
        status: JobPostStatus.published,
        views: 169,
        candidates: 7,
        newCandidates: 10,
        createdAt: DateTime(2025, 11, 10),
      ),
      JobPost(
        id: '4',
        title: 'Logistics Operations Manager',
        category: 'Transportation & Logistics',
        salary: '2,200 € /month',
        status: JobPostStatus.draft,
        views: 0,
        candidates: 0,
        createdAt: DateTime(2025, 11, 10),
      ),
      JobPost(
        id: '5',
        title: 'Sales Manager',
        category: 'Sales',
        salary: '1,500 € /month',
        status: JobPostStatus.expired,
        views: 169,
        candidates: 7,
        createdAt: DateTime(2025, 11, 10),
      ),
      JobPost(
        id: '6',
        title: 'Frontend Developer',
        category: 'Technology',
        salary: '1,500 € /month',
        status: JobPostStatus.pendingApproval,
        views: 0,
        candidates: 0,
        createdAt: DateTime(2025, 11, 20),
      ),
      JobPost(
        id: '7',
        title: 'Office Manager',
        category: 'Administration & Management',
        salary: '1,500 € /month',
        status: JobPostStatus.paused,
        views: 0,
        candidates: 0,
        createdAt: DateTime(2025, 11, 20),
      ),
    ];

class EmployerDashboardNotifier
    extends AsyncNotifier<EmployerDashboardData> {
  @override
  Future<EmployerDashboardData> build() async {
    return EmployerDashboardData(
      userName: 'Maria',
      activeJobPostsCount: 10,
      archivedJobPostsCount: 10,
      applicationsCount: 10,
      invitationsCount: 10,
      showStats: true,
      activeJobPosts: _mockActiveJobPosts(),
      archivedJobPosts: [],
    );
  }

  void toggleStats() {
    state = state.whenData(
      (data) => data.copyWith(showStats: !data.showStats),
    );
  }
}

final employerDashboardProvider =
    AsyncNotifierProvider<EmployerDashboardNotifier, EmployerDashboardData>(
  EmployerDashboardNotifier.new,
);
