import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class JoinClassView extends StatefulWidget {
  const JoinClassView({super.key});

  @override
  State<JoinClassView> createState() => _JoinClassViewState();
}

class _JoinClassViewState extends State<JoinClassView> {
  final TextEditingController _codeController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Unirse a clase')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _codeController, decoration: const InputDecoration(labelText: 'Código de clase')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                setState(() => _loading = true);
                try {
                  await FirestoreService().joinClass(_codeController.text.trim(), auth.user!.id);
                  if (!mounted) return;
                  messenger.showSnackBar(const SnackBar(content: Text('Te has unido a la clase'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
                  navigator.pop();
                } catch (e) {
                  if (!mounted) return;
                  messenger.showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 2)));
                }
                if (!mounted) return;
                setState(() => _loading = false);
              },
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Unirse'),
            ),
          ],
        ),
      ),
    );
  }
}
