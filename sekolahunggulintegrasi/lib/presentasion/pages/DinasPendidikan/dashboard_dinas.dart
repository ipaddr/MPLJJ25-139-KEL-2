import 'package:flutter/material.dart';

// Import halaman lain sesuai project kamu
import 'package:sekolah/presentasion/pages/DinasPendidikan/approval_proposal.dart';
import 'package:sekolah/presentasion/pages/DinasPendidikan/monitoring_wilayah.dart';
import 'package:sekolah/presentasion/pages/DinasPendidikan/validasi_sekolah.dart';
import 'package:sekolah/presentasion/pages/DinasPendidikan/Profile.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardDinas(),
  ));
}

class DashboardDinas extends StatefulWidget {
  const DashboardDinas({super.key});

  @override
  State<DashboardDinas> createState() => _DashboardDinasState();
}

class _DashboardDinasState extends State<DashboardDinas> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardContent(),       // 0: Home
    const Validasisekolah(),        // 1: Validasi Sekolah
    const Approvalproposal(),       // 2: Approval Proposal
    const Monitoringwilayah(),      // 3: Monitoring Wilayah
    const Profile(),            // 4: Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget? getAppBar() {
    if (_selectedIndex == 0) {
      return buildAppBar();
    } else {
      return null; // app bar tidak ditampilkan untuk tab selain home
    }
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
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ''),
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

// ========================
// AppBar terpisah untuk Home
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
// Dashboard Home Content
// ========================
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  Widget buildButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
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

  Widget buildNotification(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }

  Widget buildStat(String label, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
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
              buildButton(
                'Validasi Data\nSekolah',
                Colors.orange,
                Icons.check_circle,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Validasisekolah(),
                    ),
                  );
                },
              ),
              buildButton(
                'Approval\nProposal',
                Colors.green,
                Icons.assignment_turned_in,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Approvalproposal(),
                    ),
                  );
                },
              ),
              buildButton(
                'Monitoring\nWilayah',
                Colors.yellow.shade700,
                Icons.map,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Monitoringwilayah(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Notifikasi Terbaru',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          buildNotification(
            'Proposal dari SD Negeri 2 Sukamaju menunggu approval',
            Colors.orange.shade100,
          ),
          buildNotification(
            'Update mingguan dari Proyek SMP Harapan Jaya (Minggu ke-4)',
            Colors.cyan.shade100,
          ),
          buildNotification(
            'Belum ada update dari proyek SDN Karangjati minggu ini',
            Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Statistik Wilayah',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          buildStat('✅ Sekolah Terverifikasi: 18/20', Colors.green),
          buildStat('📤 Proposal Terkirim ke Pusat: 12', Colors.orange),
          buildStat('📌 Proyek Aktif: 5 | Selesai: 7', Colors.grey),
        ],
      ),
    );
  }
}
