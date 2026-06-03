import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';
import '../models/submission_model.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SubmitTaskView extends StatefulWidget {
  final TaskModel taskModel;
  const SubmitTaskView({super.key, required this.taskModel});

  @override
  State<SubmitTaskView> createState() => _SubmitTaskViewState();
}

class _SubmitTaskViewState extends State<SubmitTaskView> {
  final TextEditingController _commentController = TextEditingController();
  File? _selectedFile;
  bool _loading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Entregar tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.taskModel.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: _commentController, decoration: const InputDecoration(labelText: 'Comentario')),            
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _pickFile,
              child: const Text('Seleccionar archivo'),
            ),
            if (_selectedFile != null) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(_selectedFile!.path.split('/').last)),
            const Spacer(),
            ElevatedButton(
              onPressed: _loading || _selectedFile == null ? null : () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                setState(() => _loading = true);
                try {
                  final fileUrl = await StorageService().uploadTaskFile(widget.taskModel.id, _selectedFile!);
                  await FirestoreService().submitTask(SubmissionModel(
                    id: '',
                    taskId: widget.taskModel.id,
                    studentId: auth.user!.id,
                    studentName: auth.user!.name,
                    comment: _commentController.text.trim(),
                    submittedAt: DateTime.now(),
                    fileUrl: fileUrl,
                    fileName: _selectedFile!.path.split('/').last,
                    graded: false,
                    grade: 0,
                    feedback: '',
                  ));
                  if (!mounted) return;
                  messenger.showSnackBar(const SnackBar(content: Text('Tarea entregada con éxito'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
                  navigator.pop();
                } catch (e) {
                  if (!mounted) return;
                  messenger.showSnackBar(SnackBar(content: Text('Error al subir archivo: ${e.toString()}'), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 2)));
                }
                if (!mounted) return;
                setState(() => _loading = false);
              },
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Enviar entrega'),
            ),
          ],
        ),
      ),
    );
  }
}
