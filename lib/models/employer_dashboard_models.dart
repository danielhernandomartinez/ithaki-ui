enum JobPostStatus {
  published,
  boosted,
  paused,
  draft,
  closed,
  expired,
  pendingApproval,
}

class JobPost {
  final String id;
  final String title;
  final String category;
  final String salary;
  final JobPostStatus status;
  final int views;
  final int candidates;
  final int newCandidates;
  final DateTime createdAt;
  final String? boostedUntil;
  final String? closedReason;

  const JobPost({
    required this.id,
    required this.title,
    required this.category,
    required this.salary,
    required this.status,
    required this.views,
    required this.candidates,
    this.newCandidates = 0,
    required this.createdAt,
    this.boostedUntil,
    this.closedReason,
  });

  JobPost copyWith({
    String? id,
    String? title,
    String? category,
    String? salary,
    JobPostStatus? status,
    int? views,
    int? candidates,
    int? newCandidates,
    DateTime? createdAt,
    String? boostedUntil,
    String? closedReason,
  }) =>
      JobPost(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category ?? this.category,
        salary: salary ?? this.salary,
        status: status ?? this.status,
        views: views ?? this.views,
        candidates: candidates ?? this.candidates,
        newCandidates: newCandidates ?? this.newCandidates,
        createdAt: createdAt ?? this.createdAt,
        boostedUntil: boostedUntil ?? this.boostedUntil,
        closedReason: closedReason ?? this.closedReason,
      );
}

class EmployerDashboardData {
  final String userName;
  final int activeJobPostsCount;
  final int archivedJobPostsCount;
  final int applicationsCount;
  final int invitationsCount;
  final bool showStats;
  final List<JobPost> activeJobPosts;
  final List<JobPost> archivedJobPosts;

  const EmployerDashboardData({
    required this.userName,
    required this.activeJobPostsCount,
    required this.archivedJobPostsCount,
    required this.applicationsCount,
    required this.invitationsCount,
    required this.showStats,
    required this.activeJobPosts,
    required this.archivedJobPosts,
  });

  EmployerDashboardData copyWith({
    String? userName,
    int? activeJobPostsCount,
    int? archivedJobPostsCount,
    int? applicationsCount,
    int? invitationsCount,
    bool? showStats,
    List<JobPost>? activeJobPosts,
    List<JobPost>? archivedJobPosts,
  }) =>
      EmployerDashboardData(
        userName: userName ?? this.userName,
        activeJobPostsCount: activeJobPostsCount ?? this.activeJobPostsCount,
        archivedJobPostsCount:
            archivedJobPostsCount ?? this.archivedJobPostsCount,
        applicationsCount: applicationsCount ?? this.applicationsCount,
        invitationsCount: invitationsCount ?? this.invitationsCount,
        showStats: showStats ?? this.showStats,
        activeJobPosts: activeJobPosts ?? this.activeJobPosts,
        archivedJobPosts: archivedJobPosts ?? this.archivedJobPosts,
      );
}
