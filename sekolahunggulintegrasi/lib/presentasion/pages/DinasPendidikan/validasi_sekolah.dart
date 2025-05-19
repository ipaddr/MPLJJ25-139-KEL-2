import 'package:flutter/material.dart';

class Validasisekolah extends StatefulWidget {
  const Validasisekolah({super.key});

  @override
  State<Validasisekolah> createState() => _ValidasisekolahState();
}

class _ValidasisekolahState extends State<Validasisekolah> {
  final TextEditingController _komentarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📘 Validasi Data Sekolah'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
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
                'SD Negeri 1 Sukamaju',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const Text('NPSN: 12345678'),
              const Text('Jenjang: SD'),
              const Text('Alamat: Jl. Pendidikan No. 10, Kec. Sukamaju'),
              const Text('Jumlah Siswa: 125'),
              const SizedBox(height: 8),
              const Text(
                'Fasilitas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('• 6 Ruang Kelas, 1 Perpustakaan, 1 Lab, Toilet Rusak'),
              const SizedBox(height: 8),
              const Text(
                'Foto Sekolah:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Text('Foto sekolah akan ditampilkan di sini'),
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
                  hintText: 'Contoh: Tambahkan foto yang rusak',
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
                        // Aksi ketika valid
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Data divalidasi'),
                          backgroundColor: Colors.green,
                        ));
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
                        // Aksi ketika perlu direvisi
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Perlu revisi'),
                          backgroundColor: Colors.orange,
                        ));
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
