import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/class_model.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../views/create_task_view.dart';

class ClassDetailView extends StatelessWidget {
  final ClassModel classModel;
  const ClassDetailView({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    return Scaffold(
      appBar: AppBar(title: Text(classModel.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classModel.subject, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(classModel.description),
                    const SizedBox(height: 8),
                    Text('Código: ${classModel.classCode}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tareas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<TaskModel>>(
                stream: firestoreService.tasksForClass(classModel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay tareas aún.'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final task = snapshot.data![index];
                      return TaskCard(taskModel: task, classModel: classModel);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Provider.of<AuthProvider>(context).user?.role == 'profesor' && Provider.of<AuthProvider>(context).user?.id == classModel.professorId
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CreateTaskView(classModel: classModel)));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
