import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../auth/auth_provider.dart';
import '../auth/pending_screen.dart';

class SetupStoreScreen extends ConsumerStatefulWidget {
  final String name;   // Nama lengkap dari login screen

  const SetupStoreScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<SetupStoreScreen> createState() => _SetupStoreScreenState();
}

class _SetupStoreScreenState extends ConsumerState<SetupStoreScreen> {
  final usernameController = TextEditingController();
  final storeNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  File? selectedLogo;
  bool isLoading = false;

  Future<void> pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final compressed = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      "${pickedFile.path}_compressed.jpg",
      quality: 75,
    );

    if (compressed != null) {
      final size = await compressed.length();
      if (size > 400 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ukuran logo maksimal 400KB")),
          );
        }
        return;
      }
      setState(() => selectedLogo = File(compressed.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Setup Kedai Minuman")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lengkapi Data Toko Anda",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: storeNameController,
              decoration: const InputDecoration(
                labelText: "Nama Kedai *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "No HP *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Alamat Kedai *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: passwordConfirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Konfirmasi Password *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Logo
            GestureDetector(
              onTap: pickLogo,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: selectedLogo == null
                    ? const Center(
                        child: Text(
                          "Upload Logo Kedai\n(Maksimal 400KB - Opsional)",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(selectedLogo!, fit: BoxFit.cover),
                      ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        // Validasi sederhana
                        if (usernameController.text.isEmpty ||
                            storeNameController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            passwordConfirmController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Mohon isi field yang wajib")),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        final success = await authNotifier.service.registerFull(
                          name: widget.name,
                          phone: phoneController.text.trim(),
                          storeName: storeNameController.text.trim(),
                          address: addressController.text.trim(),
                          email: emailController.text.trim(),
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                          passwordConfirm: passwordConfirmController.text.trim(),
                          logo: selectedLogo,
                        );

                        setState(() => isLoading = false);

                        if (success) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Pendaftaran berhasil! Menunggu verifikasi BAZNAS..."),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const PendingScreen()),
                            );
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Gagal mendaftar. Periksa koneksi atau data Anda."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("KIRIM PENDAFTARAN", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}