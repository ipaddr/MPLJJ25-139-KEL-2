import 'package:flutter/material.dart';

class LaporanMingguan extends StatelessWidget {
  const LaporanMingguan({super.key});

  final List<Map<String, dynamic>> laporanList = const [
    {
      "minggu": "Minggu ke-4 (1–7 April 2025)",
      "fisik": 0.45,
      "keuangan": 0.47,
      "foto": ["pondasi.jpg", "atap.jpg"],
      "catatan": "Hujan 3 hari berturut-turut, pekerjaan tertunda."
    },
    {
      "minggu": "Minggu ke-3 (25–31 Maret 2025)",
      "fisik": 0.30,
      "keuangan": 0.35,
      "foto": ["struktur.jpg"],
      "catatan": "Pekerjaan lancar, tanpa kendala."
    },
  ];

  Widget buildLaporanCard(Map<String, dynamic> laporan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            laporan["minggu"],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text("Progress Fisik: ${(laporan["fisik"] * 100).toStringAsFixed(0)}%"),
          LinearProgressIndicator(value: laporan["fisik"], minHeight: 8),
          const SizedBox(height: 12),
          Text("Progress Keuangan: ${(laporan["keuangan"] * 100).toStringAsFixed(0)}%"),
          LinearProgressIndicator(
            value: laporan["keuangan"],
            minHeight: 8,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          Text("📷 Foto: ${laporan["foto"].join(", ")}"),
          const SizedBox(height: 4),
          Text("📝 Catatan: ${laporan["catatan"]}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Laporan Mingguan Proyek'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: laporanList.length,
          itemBuilder: (context, index) {
            return buildLaporanCard(laporanList[index]);
          },
        ),
      ),
    );
  }
}
