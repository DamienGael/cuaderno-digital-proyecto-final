import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';

class CreateTaskView extends StatefulWidget {
  final ClassModel classModel;
  const CreateTaskView({super.key, required this.classModel});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear tarea')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Título')),
            const SizedBox(height: 16),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descripción'), maxLines: 3),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Fecha límite'),
              subtitle: Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => _dueDate = picked);
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                setState(() => _loading = true);
                await FirestoreService().createTask(TaskModel(
                  id: '',
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  dueDate: _dueDate,
                  points: 100,
                  classId: widget.classModel.id,
                  professorId: widget.classModel.professorId,
                  professorName: widget.classModel.professorName,
                ));
                if (!mounted) return;
                setState(() => _loading = false);
                messenger.showSnackBar(const SnackBar(content: Text('Tarea creada correctamente'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
                navigator.pop();
              },
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
