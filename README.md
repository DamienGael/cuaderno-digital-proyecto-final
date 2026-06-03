# MI CUADERNO DIGITAL

Aplicación educativa Flutter con Firebase y asistente IA "Bien".

## Configuración rápida

1. Instala Flutter y configura Android/iOS.
2. Abre la carpeta del proyecto en VS Code.
3. Ejecuta `flutter pub get`.
4. Configura un proyecto Firebase y agrega las credenciales necesarias.
5. Crea las colecciones de Firestore según la estructura del README.
6. Crea un archivo `.env` con tu API Key de Gemini.

## Variables de entorno

En el archivo `.env` agrega:

```text
BIEN_API_KEY=tu_api_key_de_gemini_aqui
```

No subas `.env` a Git.

## Requerimientos Firebase

- Firebase Auth
- Firestore
- Firebase Storage
- Firebase Messaging

## Estructura de Firestore

- users/{userId}
- classes/{classId}
- tasks/{taskId}
- submissions/{submissionId}
- forum_posts/{postId}
- forum_comments/{commentId}
- messages/{messageId}
- materials/{materialId}

## Ejecución

### Desktop / desarrollo

```bash
flutter pub get
flutter run
```

### Web

```bash
flutter build web --release
```

Luego sirve la carpeta `build/web` con un servidor estático o abre `build/web/index.html`.

### Android

Para generar APK necesitas Android SDK y `ANDROID_HOME` configurado.

```bash
flutter build apk --release
```

Si ves:

```text
No Android SDK found. Try setting the ANDROID_HOME environment variable.
```

instala Android Studio y configura el SDK antes de volver a compilar.
