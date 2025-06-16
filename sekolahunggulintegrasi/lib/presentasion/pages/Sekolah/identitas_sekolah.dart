import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IdentitasSekolahPage extends StatefulWidget {
  const IdentitasSekolahPage({super.key});

  @override
  State<IdentitasSekolahPage> createState() => _IdentitasSekolahPageState();
}

class _IdentitasSekolahPageState extends State<IdentitasSekolahPage> {
  String? _pickedFileName;
  PlatformFile? _pickedFile;
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _npsnController = TextEditingController();
  final _jenjangController = TextEditingController();
  final _alamatController = TextEditingController();
  final _jumlahSiswaController = TextEditingController();
  final _fasilitasController = TextEditingController();

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _pickedFile = result.files.first;
          _pickedFileName = _pickedFile!.name;
        });
      }
    } catch (e) {
      debugPrint("Error memilih file: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error memilih file: $e')));
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      var request = http.MultipartRequest(
        'POST',
        // ⚠ Ganti IP sesuai IP backend kamu (localhost tidak bisa diakses dari HP/Emulator)
        Uri.parse('http://192.168.18.217:3000/api/sekolah'),
      );

      request.fields['nama'] = _namaController.text;
      request.fields['npsn'] = _npsnController.text;
      request.fields['jenjang'] = _jenjangController.text;
      request.fields['alamat'] = _alamatController.text;
      request.fields['jumlahSiswa'] = _jumlahSiswaController.text;

      List<String> fasilitasList =
          _fasilitasController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      request.fields['fasilitas'] = jsonEncode(fasilitasList);

      if (_pickedFile != null && _pickedFile!.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'dokumentasi',
            _pickedFile!.bytes!,
            filename: _pickedFile!.name,
          ),
        );
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: $responseBody');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Data berhasil dikirim')));
        Navigator.pop(context);
      } else {
        try {
          // Coba parse sebagai JSON
          var data = jsonDecode(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['error'] ?? 'Gagal mengirim data')),
          );
        } catch (_) {
          // Jika bukan JSON, tampilkan isi langsung
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim data: $responseBody')),
          );
        }
      }
    } catch (e) {
      debugPrint("Error mengirim form: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error mengirim form: $e')));
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _npsnController.dispose();
    _jenjangController.dispose();
    _alamatController.dispose();
    _jumlahSiswaController.dispose();
    _fasilitasController.dispose();
    super.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Identitas Sekolah',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInputField('Nama Sekolah', _namaController),
                _buildInputField('NPSN', _npsnController),
                _buildInputField(
                  'Jenjang (SD/SMP/SMA/SMK)',
                  _jenjangController,
                ),
                _buildInputField('Alamat', _alamatController),
                _buildInputField('Jumlah siswa', _jumlahSiswaController),
                _buildInputField(
                  'Fasilitas (pisahkan dengan koma)',
                  _fasilitasController,
                ),
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
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
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
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Kirim'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}
