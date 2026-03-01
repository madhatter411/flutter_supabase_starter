# flutter_supabase_starter

Flutter + Supabase starter kit (us-east-1).

## Quick start

1. Clone:
   ```bash
   git clone https://github.com/madhatter411/flutter_supabase_starter.git
   cd flutter_supabase_starter
   ```
2. Create Flutter app files (if they aren’t generated yet):
   ```bash
   flutter create .
   ```
   Optionally include web/desktop:
   ```bash
   flutter create . --platforms=android,ios,web,windows,macos,linux
   ```
3. Add packages:
   ```bash
   flutter pub add supabase_flutter
   ```

4. Run the app without committing secrets by passing your keys at runtime:
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
   ```

### Minimal `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Supabase starter'),
        ),
      ),
    );
  }
}
```

## Supabase database schema

Run `supabase/schema.sql` in the Supabase dashboard SQL editor to create:

- users (profile)
- customers
- projects
- invoices

Row Level Security is enabled; tighten/expand the policies as you add UI.

## Next

- Implement auth flows (sign-in/sign-up)
- CRUD UI for customers/projects/invoices
- Add workflows for invoicing (totals, status, PDF/exports)
