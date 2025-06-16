import 'package:flutter/material.dart';
import 'package:sekolah/presentasion/pages/Admin/kelola_pengguna.dart';
import 'package:sekolah/presentasion/pages/Admin/laporan_statistik.dart';
import 'package:sekolah/presentasion/pages/Admin/profile.dart';

class DashboardAdmin extends StatefulWidget {
  final String token; // Tambahkan parameter token

  const DashboardAdmin({super.key, required this.token});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedIndex = 0;

  // Inisialisasi dinamis di build agar widget.token bisa diakses
  List<Widget> get _pages => [
        _DashboardContent(),
        KelolaPengguna(token: widget.token), // Menggunakan getter untuk akses token
        const LaporanStatistik(),
        const Profile(), // Placeholder
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pengguna'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// ================================
// Konten utama halaman Dashboard
// ================================
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildMenuSection(context),
            const SizedBox(height: 16),
            _buildNotificationSection(),
            const SizedBox(height: 16),
            _buildStatisticsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: const BoxDecoration(color: Colors.blue),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dashboard, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Dashboard Admin',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Selamat datang di panel pengelolaan sistem',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildMenuCard(
              context,
              title: 'Kelola\nPengguna',
              color: Colors.pink,
              icon: Icons.people,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => KelolaPengguna(token: (context as Element).findAncestorStateOfType<_DashboardAdminState>()!.widget.token)),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMenuCard(
              context,
              title: 'Laporan\nStatistik',
              color: Colors.amber,
              icon: Icons.bar_chart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LaporanStatistik()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifikasi Terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildNotificationCard(
            'Proposal dari 50 Negeri 2 Sukamaju menunggu approval',
            Colors.yellow.shade100,
          ),
          _buildNotificationCard(
            'Update mingguan dari Proyek SMP Kenangan Jaya (Minggu ke 4)',
            Colors.blue.shade100,
          ),
          _buildNotificationCard(
            'Belum ada update dari proyek SDN Karangsari minggu ini',
            Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(String message, Color color) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(message, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildStatCard(
            'Jumlah Permintaan: 1850',
            Colors.green,
            textColor: Colors.white,
          ),
          _buildStatCard(
            'Proposal Renovasi Terkini: 15',
            Colors.amber,
            textColor: Colors.black,
          ),
          _buildStatCard(
            'Proyek Aktif: 5 | Selesai: 7',
            Colors.grey.shade300,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String text, Color color, {required Color textColor}) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}