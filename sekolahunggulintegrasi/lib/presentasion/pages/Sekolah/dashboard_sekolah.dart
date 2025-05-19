import 'package:flutter/material.dart';
import 'package:sekolah/presentasion/pages/Sekolah/status_proposal.dart';
import 'package:sekolah/presentasion/pages/Sekolah/identitas_sekolah.dart';
import 'package:sekolah/presentasion/pages/Sekolah/pengajuan_proposal.dart';
import 'package:sekolah/presentasion/pages/Sekolah/profil_sekolah.dart';

class DashboardSekolah extends StatefulWidget {
  const DashboardSekolah({super.key});

  @override
  State<DashboardSekolah> createState() => _DashboardSekolahState();
}

class _DashboardSekolahState extends State<DashboardSekolah> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardContent(),
    const StatusProposal(),
    const ProfilSekolahPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? buildAppBar() : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: buildBottomNavBar(_selectedIndex, _onItemTapped),
    );
  }
}

// ========================
// AppBar terpisah
// ========================
PreferredSizeWidget buildAppBar() {
  return AppBar(
    backgroundColor: Colors.blue[800],
    title: const Row(
      children: [
        Icon(Icons.school, color: Colors.white),
        SizedBox(width: 8),
        Text('Dashboard Sekolah', style: TextStyle(color: Colors.white)),
      ],
    ),
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(24.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Selamat datang, silakan kelola informasi sekolah Anda',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    ),
  );
}

// ========================
// BottomNavigationBar terpisah
// ========================
Widget buildBottomNavBar(int selectedIndex, Function(int) onTap) {
  return BottomNavigationBar(
    currentIndex: selectedIndex,
    onTap: onTap,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.school), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
    ],
  );
}

// ========================
// Halaman utama
// ========================
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          dashboardButton(
            title: '🏫 Identitas Sekolah',
            color: Colors.amber[300]!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IdentitasSekolahPage()),
              );
            },
            height: 80.0,
          ),
          const SizedBox(height: 30),
          dashboardButton(
            title: '📤 Pengajuan Proposal',
            color: Colors.green[600]!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PengajuanProposalPage(),
                ),
              );
            },
            height: 80.0,
          ),
          const SizedBox(height: 40),
          dashboardButton(
            title: '📌 Status Proposal',
            color: Colors.orange[600]!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatusProposal()),
              );
            },
            height: 80.0,
          ),
        ],
      ),
    );
  }
}

// ========================
// Tombol
// ========================
Widget dashboardButton({
  required String title,
  required Color color,
  required VoidCallback onTap,
  double height = 50.0,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

