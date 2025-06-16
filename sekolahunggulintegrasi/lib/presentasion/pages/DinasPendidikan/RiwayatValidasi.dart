import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatValidasi extends StatefulWidget {
  const RiwayatValidasi({super.key});

  @override
  State<RiwayatValidasi> createState() => _RiwayatValidasiState();
}

class _RiwayatValidasiState extends State<RiwayatValidasi> {
  List<dynamic> schools = [];
  bool isLoading = true;
  String selectedFilter = 'verified'; // Filter: 'verified' (disetujui/ditolak), 'disetujui', 'ditolak'

  @override
  void initState() {
    super.initState();
    fetchSchools();
  }

  // Fungsi untuk mengambil data sekolah yang sudah diverifikasi
  Future<void> fetchSchools() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.217:3000/api/sekolah?status=verified'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          schools = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Widget untuk menampilkan badge status
  Widget buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'disetujui':
        color = Colors.green;
        text = 'Valid';
        break;
      case 'ditolak':
        color = Colors.orange;
        text = 'Perlu Revisi';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Filter sekolah berdasarkan status
  List<dynamic> getFilteredSchools() {
    if (selectedFilter == 'verified') {
      return schools.where((school) => ['disetujui', 'ditolak'].contains(school['statusVerifikasi'])).toList();
    }
    return schools.where((school) => school['statusVerifikasi'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📜 Riwayat Validasi Sekolah'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Semua Terverifikasi'),
                    selected: selectedFilter == 'verified',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedFilter = 'verified';
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Valid'),
                    selected: selectedFilter == 'disetujui',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedFilter = 'disetujui';
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Perlu Revisi'),
                    selected: selectedFilter == 'ditolak',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedFilter = 'ditolak';
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : getFilteredSchools().isEmpty
                    ? const Center(child: Text('Tidak ada data sekolah yang sudah diverifikasi'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: getFilteredSchools().map((school) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          school['nama'] ?? 'Nama tidak tersedia',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ),
                                      buildStatusBadge(school['statusVerifikasi'] ?? 'unknown'),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text('NPSN: ${school['npsn'] ?? '-'}'),
                                  Text('Jenjang: ${school['jenjang'] ?? '-'}'),
                                  Text('Alamat: ${school['alamat'] ?? '-'}'),
                                  Text('Jumlah Siswa: ${school['jumlahSiswa'] ?? '-'}'),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Fasilitas:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(school['fasilitas']?.join(', ') ?? '-'),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Foto Sekolah:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  school['dokumentasi'] != null && school['dokumentasi'].isNotEmpty
                                      ? SizedBox(
                                          height: 150,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: school['dokumentasi'].length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(right: 8),
                                                child: Image.network(
                                                  'http://192.168.18.217:3000/${school['dokumentasi'][index]}',
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => const Text('Gagal memuat gambar'),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          height: 150,
                                          width: double.infinity,
                                          color: Colors.grey.shade300,
                                          alignment: Alignment.center,
                                          child: const Text('Tidak ada foto sekolah'),
                                        ),
                                  const SizedBox(height: 16),
                                  if (school['catatan'] != null && school['catatan'].isNotEmpty) ...[
                                    const Text(
                                      'Catatan Revisi:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(school['catatan']),
                                    const SizedBox(height: 8),
                                  ],
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}