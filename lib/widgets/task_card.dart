import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/class_model.dart';
import '../views/task_detail_view.dart';

class TaskCard extends StatelessWidget {
  final TaskModel taskModel;
  final ClassModel classModel;
  const TaskCard({super.key, required this.taskModel, required this.classModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(taskModel.title),
        subtitle: Text('Entrega: ${taskModel.dueDate.day}/${taskModel.dueDate.month}/${taskModel.dueDate.year}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailView(taskModel: taskModel, className: classModel.name)));
        },
      ),
    );
  }
}
