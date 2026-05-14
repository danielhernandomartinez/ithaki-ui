import 'dart:convert';

import 'package:flutter/material.dart';

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

    final message = inv['message'] as String? ?? '';
    final posted = mapper.postedAgo(inv['createdAt'] ?? inv['postedAt']);
    final f = mapper.parseJobFields(inv);

    return Invitation(
      id: id,
      jobId: f.jobId,
      senderName: senderName,
      senderRole: senderRole,
      senderInitials: mapper.initials(senderName),
      senderAvatarColor: mapper.colorFromString(senderName),
      companyName: f.companyName,
      message: message,
      postedAgo: posted,
      jobTitle: f.jobTitle,
      companyInitials: f.companyInitials,
      companyLogoColor: f.companyLogoColor,
      salary: f.salary,
      matchPercentage: f.matchPercentage,
      matchLabel: f.matchLabel,
      category: f.category,
      location: f.location,
      workplaceType: f.workplaceType,
      employmentType: f.employmentType,
      experienceLevel: f.experienceLevel,
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

// ─── Notifiers ────────────────────────────────────────────────────────────────

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
