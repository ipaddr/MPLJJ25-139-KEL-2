import 'package:flutter/material.dart';

class DaftarProyek extends StatelessWidget {
  const DaftarProyek({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Daftar Proyek Sekolah'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildProjectCard('SD Negeri 01 Sukamaju', 'CV Maju Terus', 'Berjalan', '12 Jan - 12 Apr'),
          buildProjectCard('SMP Harapan Jaya', 'PT Bangun Harapan', 'Selesai', '1 Feb - 30 Apr'),
        ],
      ),
    );
  }

  Widget buildProjectCard(String nama, String pelaksana, String status, String tanggal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('Pelaksana: $pelaksana'),
            Text('Status: $status'),
            Text('Periode: $tanggal'),
          ],
        ),
      ),
    );
  }
}
