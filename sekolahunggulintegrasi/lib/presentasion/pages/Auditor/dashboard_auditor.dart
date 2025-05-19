import 'package:flutter/material.dart';
import 'daftar_proyek.dart';
import 'audit_laporan.dart';
import 'download_pdf.dart';
import 'profil.dart';

class DashboardAuditor extends StatelessWidget {
  const DashboardAuditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧑‍💼 Dashboard Auditor'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, 'Lihat Proyek', Colors.amber, const DaftarProyek()),
            const SizedBox(height: 16),
            buildButton(context, 'Audit Laporan', Colors.green, const AuditLaporan()),
            const SizedBox(height: 16),
            buildButton(context, 'Download PDF & Arsip', Colors.orange, const DownloadPDF()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilAuditor()));
          }
        },
      ),
    );
  }

  Widget buildButton(BuildContext context, String label, Color color, Widget page) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
