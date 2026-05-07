import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/pending_screen.dart';
import 'features/store/dashboard_screen.dart';
import 'features/auth/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: ZKasirApp()));
}

class ZKasirApp extends ConsumerWidget {
  const ZKasirApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Z-Kasir BAZNAS Barru',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/pending': (context) => const PendingScreen(),
      },
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    // Jika sudah login
    if (auth.isAuthenticated) {
      if (auth.status == 'pending') {
        return const PendingScreen();
      } else {
        return const DashboardScreen();
      }
    }

    // Jika belum login
    return const LoginScreen();
  }
}