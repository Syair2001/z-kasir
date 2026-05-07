import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';

class PendingScreen extends ConsumerWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hourglass_empty_rounded,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),

              const Text(
                "Menunggu Verifikasi",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              const Text(
                "Akun dan kedai Anda sedang ditinjau oleh tim BAZNAS Barru.\n\n"
                "Kami akan memberitahu melalui SMS/Whatsapp setelah disetujui.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              const SizedBox(height: 40),

              if (auth.userData != null)
                Text(
                  "Username: ${auth.userData!['username']}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}