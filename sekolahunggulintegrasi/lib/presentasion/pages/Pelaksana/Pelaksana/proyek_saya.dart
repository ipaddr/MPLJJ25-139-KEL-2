import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProyekSaya extends StatefulWidget {
  const ProyekSaya({super.key});

  @override
  State<ProyekSaya> createState() => _ProyekSayaState();
}

class _ProyekSayaState extends State<ProyekSaya> {
  List<Map<String, dynamic>> proyekList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProyek();
  }

  Future<void> fetchProyek() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.18.217:3000/api/proyek'));
      if (response.statusCode == 200) {
        setState(() {
          proyekList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
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

  Future<void> createProyek(Map<String, dynamic> proyekData) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.217:3000/api/proyek'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(proyekData),
      );
      if (response.statusCode == 201) {
        fetchProyek(); // Refresh daftar setelah menambahkan proyek
      } else {
        throw Exception('Gagal menambahkan proyek: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding proyek: $e')),
      );
    }
  }

  Future<void> updateProgress(String id, double progressFisik, double progressKeuangan) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.217:3000/api/proyek/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'progressFisik': progressFisik, 'progressKeuangan': progressKeuangan}),
      );
      if (response.statusCode == 200) {
        fetchProyek();
      } else {
        throw Exception('Gagal update progress: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating progress: $e')),
      );
    }
  }

  Future<void> markAsCompleted(String id) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.217:3000/api/proyek/$id/selesai'),
      );
      if (response.statusCode == 200) {
        fetchProyek();
      } else {
        throw Exception('Gagal menandai selesai: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error marking as completed: $e')),
      );
    }
  }

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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahProyekPage(onSubmit: createProyek),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Tambah Proyek'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (proyekList.isEmpty)
              const Center(child: Text('Tidak ada proyek yang tersedia.'))
            else
              ...proyekList.map((proyek) => ProyekCard(
                    key: ValueKey(proyek['_id']),
                    namaSekolah: proyek['namaSekolah'],
                    lokasi: proyek['lokasi'],
                    jadwal: proyek['jadwal'],
                    status: proyek['status'],
                    progressFisik: proyek['progressFisik'].toDouble(),
                    progressKeuangan: proyek['progressKeuangan'].toDouble(),
                    onUpdate: (progressFisik, progressKeuangan) =>
                        updateProgress(proyek['_id'], progressFisik, progressKeuangan),
                    onMarkCompleted: () => markAsCompleted(proyek['_id']),
                  )).toList(),
          ],
        ),
      ),
    );
  }
}

// Halaman baru untuk input data proyek
class TambahProyekPage extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic>) onSubmit;

  const TambahProyekPage({super.key, required this.onSubmit});

  @override
  State<TambahProyekPage> createState() => _TambahProyekPageState();
}

class _TambahProyekPageState extends State<TambahProyekPage> {
  final _formKey = GlobalKey<FormState>();
  String namaSekolah = '';
  String lokasi = '';
  String jadwal = '';
  String status = 'Berlangsung';
  double progressFisik = 0.0;
  double progressKeuangan = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Proyek Baru'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Sekolah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama sekolah tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    namaSekolah = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    lokasi = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Jadwal (contoh: 01 Mar – 30 Mei 2025)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jadwal tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    jadwal = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: status,
                items: const [
                  DropdownMenuItem(value: 'Berlangsung', child: Text('Berlangsung')),
                  DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                ],
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Status harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Progress Fisik (0-1)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Progress fisik tidak boleh kosong';
                  }
                  final doubleValue = double.tryParse(value);
                  if (doubleValue == null || doubleValue < 0 || doubleValue > 1) {
                    return 'Progress fisik harus antara 0 dan 1';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    progressFisik = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Progress Keuangan (0-1)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Progress keuangan tidak boleh kosong';
                  }
                  final doubleValue = double.tryParse(value);
                  if (doubleValue == null || doubleValue < 0 || doubleValue > 1) {
                    return 'Progress keuangan harus antara 0 dan 1';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    progressKeuangan = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final proyekData = {
                      'namaSekolah': namaSekolah,
                      'lokasi': lokasi,
                      'jadwal': jadwal,
                      'status': status,
                      'progressFisik': progressFisik,
                      'progressKeuangan': progressKeuangan,
                    };
                    widget.onSubmit(proyekData).then((_) {
                      Navigator.pop(context); // Kembali ke halaman utama setelah sukses
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Center(child: Text('Simpan Proyek')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProyekCard extends StatelessWidget {
  final String namaSekolah;
  final String lokasi;
  final String jadwal;
  final String status;
  final double progressFisik;
  final double progressKeuangan;
  final VoidCallback onMarkCompleted;
  final Function(double, double) onUpdate;

  const ProyekCard({
    super.key,
    required this.namaSekolah,
    required this.lokasi,
    required this.jadwal,
    required this.status,
    required this.progressFisik,
    required this.progressKeuangan,
    required this.onUpdate,
    required this.onMarkCompleted,
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Update Progress'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: const InputDecoration(labelText: 'Progress Fisik (0-1)'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              // Validasi input
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Progress Keuangan (0-1)'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              // Validasi input
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implementasi logika update di sini
                            Navigator.pop(context);
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Update Progress'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onMarkCompleted,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Tandai Selesai'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}