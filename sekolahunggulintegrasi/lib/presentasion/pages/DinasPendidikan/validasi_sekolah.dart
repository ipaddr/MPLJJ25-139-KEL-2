import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Validasisekolah extends StatefulWidget {
  const Validasisekolah({super.key});

  @override
  State<Validasisekolah> createState() => _ValidasisekolahState();
}

class _ValidasisekolahState extends State<Validasisekolah> {
  final TextEditingController _komentarController = TextEditingController();
  List<dynamic> schools = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSchools(); // Panggil fungsi untuk mengambil data saat halaman dimuat
  }

  // Fungsi untuk mengambil data sekolah dari backend
  Future<void> fetchSchools() async {
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

  // Fungsi untuk mengirim status verifikasi
  Future<void> verifySchool(String id, String status, String catatan) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.217:3000/api/sekolah/$id/verifikasi'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'statusVerifikasi': status,
          'catatan': catatan,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status verifikasi berhasil diubah menjadi $status'),
            backgroundColor: status == 'disetujui' ? Colors.green : Colors.orange,
          ),
        );
        // Refresh data setelah verifikasi
        await fetchSchools();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📘 Validasi Data Sekolah'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : schools.isEmpty
              ? const Center(child: Text('Tidak ada data sekolah'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: schools.map((school) {
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
                            Text(
                              school['nama'] ?? 'Nama tidak tersedia',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            const Text(
                              'Komentar / Catatan Revisi (jika ada):',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _komentarController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Contoh: Tambahkan foto yang jelas',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      verifySchool(school['_id'], 'disetujui', _komentarController.text);
                                    },
                                    icon: const Icon(Icons.check_circle),
                                    label: const Text('Valid'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      verifySchool(school['_id'], 'ditolak', _komentarController.text);
                                    },
                                    icon: const Icon(Icons.warning_amber_rounded),
                                    label: const Text('Perlu Direvisi'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }
}