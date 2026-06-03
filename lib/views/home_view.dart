import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/class_model.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../widgets/class_card.dart';
import '../views/create_class_view.dart';
import '../views/join_class_view.dart';
import '../views/profile_view.dart';
import '../views/bien_chat_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final firestoreService = FirestoreService();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mis Clases'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BienChatView())),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1220), Color(0xFF171C35), Color(0xFF33245C)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: const Color(0x14FFFFFF),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bienvenido, ${auth.user?.name ?? ''}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text('Rol: ${auth.user?.role == 'profesor' ? 'Profesor' : 'Alumno'}', style: const TextStyle(fontSize: 16, color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text(
                        auth.user?.role == 'profesor'
                            ? 'Como profesor puedes crear clases y tareas para tus alumnos.'
                            : 'Como alumno puedes unirte a clases y entregar tareas.',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<ClassModel>>(
                  stream: auth.user?.role == 'profesor'
                      ? firestoreService.classesForProfessor(auth.user!.id)
                      : firestoreService.classesForUser(auth.user!.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          auth.user?.role == 'profesor'
                              ? 'Aún no tienes clases. Crea una para empezar.'
                              : 'Aún no estás en ninguna clase. Únete usando el botón.',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 3),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        final item = snapshot.data![index];
                        return ClassCard(classModel: item);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: auth.user?.role == 'profesor'
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateClassView())),
              child: const Icon(Icons.add),
            )
          : FloatingActionButton.extended(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JoinClassView())),
              icon: const Icon(Icons.group_add),
              label: const Text('Unirse'),
            ),
    );
  }
}
