import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LaporanMingguan extends StatefulWidget {
  const LaporanMingguan({super.key});

  @override
  State<LaporanMingguan> createState() => _LaporanMingguanState();
}

class _LaporanMingguanState extends State<LaporanMingguan> {
  List<Map<String, dynamic>> laporanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLaporan();
  }

  Future<void> fetchLaporan() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.18.217:3000/api/progress',
        ), // Ganti IP/port sesuai kebutuhan
      );
      if (response.statusCode == 200) {
        setState(() {
          laporanList = List<Map<String, dynamic>>.from(
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
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget buildLaporanCard(Map<String, dynamic> laporan) {
    // Pastikan foto adalah array, jika tidak, jadikan array tunggal
    final fotoList =
        laporan['fotoPath'] != null
            ? (laporan['fotoPath'] is String
                ? [laporan['fotoPath']]
                : List<String>.from(laporan['fotoPath']))
            : [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            laporan['minggu'] ?? 'Tidak ada minggu',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Progress Fisik: ${((laporan['fisik'] ?? 0) * 100).toStringAsFixed(1)}%",
          ),
          LinearProgressIndicator(
            value: (laporan['fisik'] ?? 0).toDouble(),
            minHeight: 8,
          ),
          const SizedBox(height: 12),
          Text(
            "Progress Keuangan: ${((laporan['keuangan'] ?? 0) * 100).toStringAsFixed(1)}%",
          ),
          LinearProgressIndicator(
            value: (laporan['keuangan'] ?? 0).toDouble(),
            minHeight: 8,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          Text(
            "📷 Foto: ${fotoList.isNotEmpty ? fotoList.join(", ") : 'Tidak ada foto'}",
          ),
          const SizedBox(height: 4),
          Text("📝 Catatan: ${laporan['catatan'] ?? 'Tidak ada catatan'}"),
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
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : laporanList.isEmpty
                ? const Center(child: Text('Tidak ada laporan tersedia.'))
                : ListView.builder(
                  itemCount: laporanList.length,
                  itemBuilder: (context, index) {
                    return buildLaporanCard(laporanList[index]);
                  },
                ),
      ),
    );
  }
}
