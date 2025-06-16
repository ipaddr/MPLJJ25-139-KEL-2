import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PengajuanProposalPage extends StatefulWidget {
  const PengajuanProposalPage({super.key});

  @override
  State<PengajuanProposalPage> createState() => _PengajuanProposalPageState();
}

class _PengajuanProposalPageState extends State<PengajuanProposalPage> {
  String? selectedProposal;
  final List<String> dropdownItems = [
    'Renovasi Bangunan',
    'Pembangunan Baru',
    'Penambahan Fasilitas',
    'Perbaikan Infrastruktur Penunjang (Jalan, Pagar, Toilet, Dll)',
  ];

  String? dokumenProposalPath;
  String? desainRencanaPath;
  String? dokumenRABPath;

  final TextEditingController judulController = TextEditingController();
  final TextEditingController namaSekolahController = TextEditingController();
  final TextEditingController alamatSekolahController = TextEditingController();
  final TextEditingController jumlahSiswaController = TextEditingController();
  final TextEditingController fasilitasController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    judulController.dispose();
    namaSekolahController.dispose();
    alamatSekolahController.dispose();
    jumlahSiswaController.dispose();
    fasilitasController.dispose();
    super.dispose();
  }

  Future<void> pickFile(Function(String?) onPicked) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      onPicked(result.files.single.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File ${result.files.single.name} berhasil dipilih!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pemilihan file dibatalkan.')),
      );
    }
  }

  Future<void> ajukanProposal() async {
    if (_formKey.currentState!.validate()) {
      if (dokumenProposalPath == null ||
          desainRencanaPath == null ||
          dokumenRABPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap lengkapi semua dokumen yang diperlukan.'),
          ),
        );
        return;
      }

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://192.168.18.217:3000/api/proposals/submit'),
        );

        // Add text fields
        request.fields['jenisProposal'] = selectedProposal!;
        request.fields['judulProposal'] = judulController.text;
        request.fields['namaSekolah'] = namaSekolahController.text;
        request.fields['alamatSekolah'] = alamatSekolahController.text;
        request.fields['jumlahSiswa'] = jumlahSiswaController.text;
        request.fields['fasilitas'] = fasilitasController.text;

        // Add files
        request.files.add(
          await http.MultipartFile.fromPath('dokumenProposal', dokumenProposalPath!),
        );
        request.files.add(
          await http.MultipartFile.fromPath('desainRencana', desainRencanaPath!),
        );
        request.files.add(
          await http.MultipartFile.fromPath('dokumenRAB', dokumenRABPath!),
        );

        var response = await request.send();
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Proposal berhasil diajukan!')),
          );
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PengajuanBerhasil()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengajukan proposal.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  Widget _buildFileUploadButton({
    required String label,
    required String? filePath,
    required Function(String?) onPicked,
  }) {
    String fileName = filePath != null ? filePath.split('/').last : '';
    String buttonText =
        filePath != null ? '✔ File dipilih: $fileName' : 'Unggah $label';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => pickFile(onPicked),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.upload_file, color: Colors.black54),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Pengajuan Proposal Renovasi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Jenis Proposal", style: TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedProposal,
                items: dropdownItems.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Pilih Jenis Proposal',
                ),
                onChanged: (value) {
                  setState(() {
                    selectedProposal = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis proposal harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField("Nama Sekolah", namaSekolahController),
              const SizedBox(height: 20),
              _buildTextField("Alamat Sekolah", alamatSekolahController),
              const SizedBox(height: 20),
              _buildTextField("Jumlah Siswa", jumlahSiswaController, isNumber: true),
              const SizedBox(height: 20),
              _buildTextField("Fasilitas Sekolah", fasilitasController),
              const SizedBox(height: 20),
              _buildTextField("Judul Proposal", judulController),
              const SizedBox(height: 20),
              _buildFileUploadButton(
                label: "Dokumen Proposal",
                filePath: dokumenProposalPath,
                onPicked: (path) {
                  setState(() {
                    dokumenProposalPath = path;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildFileUploadButton(
                label: "Desain Rencana",
                filePath: desainRencanaPath,
                onPicked: (path) {
                  setState(() {
                    desainRencanaPath = path;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildFileUploadButton(
                label: "Dokumen RAB",
                filePath: dokumenRABPath,
                onPicked: (path) {
                  setState(() {
                    dokumenRABPath = path;
                  });
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ajukanProposal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Ajukan Proposal', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Masukkan $label',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }
}
