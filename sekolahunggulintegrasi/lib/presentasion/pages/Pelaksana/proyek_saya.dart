import 'package:flutter/material.dart';

class ProyekSaya extends StatelessWidget {
  const ProyekSaya({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📁 Proyek Saya'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Sekolah atau lokasi',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Berlangsung', child: Text('Berlangsung')),
                      DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Wilayah',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Bekasi', child: Text('Bekasi')),
                      DropdownMenuItem(value: 'Bogor', child: Text('Bogor')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ========================
            // Proyek Card (Dummy Data)
            // ========================
            const ProyekCard(
              namaSekolah: 'SDN 01 Harapan',
              lokasi: 'Bekasi, Jawa Barat',
              jadwal: '01 Mar – 30 Mei 2025',
              status: 'Sedang Berlangsung',
              progressFisik: 0.4,
              progressKeuangan: 0.35,
            ),

            const SizedBox(height: 16),

            const ProyekCard(
              namaSekolah: 'SDN 02 Mandiri',
              lokasi: 'Bogor, Jawa Barat',
              jadwal: '15 Feb – 20 Jun 2025',
              status: 'Sedang Berlangsung',
              progressFisik: 0.6,
              progressKeuangan: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}

// ====================
// Widget Proyek Card
// ====================
class ProyekCard extends StatelessWidget {
  final String namaSekolah;
  final String lokasi;
  final String jadwal;
  final String status;
  final double progressFisik;
  final double progressKeuangan;

  const ProyekCard({
    super.key,
    required this.namaSekolah,
    required this.lokasi,
    required this.jadwal,
    required this.status,
    required this.progressFisik,
    required this.progressKeuangan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(namaSekolah, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Lokasi: $lokasi'),
          Text('Jadwal: $jadwal'),
          Text('Status: $status'),
          const SizedBox(height: 8),
          Text('Fisik: ${(progressFisik * 100).toStringAsFixed(0)}%'),
          LinearProgressIndicator(value: progressFisik),
          const SizedBox(height: 4),
          Text('Keuangan: ${(progressKeuangan * 100).toStringAsFixed(0)}%'),
          LinearProgressIndicator(value: progressKeuangan, color: Colors.blue),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Tambahkan fungsi update
                },
                child: const Text('Update Progress'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Tambahkan fungsi tandai selesai
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Tandai Selesai'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
