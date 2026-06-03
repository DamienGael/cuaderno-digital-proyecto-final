import 'package:flutter/material.dart';
import '../models/submission_model.dart';

class SubmissionCard extends StatelessWidget {
  final SubmissionModel submission;
  const SubmissionCard({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(submission.studentName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(submission.comment),
            Text('Estado: ${submission.graded ? 'Calificada' : 'Pendiente'}'),
            if (submission.graded) Text('Nota: ${submission.grade}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {},
        ),
      ),
    );
  }
}
