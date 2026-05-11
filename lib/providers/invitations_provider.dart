import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/applications_models.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;

// ─── Repository ───────────────────────────────────────────────────────────────

abstract class InvitationsRepository {
  Future<List<Invitation>> getInvitations();
  Future<void> dismissInvitation(String invitationId);
}

class ApiInvitationsRepository implements InvitationsRepository {
  ApiInvitationsRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  static Invitation _parseInvitation(Map<String, dynamic> inv) {
    final id = inv['id']?.toString() ?? '';

    final senderRaw = inv['sender'] is Map<String, dynamic>
        ? inv['sender'] as Map<String, dynamic>
        : <String, dynamic>{};
    final senderName =
        senderRaw['name'] as String? ?? inv['senderName'] as String? ?? '';
    final senderRole =
        senderRaw['role'] as String? ?? inv['senderRole'] as String? ?? '';

    final companyRaw = inv['company'] is Map ? inv['company'] as Map : null;
    final companyName =
        companyRaw?['name'] as String? ?? inv['companyName'] as String? ?? '';

    final message = inv['message'] as String? ?? '';
    final posted = mapper.postedAgo(inv['createdAt'] ?? inv['postedAt']);

    final jobRaw = inv['job'] is Map<String, dynamic>
        ? inv['job'] as Map<String, dynamic>
        : inv;
    final jobId = (jobRaw['id'] ?? inv['jobId'])?.toString() ?? '';
    final jobTitle = jobRaw['title'] as String? ?? '';
    final salary = mapper.formatSalary(
        jobRaw['salaryMin'], jobRaw['salaryMax'], jobRaw['paymentTerm']);
    final location = jobRaw['location'] as String? ?? '';
    final workplaceType = mapper.enumTitle(jobRaw['workArrangement']);
    final employmentType = mapper.enumTitle(jobRaw['employmentType']);
    final experienceLevel = mapper.enumTitle(jobRaw['experienceLevel']);
    final category = mapper.enumTitle(jobRaw['industry']);

    final matchPct = (inv['matchPercentage'] as num?)?.toInt() ?? 0;
    final matchLabel = inv['matchLabel'] as String? ?? '';

    return Invitation(
      id: id,
      jobId: jobId,
      senderName: senderName,
      senderRole: senderRole,
      senderInitials: mapper.initials(senderName),
      senderAvatarColor: mapper.colorFromString(senderName),
      companyName: companyName,
      message: message,
      postedAgo: posted,
      jobTitle: jobTitle,
      companyInitials: mapper.initials(companyName),
      companyLogoColor: mapper.colorFromString(companyName),
      salary: salary,
      matchPercentage: matchPct,
      matchLabel: matchLabel,
      category: category,
      location: location,
      workplaceType: workplaceType,
      employmentType: employmentType,
      experienceLevel: experienceLevel,
    );
  }

  @override
  Future<List<Invitation>> getInvitations() async {
    final response = await _api.get('/job-seeker/me/invitations');
    if (response.statusCode != 200) {
      throw Exception('Failed to load invitations: ${response.statusCode}');
    }
    final body = jsonDecode(response.body);
    final items = mapper.extractList(body);
    return items
        .whereType<Map<String, dynamic>>()
        .map(_parseInvitation)
        .toList();
  }

  @override
  Future<void> dismissInvitation(String invitationId) async {
    await _api.postJson('/job-seeker/me/invitations/$invitationId/dismiss', {});
  }
}

class MockInvitationsRepository implements InvitationsRepository {
  final List<Invitation> _invitations = List.from(_mockInvitations);

  @override
  Future<List<Invitation>> getInvitations() async => List.from(_invitations);

  @override
  Future<void> dismissInvitation(String invitationId) async {
    final idx = _invitations.indexWhere((i) => i.id == invitationId);
    if (idx != -1) {
      final now = DateTime.now();
      final h = now.hour.toString().padLeft(2, '0');
      final m = now.minute.toString().padLeft(2, '0');
      _invitations[idx] = _invitations[idx].copyWith(
        isDismissed: true,
        dismissedAt: 'Today, $h:$m',
      );
    }
  }
}

