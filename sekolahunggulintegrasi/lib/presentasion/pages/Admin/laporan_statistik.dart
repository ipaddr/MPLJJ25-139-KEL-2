import 'package:flutter/material.dart';

class LaporanStatistik extends StatefulWidget {
  const LaporanStatistik({super.key});

  @override
  State<LaporanStatistik> createState() => _LaporanStatistikState();
}

class _LaporanStatistikState extends State<LaporanStatistik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Laporan & Statistik',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Analisis data dan progres proyek renovasi',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Statistik Proyek
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildStatistikProyek(),
            ),

            // Laporan Keuangan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildLaporanKeuangan(),
            ),

            // Laporan Progres
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildLaporanProgres(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistikProyek() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Statistik Proyek',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatCard('Proyek Aktif', '5 Proyek', Colors.blue),
        const SizedBox(height: 8),
        _buildStatCard('Proyek Selesai', '7 Proyek', Colors.blue),
        const SizedBox(height: 8),
        _buildStatCard('Proyek Tunda', '7 Proyek', Colors.blue),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaporanKeuangan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.attach_money, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Laporan Keuangan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Table Header
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Nama Proyek',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Alokasi Dana',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Penggunaan Dana',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Sisa Dana',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Table Rows
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildFinanceRow(
                        'Proyek SMP Kenangan Jaya',
                        'Rp 150.000.000',
                        'Rp 105.000.000',
                        'Rp 45.000.000',
                      ),
                      const Divider(),
                      _buildFinanceRow(
                        'Proyek SDK Kasehatan',
                        'Rp 250.000.000',
                        'Rp 220.000.000',
                        'Rp 30.000.000',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceRow(
    String projectName,
    String allocation,
    String usage,
    String remaining,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              projectName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(allocation, textAlign: TextAlign.center),
          ),
          Expanded(flex: 1, child: Text(usage, textAlign: TextAlign.center)),
          Expanded(
            flex: 1,
            child: Text(remaining, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildLaporanProgres() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.edit, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Laporan Progres',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Table Header
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Nama Proyek',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Progres (%)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Status',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Table Rows
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildProgressRow(
                        'Proyek SMP Kenangan Jaya',
                        75,
                        'Berjalan',
                      ),
                      const Divider(),
                      _buildProgressRow('Proyek SDK Kasehatan', 90, 'Selesai'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(String projectName, int progress, String status) {
    Color statusColor = status == 'Berjalan' ? Colors.blue : Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              projectName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('$progress%', textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
