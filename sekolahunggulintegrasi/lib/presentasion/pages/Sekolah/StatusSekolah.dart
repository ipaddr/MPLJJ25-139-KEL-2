import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sekolah/presentasion/pages/Sekolah/identitas_sekolah.dart'; // Sesuaikan path

class StatusSekolah extends StatefulWidget {
  const StatusSekolah({super.key});

  @override
  State<StatusSekolah> createState() => _StatusSekolahState();
}

class _StatusSekolahState extends State<StatusSekolah> {
  List<dynamic> schools = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSchoolStatus();
  }

  // Fungsi untuk mengambil daftar sekolah
  Future<void> fetchSchoolStatus() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.217:3000/api/sekolah'),
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

  // Fungsi untuk menampilkan badge status
  Widget buildStatusBadge(String? status) {
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
      case 'menunggu_verifikasi':
        color = Colors.blue;
        text = 'Menunggu Verifikasi';
        break;
      default:
        color = Colors.grey;
        text = 'Draft';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Verifikasi Sekolah'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : schools.isEmpty
              ? const Center(child: Text('Tidak ada data sekolah'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: schools.length,
                  itemBuilder: (context, index) {
                    final school = schools[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              school['nama'] ?? 'Nama tidak tersedia',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Status: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                buildStatusBadge(school['statusVerifikasi']),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                            if (school['catatan'] != null && school['catatan'].isNotEmpty) ...[
                              const Text(
                                'Catatan Revisi dari Dinas:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(school['catatan']),
                            ],
                            if (school['statusVerifikasi'] == 'ditolak') ...[
                              const SizedBox(height: 12),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const IdentitasSekolahPage(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit Data Sekolah'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}