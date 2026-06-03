# MI CUADERNO DIGITAL

Aplicación educativa Flutter con Firebase, asistente IA "Bien", y gestión completa de clases, tareas y entregas.

## ✨ Características

- **Autenticación**: Registro y login con email/contraseña
- **Roles**: Profesor (crear clases y tareas) y Alumno (unirse a clases y entregar tareas)
- **Clases**: Los profesores crean clases con código único
- **Tareas**: Los profesores crean tareas con fechas límite y puntos
- **Entregas**: Los alumnos suben archivos como entrega de tareas
- **Asistente IA "Bien"**: Preguntas con respuestas por Gemini (50 preguntas/día)
- **Tema oscuro/claro**: Cambia entre temas con colores estéticos modernos
- **Verificación de email**: Se envía email de verificación al registrarse
- **Interfaz moderna**: Diseño limpio, responsive y accesible

## 🚀 Inicio rápido

### 1. Configuración previa

Necesitas:
- Flutter SDK instalado (`flutter --version` para verificar)
- Firebase CLI (`npm install -g firebase-tools`)
- Un proyecto Firebase creado en Console

### 2. Clonar y configurar

```bash
# Abre la carpeta del proyecto
cd "Proyecto final"

# Instala dependencias
flutter pub get

# Crea archivo .env desde .env.example
copy .env.example .env

# Edita .env y agrega tu API Key de Gemini
# BIEN_API_KEY=tu_api_key_aqui
```

### 3. Configura Firebase

```bash
flutterfire configure
```

Esto genera automáticamente `lib/core/config/firebase_options.dart` con tus credenciales.

### 4. Crea las colecciones de Firestore

En Firebase Console, crea estas colecciones vacías:
- `users`
- `classes`
- `submissions`

Las subcol ecciones se crean automáticamente.

### 5. Publicar reglas de Firestore y Storage

En Firebase Console:
- **Firestore → Reglas**: Reemplaza con las reglas del archivo `firestore_rules.txt`
- **Storage → Reglas**: Reemplaza con las reglas del archivo `storage_rules.txt`

### 6. Ejecutar

```bash
# Android emulador o dispositivo físico
flutter run

# Chrome (web)
flutter run -d chrome

# iOS (macOS required)
flutter run -d ios
```

## 📱 Cómo usar

### Como Profesor
1. Regístrate con rol "Profesor"
2. Presiona el botón `+` para crear una clase
3. Comparte el código con tus alumnos
4. Desde la clase, crea tareas con título, descripción y fecha
5. Los alumnos pueden entregar tareas

### Como Alumno
1. Regístrate con rol "Alumno"
2. Usa "Unirse" para entrar a una clase con el código
3. Desde la clase, ves y entregas tareas
4. Los profesores revisan tus entregas

### Asistente IA "Bien"
- Presiona el ícono de chat
- Haz preguntas educativas (máx. 50/día)
- Bien responde según tu rol

### Tema oscuro
- Ve a Perfil (ícono persona)
- Cambia entre tema claro y oscuro

## 🔒 Estructura de Firestore

```
users/{userId}
  name, email, role, totalPoints, level, badges, createdAt

classes/{classId}
  name, subject, description, classCode, professorId, students, createdAt
  - tasks/{taskId}: Tareas de la clase
  - messages/{messageId}: Chat de la clase

submissions/{submissionId}
  taskId, classId, studentId, studentName, fileUrl, grade, createdAt
```

## 🔐 Seguridad

Las reglas de Firestore aseguran que:
- Profesores pueden crear/editar sus clases
- Alumnos solo ven sus clases
- Las entregas son privadas

## 📝 Variables de entorno (.env)

```
BIEN_API_KEY=tu_key_aqui
```

No subas `.env` a Git.

## 🛠 Dependencias principales

- `firebase_core`: Firebase
- `firebase_auth`: Autenticación
- `cloud_firestore`: Base de datos
- `provider`: Estado
- `flutter_dotenv`: Variables de entorno

## 📁 Estructura

```
lib/
├── main.dart
├── core/
│   ├── config/        # Firebase options
│   └── constants/     # Colores y constantes
├── models/            # Modelos de datos
├── services/          # Auth, Firestore, Storage
├── providers/         # State management
├── views/             # Pantallas
├── widgets/           # Componentes
└── utils/             # Helpers y tema
```

## 🐛 Solución de problemas

**"Bien no responde"**
- Verifica `BIEN_API_KEY` en `.env`
- Comprueba límite de 50 preguntas/día

**"La app se ve en blanco en web"**
- Ejecuta `flutter clean && flutter pub get`
- Verifica que `.env` está en `assets` (pubspec.yaml)

**"No puedo crear clases"**
- Verifica que tu rol es "Profesor"
- Comprueba que Firestore está habilitado

## 🚀 Producción

```bash
flutter build apk --release     # Android
flutter build ios --release     # iOS
flutter build web --release     # Web
```

---

**Versión**: 1.0.0  
**Última actualización**: Junio 2026
