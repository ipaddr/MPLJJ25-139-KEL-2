import 'package:flutter/material.dart';
import 'package:sekolah/presentasion/pages/Pelaksana/proyek_saya.dart';
import 'package:sekolah/presentasion/pages/Pelaksana/upload_progress.dart';
import 'package:sekolah/presentasion/pages/Pelaksana/laporan_mingguan.dart';
import 'package:sekolah/presentasion/pages/pelaksana/profil_pelaksana_page.dart';

class DashboardPelaksana extends StatefulWidget {
  const DashboardPelaksana({super.key});

  @override
  State<DashboardPelaksana> createState() => _DashboardPelaksanaState();
}

class _DashboardPelaksanaState extends State<DashboardPelaksana> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPelaksanaHome(),
    ProyekSaya(),
    UploadProgress(),
    LaporanMingguan(),
    ProfilPelaksanaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget? getAppBar() {
    return _selectedIndex == 0 ? buildAppBar() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

PreferredSizeWidget buildAppBar() {
  return AppBar(
    backgroundColor: Colors.blue[800],
    title: const Row(
      children: [
        Icon(Icons.engineering, color: Colors.white),
        SizedBox(width: 8),
        Text('Dashboard Pelaksana', style: TextStyle(color: Colors.white)),
      ],
    ),
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(24.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Selamat datang, silakan mulai monitoring proyek Anda',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    ),
  );
}

class DashboardPelaksanaHome extends StatelessWidget {
  const DashboardPelaksanaHome({super.key});

  Widget buildButton(String label, Color color, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(6),
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildButton('Proyek Saya', Colors.green, Icons.folder, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProyekSaya()));
              }),
              buildButton('Upload Progress', Colors.orange, Icons.cloud_upload, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadProgress()));
              }),
              buildButton('Laporan Mingguan', Colors.blue, Icons.report, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LaporanMingguan()));
              }),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Notifikasi Terbaru', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Progress proyek SDN 01 Harapan telah diperbarui'),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Upload foto progress minggu ke-5 masih kosong'),
          ),
        ],
      ),
    );
  }
}
