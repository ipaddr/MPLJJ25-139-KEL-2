import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sekolah/presentasion/pages/Sekolah/pengajuan_berhasil.dart';


class PengajuanProposalPage extends StatefulWidget {
  const PengajuanProposalPage({super.key});

  @override
  State<PengajuanProposalPage> createState() => _PengajuanProposalPageState();
}

class _PengajuanProposalPageState extends State<PengajuanProposalPage> {
  String? selectedProposal;
  final dropdownItems = ['Renovasi', 'Pembangunan', 'Rehabilitasi'];

  String? dokumenProposalPath;
  String? desainRencanaPath;
  String? dokumenRABPath;

  final TextEditingController judulController = TextEditingController();

  Future<void> pickFile(Function(String?) onPicked) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      onPicked(result.files.single.path);
    }
  }

  void ajukanProposal() {
   
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PengajuanBerhasil()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text(
          'Form Pengajuan Proposal Renovasi',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text("Jenis Proposal", style: TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedProposal,
              items: dropdownItems.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Jenis Proposal',
              ),
              onChanged: (value) {
                setState(() {
                  selectedProposal = value;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text("Judul Proposal"),
            const SizedBox(height: 8),
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Judul Proposal',
              ),
            ),
            const SizedBox(height: 20),

            const Text("Dokumen Proposal"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => pickFile((path) {
                setState(() {
                  dokumenProposalPath = path;
                });
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  dokumenProposalPath != null
                      ? '✔ File dipilih: ${dokumenProposalPath!.split('/').last}'
                      : 'Unggah Dokumen Proposal',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Desain Rencana"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => pickFile((path) {
                setState(() {
                  desainRencanaPath = path;
                });
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  desainRencanaPath != null
                      ? '✔ File dipilih: ${desainRencanaPath!.split('/').last}'
                      : 'Unggah Desain Rencana',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Dokumen RAB"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => pickFile((path) {
                setState(() {
                  dokumenRABPath = path;
                });
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  dokumenRABPath != null
                      ? '✔ File dipilih: ${dokumenRABPath!.split('/').last}'
                      : 'Unggah Dokumen RAB',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ajukanProposal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                ),
                child: const Text('Ajukan Proposal'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
