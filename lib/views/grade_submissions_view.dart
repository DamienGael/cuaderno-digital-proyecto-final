import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/submission_card.dart';

class GradeSubmissionsView extends StatelessWidget {
  final String taskId;
  const GradeSubmissionsView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calificar entregas')),
      body: StreamBuilder(
        stream: FirestoreService().submissionsForTask(taskId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text('No hay entregas para calificar.'));
          }
          final submissions = snapshot.data as List;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: submissions.length,
            itemBuilder: (_, index) => SubmissionCard(submission: submissions[index]),
          );
        },
      ),
    );
  }
}
