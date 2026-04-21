import 'package:flutter/material.dart';

class AssessmentQuizScreen extends StatelessWidget {
  final String assessmentId;
  const AssessmentQuizScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Quiz')));
}
