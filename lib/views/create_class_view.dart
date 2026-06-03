import 'dart:math';
import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../services/firestore_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class CreateClassView extends StatefulWidget {
  const CreateClassView({super.key});

  @override
  State<CreateClassView> createState() => _CreateClassViewState();
}

class _CreateClassViewState extends State<CreateClassView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _loading = false;

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.user!;
    return Scaffold(
      appBar: AppBar(title: const Text('Crear clase')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre de la clase')),
            const SizedBox(height: 16),
            TextField(controller: _subjectController, decoration: const InputDecoration(labelText: 'Materia')),
            const SizedBox(height: 16),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descripción'), maxLines: 3),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                setState(() => _loading = true);
                final code = _generateCode();
                final classModel = ClassModel(
                  id: '',
                  name: _nameController.text.trim(),
                  subject: _subjectController.text.trim(),
                  description: _descriptionController.text.trim(),
                  classCode: code,
                  professorId: user.id,
                  professorName: user.name,
                  students: [],
                );
                await FirestoreService().createClass(classModel);
                if (!mounted) return;
                setState(() => _loading = false);
                messenger.showSnackBar(SnackBar(content: Text('Clase creada con código $code'), backgroundColor: Colors.green, duration: const Duration(seconds: 2)));
                navigator.pop();
              },
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Crear clase'),
            ),
          ],
        ),
      ),
    );
  }
}
