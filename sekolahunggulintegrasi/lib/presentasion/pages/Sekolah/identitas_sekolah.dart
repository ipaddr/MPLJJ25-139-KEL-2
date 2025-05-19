import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class IdentitasSekolahPage extends StatefulWidget {
  const IdentitasSekolahPage({super.key});

  @override
  State<IdentitasSekolahPage> createState() => _IdentitasSekolahPageState();
}

class _IdentitasSekolahPageState extends State<IdentitasSekolahPage> {
  String? _pickedFileName;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _pickedFileName = result.files.single.name;
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        title: const Text(
          'Data Kondisi Sekolah',
          style: TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Identitas Sekolah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildInputField('Nama Sekolah'),
              _buildInputField('NPSN'),
              _buildInputField('Jenjang (SD/SMP/SMA/SMK)'),
              _buildInputField('Alamat'),
              _buildInputField('Jumlah siswa'),
              _buildInputField('Fasilitas yang tersedia'),

              const SizedBox(height: 12),
              const Text(
                'Upload Dokumentasi Sekolah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Dokumen / Foto'),
              ),
              if (_pickedFileName != null) ...[
                const SizedBox(height: 8),
                Text('File dipilih: $_pickedFileName'),
              ],

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: const Text('Kembali'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigasi ke halaman selanjutnya
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Selanjutnya'),
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

  Widget _buildInputField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
