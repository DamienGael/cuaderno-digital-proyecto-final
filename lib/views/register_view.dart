import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'alumno';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF050A16), Color(0xFF111827), Color(0xFF2E1A55)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x14FFFFFF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white24),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 10)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Crea tu cuenta', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 12),
                      const Text('Elige tu rol y accede a las funciones correctas.', style: TextStyle(fontSize: 14, color: Colors.white70), textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: const TextStyle(color: Colors.white70),
                          floatingLabelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0x22FFFFFF),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white70),
                          floatingLabelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0x22FFFFFF),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa tu email';
                          }
                          if (!value.contains('@')) {
                            return 'Ingresa un email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(color: Colors.white70),
                          floatingLabelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0x22FFFFFF),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu contraseña';
                          }
                          if (value.length < 6) {
                            return 'Mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _role,
                        dropdownColor: const Color(0xFF1F2937),
                        decoration: InputDecoration(
                          labelText: 'Rol',
                          labelStyle: const TextStyle(color: Colors.white70),
                          floatingLabelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0x22FFFFFF),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(value: 'alumno', child: Text('Alumno')),
                          DropdownMenuItem(value: 'profesor', child: Text('Profesor')),
                        ],
                        onChanged: (value) => setState(() => _role = value ?? 'alumno'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                final messenger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);
                                if (_formKey.currentState?.validate() != true) return;
                                setState(() => _isLoading = true);
                                final success = await authProvider.register(
                                  _nameController.text.trim(),
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _role,
                                );
                                if (!mounted) return;
                                setState(() => _isLoading = false);
                                if (success) {
                                  navigator.pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => const HomeView()),
                                    (route) => false,
                                  );
                                  messenger.showSnackBar(const SnackBar(content: Text('Cuenta creada con éxito'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
                                } else {
                                  final errorText = authProvider.errorMessage ?? 'Error de registro';
                                  messenger.showSnackBar(SnackBar(content: Text(errorText), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 3)));
                                }
                              },
                        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Registrar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
