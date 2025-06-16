import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LaporanStatistik extends StatefulWidget {
  const LaporanStatistik({super.key});

  @override
  State<LaporanStatistik> createState() => _LaporanStatistikState();
}

class _LaporanStatistikState extends State<LaporanStatistik> {
  List<dynamic> proyekData = [];
  List<dynamic> auditData = [];
  List<dynamic> progressData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Ambil data dari API
      final proyekResponse = await http.get(Uri.parse('http://192.168.18.217:3000/api/proyek'));
      final auditResponse = await http.get(Uri.parse('http://192.168.18.217:3000/api/audit'));
      final progressResponse = await http.get(Uri.parse('http://192.168.18.217:3000/api/proyek'));

      if (proyekResponse.statusCode == 200 &&
          auditResponse.statusCode == 200 &&
          progressResponse.statusCode == 200) {
        setState(() {
          proyekData = json.decode(proyekResponse.body);
          auditData = json.decode(auditResponse.body);
          progressData = json.decode(progressResponse.body);
          print('Progress Data: $progressData'); // Debugging
        });
      } else {
        throw Exception('Gagal memuat data: Status code ${proyekResponse.statusCode}, ${auditResponse.statusCode}, ${progressResponse.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung statistik proyek
    int aktifCount = proyekData.where((item) => item['status']?.toLowerCase() == 'aktif').length;
    int selesaiCount = proyekData.where((item) => item['status']?.toLowerCase() == 'selesai').length;
    int tundaCount = proyekData.where((item) => item['status']?.toLowerCase() == 'tunda').length;

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
              child: _buildStatistikProyek(aktifCount, selesaiCount, tundaCount),
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

  Widget _buildStatistikProyek(int aktifCount, int selesaiCount, int tundaCount) {
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
        _buildStatCard('Proyek Aktif', '$aktifCount Proyek', Colors.blue),
        const SizedBox(height: 8),
        _buildStatCard('Proyek Selesai', '$selesaiCount Proyek', Colors.blue),
        const SizedBox(height: 8),
        _buildStatCard('Proyek Tunda', '$tundaCount Proyek', Colors.blue),
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
                      ...auditData.map((item) => Column(
                            children: [
                              _buildFinanceRow(
                                item['namaProyek']?.toString() ?? '',
                                _formatRupiah(item['danaAwal'] ?? 0),
                                _formatRupiah(item['totalPengeluaran'] ?? 0),
                                _calculateRemaining(item['danaAwal'] ?? 0, item['totalPengeluaran'] ?? 0),
                              ),
                              const Divider(),
                            ],
                          )),
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

  String _formatRupiah(num amount) {
    // Konversi ke string dengan pemisah ribuan
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  String _calculateRemaining(num danaAwal, num totalPengeluaran) {
    // Konversi num ke double secara eksplisit
    double danaAwalDouble = (danaAwal is int) ? danaAwal.toDouble() : (danaAwal as double);
    double totalPengeluaranDouble = (totalPengeluaran is int) ? totalPengeluaran.toDouble() : (totalPengeluaran as double);

    // Hitung sisa dana
    double remainingValue = danaAwalDouble - totalPengeluaranDouble;

    // Konversi kembali ke format Rupiah dengan pemisah ribuan
    return 'Rp ${remainingValue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
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
                          'Nama Sekolah',
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
                          'Progres Fisik (%)',
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
                          'Progres Keuangan (%)',
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
                      if (progressData.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Tidak ada data progres.'),
                        )
                      else
                        ...progressData.map((item) => Column(
                              children: [
                                _buildProgressRow(
                                  item['namaSekolah']?.toString() ?? '',
                                  (item['progressFisik'] ?? 0).toDouble() * 100,
                                  (item['progressKeuangan'] ?? 0).toDouble() * 100,
                                  item['status']?.toString() ?? '',
                                ),
                                const Divider(),
                              ],
                            )),
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

  Widget _buildProgressRow(String namaSekolah, num progressFisik, num progressKeuangan, String status) {
    Color statusColor = status == 'Berlangsung' ? Colors.blue : Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              namaSekolah,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('${progressFisik.toStringAsFixed(0)}%', textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: Text('${progressKeuangan.toStringAsFixed(0)}%', textAlign: TextAlign.center),
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