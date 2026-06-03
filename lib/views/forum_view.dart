import 'package:flutter/material.dart';

class ForumView extends StatelessWidget {
  const ForumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foro de discusión')),
      body: const Center(child: Text('Foro por clase estará disponible aquí.')),
    );
  }
}
