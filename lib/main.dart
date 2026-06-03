import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/firebase_options.dart';
import 'providers/auth_provider.dart';
import 'utils/theme.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carga variables de entorno desde .env (si existe)
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MiCuadernoDigitalApp());
}

class MiCuadernoDigitalApp extends StatelessWidget {
  const MiCuadernoDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..initialize(),
      child: Consumer<AuthProvider>(builder: (context, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mi Cuaderno Digital',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: auth.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: auth.isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : auth.user == null
                  ? const LoginView()
                  : const HomeView(),
        );
      }),
    );
  }
}
