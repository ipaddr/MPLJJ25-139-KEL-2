import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  XFile? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih file: $e')),
      );
    }
  }

  Future<void> _submit() async {
    // Validasi sederhana
    if (mingguController.text.isEmpty ||
        fisikController.text.isEmpty ||
        keuanganController.text.isEmpty ||
        _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data.')),
      );
      return;
    }

    final fisik = double.tryParse(fisikController.text);
    final keuangan = double.tryParse(keuanganController.text);
    if (fisik == null || keuangan == null || fisik < 0 || fisik > 100 || keuangan < 0 || keuangan > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress harus antara 0 dan 100.')),
      );
      return;
    }

    // Kirim data ke backend
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.18.217:3000/api/progress'),
      );

      // Tambahkan field teks
      request.fields['minggu'] = mingguController.text;
      request.fields['fisik'] = fisikController.text;
      request.fields['keuangan'] = keuanganController.text;
      request.fields['catatan'] = catatanController.text;

      // Tambahkan file foto
      request.files.add(
        await http.MultipartFile.fromPath('foto', _selectedFile!.path),
      );

      final response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress berhasil dikirim!')),
        );
        // Clear field setelah submit
        mingguController.clear();
        fisikController.clear();
        keuanganController.clear();
        catatanController.clear();
        setState(() {
          _selectedFile = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim progress: ${response.statusCode}')),
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
                  hintText: 'Contoh: 55',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: keuanganController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Progress Keuangan (%)',
                  hintText: 'Contoh: 80',
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
                        _selectedFile != null ? _selectedFile!.name : 'Belum ada file',
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