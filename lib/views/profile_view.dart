import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  XFile? _photo;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    _nameController.text = auth.user?.name ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() => _photo = picked);
                }
              },
              child: CircleAvatar(
                radius: 48,
                backgroundImage: auth.user?.photoUrl != null ? NetworkImage(auth.user!.photoUrl!) : null,
                child: auth.user?.photoUrl == null ? const Icon(Icons.person, size: 48) : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(height: 16),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Nueva contraseña')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                final messenger = ScaffoldMessenger.of(context);
                setState(() => _loading = true);
                if (_photo != null) {
                  final fileUrl = await StorageService().uploadUserPhoto(auth.user!.id, File(_photo!.path));
                  await FirebaseFirestore.instance.collection('users').doc(auth.user!.id).update({'photoUrl': fileUrl});
                }
                if (_passwordController.text.isNotEmpty) {
                  await AuthService().currentUser?.updatePassword(_passwordController.text.trim());
                }
                if (!mounted) return;
                messenger.showSnackBar(const SnackBar(content: Text('Perfil actualizado'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
                setState(() => _loading = false);
              },
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
