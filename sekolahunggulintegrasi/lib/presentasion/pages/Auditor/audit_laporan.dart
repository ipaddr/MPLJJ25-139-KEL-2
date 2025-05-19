import 'package:flutter/material.dart';

class AuditLaporan extends StatelessWidget {
  const AuditLaporan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📑 Audit Laporan Proyek'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Nama Proyek: SMP Harapan Jaya', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Dana Awal: Rp 300.000.000'),
            Text('Pengeluaran Minggu Ini: Rp 25.000.000'),
            Text('Total Pengeluaran: Rp 180.000.000'),
            SizedBox(height: 12),
            Text('📊 Rencana Anggaran Biaya (RAB):', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Total RAB: Rp 295.000.000'),
            SizedBox(height: 12),
            Text('📝 Catatan Auditor:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Tidak ditemukan penyimpangan. Semua laporan lengkap dan sesuai RAB.'),
          ],
        ),
      ),
    );
  }
}
