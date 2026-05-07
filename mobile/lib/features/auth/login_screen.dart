import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import '../store/setup_store_screen.dart';
import 'pending_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); // untuk register

  bool isLogin = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Z-Kasir BAZNAS")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? "Login" : "Daftar Akun Baru",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Username / Nama
            TextField(
              controller: isLogin ? usernameController : nameController,
              decoration: InputDecoration(
                labelText: isLogin ? "Username" : "Nama Lengkap",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password (hanya login)
            if (isLogin)
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);

                      if (isLogin) {
                        // LOGIN
                        final success = await ref.read(authProvider.notifier).login(
                              usernameController.text.trim(),
                              passwordController.text.trim(),
                            );

                        if (success) {
                          final state = ref.read(authProvider);
                          if (state.status == 'pending') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const PendingScreen()),
                            );
                          } else {
                            Navigator.pushReplacementNamed(context, '/dashboard');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login gagal")),
                          );
                        }
                      } else {
                        // Pindah ke Setup Store
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SetupStoreScreen(
                              name: nameController.text.trim(),
                            ),
                          ),
                        );
                      }

                      setState(() => isLoading = false);
                    },
              child: Text(isLogin ? "Login" : "Lanjut Setup Toko"),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? "Belum punya akun? Daftar" : "Sudah punya akun? Login"),
            ),
          ],
        ),
      ),
    );
  }
}