import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../store/store_provider.dart';
import '../auth/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeProvider);
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(store?.name ?? "Z-Kasir"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Toko
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: store?.logo.isNotEmpty == true
                      ? NetworkImage(store!.logo)
                      : null,
                  child: store?.logo.isEmpty == true
                      ? const Icon(Icons.store, size: 30)
                      : null,
                ),
                title: Text(
                  store?.name ?? "Kedai Saya",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(store?.address ?? ""),
                trailing: Chip(
                  label: Text(store?.isActive == true ? "Aktif" : "Pending"),
                  backgroundColor: store?.isActive == true
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              "Menu Utama",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.add_circle_outline,
                    title: "Tambah\nProduk",
                    color: Colors.blue,
                    onTap: () {
                      // Navigasi ke halaman produk nanti
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Menu Tambah Produk")),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.point_of_sale,
                    title: "Transaksi\nBaru",
                    color: Colors.green,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Menu Transaksi")),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text("Total Transaksi Hari Ini: Rp 0", 
                 style: TextStyle(fontSize: 16)),
            
            const Spacer(),

            Center(
              child: Text(
                "Selamat datang, ${auth.userData?['name'] ?? 'Mustahik'} 👋",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}