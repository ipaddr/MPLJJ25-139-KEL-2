import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AuditLaporan extends StatefulWidget {
  const AuditLaporan({super.key});

  @override
  State<AuditLaporan> createState() => _AuditLaporanState();
}

class _AuditLaporanState extends State<AuditLaporan> {
  final TextEditingController _namaProyekController = TextEditingController();
  final TextEditingController _danaAwalController = TextEditingController();
  final TextEditingController _pengeluaranMingguController =
      TextEditingController();
  final TextEditingController _totalPengeluaranController =
      TextEditingController();
  final TextEditingController _totalRabController = TextEditingController();
  final TextEditingController _catatanAuditorController =
      TextEditingController();

  List<Map<String, dynamic>> auditList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAuditData();
  }

  Future<void> fetchAuditData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.217:3000/api/audit'), // Sesuaikan IP/port
      );
      if (response.statusCode == 200) {
        setState(() {
          auditList = List<Map<String, dynamic>>.from(
            jsonDecode(response.body),
          );
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saat mengambil data: $e')));
    }
  }

  Future<void> _submitAudit() async {
    if (_namaProyekController.text.isEmpty ||
        _danaAwalController.text.isEmpty ||
        _pengeluaranMingguController.text.isEmpty ||
        _totalPengeluaranController.text.isEmpty ||
        _totalRabController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi kecuali catatan auditor.'),
        ),
      );
      return;
    }

    final danaAwal = double.tryParse(
      _danaAwalController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
    );
    final pengeluaranMinggu = double.tryParse(
      _pengeluaranMingguController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
    );
    final totalPengeluaran = double.tryParse(
      _totalPengeluaranController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
    );
    final totalRab = double.tryParse(
      _totalRabController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
    );

    if (danaAwal == null ||
        pengeluaranMinggu == null ||
        totalPengeluaran == null ||
        totalRab == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Angka tidak valid. Pastikan format benar.'),
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.217:3000/api/audit'), // Sesuaikan IP/port
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'namaProyek': _namaProyekController.text,
          'danaAwal': danaAwal,
          'pengeluaranMingguIni': pengeluaranMinggu,
          'totalPengeluaran': totalPengeluaran,
          'totalRab': totalRab,
          'catatanAuditor': _catatanAuditorController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan!')),
        );
        _namaProyekController.clear();
        _danaAwalController.clear();
        _pengeluaranMingguController.clear();
        _totalPengeluaranController.clear();
        _totalRabController.clear();
        _catatanAuditorController.clear();
        await fetchAuditData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _downloadPDF(String auditId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.18.217:3000/api/audit/$auditId/pdf',
        ), // Sesuaikan IP/port
      );
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/audit_$auditId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF berhasil diunduh! Cek folder aplikasi.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh PDF: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _namaProyekController.dispose();
    _danaAwalController.dispose();
    _pengeluaranMingguController.dispose();
    _totalPengeluaranController.dispose();
    _totalRabController.dispose();
    _catatanAuditorController.dispose();
    super.dispose();
  }

  Widget buildAuditCard(Map<String, dynamic> audit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Laporan Audit',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Nama Proyek',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(audit['namaProyek'] ?? 'Tidak ada nama'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Dana Awal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Rp ${audit['danaAwal']?.toString() ?? '0'}'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Pengeluaran Minggu Ini',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Rp ${audit['pengeluaranMingguIni']?.toString() ?? '0'}',
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Total Pengeluaran',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Rp ${audit['totalPengeluaran']?.toString() ?? '0'}',
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Total RAB',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Rp ${audit['totalRab']?.toString() ?? '0'}'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Catatan Auditor',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        audit['catatanAuditor'] ?? 'Tidak ada catatan',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _downloadPDF(audit['_id'].toString()),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                'Unduh PDF',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Input Data Laporan Proyek',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _namaProyekController,
                decoration: const InputDecoration(
                  labelText: 'Nama Proyek',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan nama proyek (contoh: SMP Harapan Jaya)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _danaAwalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dana Awal',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan dana awal (contoh: 300000000)',
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pengeluaranMingguController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pengeluaran Minggu Ini',
                  border: OutlineInputBorder(),
                  hintText:
                      'Masukkan pengeluaran minggu ini (contoh: 25000000)',
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _totalPengeluaranController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Pengeluaran',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan total pengeluaran (contoh: 180000000)',
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _totalRabController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total RAB',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan total RAB (contoh: 295000000)',
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _catatanAuditorController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan Auditor',
                  border: OutlineInputBorder(),
                  hintText:
                      'Masukkan catatan auditor (contoh: Tidak ditemukan penyimpangan)',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitAudit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Simpan Laporan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Daftar Laporan Audit',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : auditList.isEmpty
                  ? const Center(child: Text('Belum ada laporan audit.'))
                  : Column(
                    children:
                        auditList.map((audit) {
                          return buildAuditCard(audit);
                        }).toList(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