final invitationsRepositoryProvider = Provider<InvitationsRepository>(
  (ref) => AppConfig.useMockData
      ? MockInvitationsRepository()
      : ApiInvitationsRepository(apiClient: ref.watch(apiClientProvider)),
);

// ─── Notifiers ────────────────────────────────────────────────────────────────

final invitationsProvider =
    AsyncNotifierProvider<InvitationsNotifier, List<Invitation>>(
  InvitationsNotifier.new,
);

class InvitationsNotifier extends AsyncNotifier<List<Invitation>> {
  @override
  Future<List<Invitation>> build() =>
      ref.read(invitationsRepositoryProvider).getInvitations();

  Future<void> dismiss(String invitationId) async {
    await ref
        .read(invitationsRepositoryProvider)
        .dismissInvitation(invitationId);
    state = AsyncData(
      state.value?.map((i) {
            if (i.id != invitationId) return i;
            return i.copyWith(isDismissed: true, dismissedAt: _nowLabel());
          }).toList() ??
          [],
    );
  }

  static String _nowLabel() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return 'Today, $h:$m';
  }
}

/// One-shot flag: set to `true` by the Decline Invitation dialog after the
/// user confirms. [MyApplicationsScreen] consumes it once and resets to false.
class InvitationDeclinedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  // ignore: use_setters_to_change_properties
  void set(bool value) => state = value;
}

final invitationDeclinedProvider =
    NotifierProvider<InvitationDeclinedNotifier, bool>(
  InvitationDeclinedNotifier.new,
);

// ─── Mock data ────────────────────────────────────────────────────────────────

final _mockInvitations = [
  Invitation(
    id: 'inv-1',
    jobId: 'job-6',
    senderName: 'Eleni Papadopoulou',
    senderRole: 'HR Manager',
    senderInitials: 'EP',
    senderAvatarColor: Color(0xFF905CFF),
    companyName: 'Nexora',
    message:
        "Hi Christos! I'm Eleni, HR manager of Nexora - digital agency (Apps, SaaS solutions, etc.). We are currently hiring 3 remote front-end developers. Please have a look at our open position.",
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyInitials: 'NX',
    companyLogoColor: Color(0xFF905CFF),
    salary: '2,000 € / month',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    category: 'IT and Web Development',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
  ),
  Invitation(
    id: 'inv-2',
    jobId: 'job-7',
    senderName: 'Irini Katsaros',
    senderRole: 'HR',
    senderInitials: 'IK',
    senderAvatarColor: Color(0xFF1E88E5),
    companyName: 'Athenis Technologies',
    message:
        "Hello Christos! Irini here, HR at Athenis Technologies (we create web & app solutions). We're expanding our remote team and hiring Front-End developers. Take a look at our open role — it might be a great match!",
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyInitials: 'AT',
    companyLogoColor: Color(0xFF0D47A1),
    salary: '1,800 € / month',
    matchPercentage: 85,
    matchLabel: 'GREAT MATCH',
    category: 'IT and Web Development',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
  ),
  // Pre-declined — shows in Archive tab
  Invitation(
    id: 'inv-3',
    jobId: 'job-8',
    senderName: 'Irini Katsaros',
    senderRole: 'HR',
    senderInitials: 'IK',
    senderAvatarColor: Color(0xFF1E88E5),
    companyName: 'Athenis Technologies',
    message:
        "Hello Christos! Irini here, HR at Athenis Technologies (we create web & app solutions). We're expanding our remote team and hiring Front-End developers. Take a look at our open role — it might be a great match!",
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyInitials: 'AT',
    companyLogoColor: Color(0xFF0D47A1),
    salary: '2,000 € / month',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    category: 'IT and Web Development',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
    isDismissed: true,
    dismissedAt: 'Today, 11:30',
  ),
];
