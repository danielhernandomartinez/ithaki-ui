import 'package:flutter/material.dart';

class AssessmentResultsScreen extends StatelessWidget {
  final String assessmentId;
  const AssessmentResultsScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Results')));
}
