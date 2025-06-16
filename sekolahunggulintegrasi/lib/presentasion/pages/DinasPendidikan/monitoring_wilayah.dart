import 'package:flutter/material.dart';
import 'package:sekolah/presentasion/pages/DinasPendidikan/detail.dart';

class Monitoringwilayah extends StatefulWidget {
  const Monitoringwilayah({super.key});

  @override
  State<Monitoringwilayah> createState() => _MonitoringwilayahState();
}

class _MonitoringwilayahState extends State<Monitoringwilayah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Monitoring Proyek di Wilayah'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SMP Harapan Jaya',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text('Jenis: Renovasi Gedung'),
              const Text('Minggu ke-4'),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text(
                    'Fisik: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('55%'),
                  SizedBox(width: 16),
                  Text(
                    'Keuangan: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('47%'),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Dalam proses',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Detail()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
