import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/submission_card.dart';
import '../services/firestore_service.dart';
import '../views/submit_task_view.dart';
import '../utils/helpers.dart';

class TaskDetailView extends StatelessWidget {
  final TaskModel taskModel;
  final String className;
  const TaskDetailView({super.key, required this.taskModel, required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(taskModel.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskModel.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Fecha límite: ${formatDate(taskModel.dueDate)}'),
            const SizedBox(height: 8),
            Text('Puntos: ${taskModel.points}'),
            const SizedBox(height: 16),
            if (Provider.of<AuthProvider>(context).user?.role == 'alumno')
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SubmitTaskView(taskModel: taskModel)));
                },
                child: const Text('Entregar tarea'),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  Provider.of<AuthProvider>(context).user?.role == 'profesor'
                      ? 'Los estudiantes pueden entregar tareas aquí. Como profesor puedes ver las entregas más abajo.'
                      : 'Solo los alumnos pueden entregar tareas.',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            const SizedBox(height: 24),
            const Text('Entregas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: StreamBuilder(
                stream: FirestoreService().submissionsForTask(taskModel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text('No hay entregas aún.'));
                  }
                  final submissions = snapshot.data as List;
                  return ListView.builder(
                    itemCount: submissions.length,
                    itemBuilder: (_, index) => SubmissionCard(submission: submissions[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
