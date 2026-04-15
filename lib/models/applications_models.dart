import 'package:flutter/material.dart';

enum ApplicationStatus {
  submitted,
  viewed,
  interview,
  rejected,
  offer,
  draft,
  closed,
  invitationDeclined,
}

extension ApplicationStatusX on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.viewed:
        return 'Viewed';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.offer:
        return 'Offer';
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.closed:
        return 'Closed';
      case ApplicationStatus.invitationDeclined:
        return 'Invitation declined';
    }
  }

  /// True for statuses that live in the Archive tab.
  bool get isArchived =>
      this == ApplicationStatus.closed ||
      this == ApplicationStatus.invitationDeclined;

  /// True for statuses that live in the Drafts tab.
  bool get isDraft => this == ApplicationStatus.draft;
}

class Application {
  final String id;
  final String jobId;
  final String appliedAt;
  final ApplicationStatus status;
  final String postedAgo;
  final String jobTitle;
  final String companyName;
  final String companyInitials;
  final Color companyLogoColor;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String category;
  final String location;
  final String workplaceType;
  final String employmentType;
  final String experienceLevel;

  const Application({
    required this.id,
    required this.jobId,
    required this.appliedAt,
    required this.status,
    required this.postedAgo,
    required this.jobTitle,
    required this.companyName,
    required this.companyInitials,
    required this.companyLogoColor,
    required this.salary,
    required this.matchPercentage,
    required this.matchLabel,
    required this.category,
    required this.location,
    required this.workplaceType,
    required this.employmentType,
    required this.experienceLevel,
  });
}

// ─── Invitation ───────────────────────────────────────────────────────────────

class Invitation {
  final String id;
  final String jobId;
  final String senderName;
  final String senderRole;
  final String senderInitials;
  final Color senderAvatarColor;
  final String companyName;
  final String message;
  final String postedAgo;
  final String jobTitle;
  final String companyInitials;
  final Color companyLogoColor;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String category;
  final String location;
  final String workplaceType;
  final String employmentType;
  final String experienceLevel;

  final bool isDismissed;
  final String dismissedAt;

  const Invitation({
    required this.id,
    required this.jobId,
    required this.senderName,
    required this.senderRole,
    required this.senderInitials,
    required this.senderAvatarColor,
    required this.companyName,
    required this.message,
    required this.postedAgo,
    required this.jobTitle,
    required this.companyInitials,
    required this.companyLogoColor,
    required this.salary,
    required this.matchPercentage,
    required this.matchLabel,
    required this.category,
    required this.location,
    required this.workplaceType,
    required this.employmentType,
    required this.experienceLevel,
    this.isDismissed = false,
    this.dismissedAt = '',
  });

  Invitation copyWith({bool? isDismissed, String? dismissedAt}) => Invitation(
        id: id,
        jobId: jobId,
        senderName: senderName,
        senderRole: senderRole,
        senderInitials: senderInitials,
        senderAvatarColor: senderAvatarColor,
        companyName: companyName,
        message: message,
        postedAgo: postedAgo,
        jobTitle: jobTitle,
        companyInitials: companyInitials,
        companyLogoColor: companyLogoColor,
        salary: salary,
        matchPercentage: matchPercentage,
        matchLabel: matchLabel,
        category: category,
        location: location,
        workplaceType: workplaceType,
        employmentType: employmentType,
        experienceLevel: experienceLevel,
        isDismissed: isDismissed ?? this.isDismissed,
        dismissedAt: dismissedAt ?? this.dismissedAt,
      );
}
