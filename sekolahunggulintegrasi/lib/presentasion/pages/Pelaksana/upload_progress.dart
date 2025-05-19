import 'package:flutter/material.dart';

class UploadProgress extends StatefulWidget {
  const UploadProgress({super.key});

  @override
  State<UploadProgress> createState() => _UploadProgressState();
}

class _UploadProgressState extends State<UploadProgress> {
  final TextEditingController mingguController = TextEditingController();
  final TextEditingController fisikController = TextEditingController();
  final TextEditingController keuanganController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  // Simulasi file upload (nantinya bisa gunakan image_picker)
  String? _uploadedFileName;

  void _pickFile() {
    // Placeholder action — nanti diganti dengan file picker atau image picker
    setState(() {
      _uploadedFileName = 'dokumentasi_foto_1.jpg';
    });
  }

  void _submit() {
    // Simulasi pengiriman data
    final data = {
      "minggu": mingguController.text,
      "fisik": fisikController.text,
      "keuangan": keuanganController.text,
      "catatan": catatanController.text,
      "foto": _uploadedFileName ?? 'Belum diunggah'
    };

    // Validasi sederhana
    if (data.values.any((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data.')),
      );
      return;
    }

    // Simulasi kirim
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress berhasil dikirim!')),
    );

    // Clear field setelah submit
    mingguController.clear();
    fisikController.clear();
    keuanganController.clear();
    catatanController.clear();
    setState(() {
      _uploadedFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📤 Upload Progress Proyek'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: mingguController,
                decoration: const InputDecoration(
                  labelText: 'Minggu ke / Periode',
                  hintText: 'Contoh: Minggu ke-4',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: fisikController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Progress Fisik (%)',
                  hintText: 'Contoh : 55',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: keuanganController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Progress Keuangan (%)',
                  hintText: 'Contoh : 80',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickFile,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Upload Dokumentasi',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _uploadedFileName ?? 'Belum ada file',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const Icon(Icons.upload_file, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Lapangan',
                  hintText: 'Contoh: Hujan setelah 3 hari',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
