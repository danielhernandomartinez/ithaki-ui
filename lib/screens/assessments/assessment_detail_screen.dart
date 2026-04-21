import 'package:flutter/material.dart';

class AssessmentDetailScreen extends StatelessWidget {
  final String assessmentId;
  const AssessmentDetailScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Assessment Detail')));
}
