import 'package:flutter/material.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca Digital')),
      body: const Center(child: Text('Biblioteca de materiales aparecerá aquí.')),
    );
  }
}
