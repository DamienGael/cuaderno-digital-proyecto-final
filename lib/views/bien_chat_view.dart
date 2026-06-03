import 'package:flutter/material.dart';
import '../services/bien_ai_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class BienChatView extends StatefulWidget {
  const BienChatView({super.key});

  @override
  State<BienChatView> createState() => _BienChatViewState();
}

class _BienChatViewState extends State<BienChatView> {
  final TextEditingController _questionController = TextEditingController();
  String _response = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente BIEN')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Pregunta a Bien como ${auth.user?.role ?? 'alumno'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(controller: _questionController, decoration: const InputDecoration(labelText: 'Escribe tu duda')),            
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                setState(() => _loading = true);
                _response = await BienAIService().ask(_questionController.text.trim(), auth.user?.role ?? 'alumno');
                setState(() => _loading = false);
              },
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Enviar pregunta'),
            ),
            const SizedBox(height: 24),
            Expanded(child: SingleChildScrollView(child: Text(_response))),
          ],
        ),
      ),
    );
  }
}
