import 'package:flutter/material.dart';

class DownloadPDF extends StatelessWidget {
  const DownloadPDF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📥 Download Dokumen PDF'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildDownloadTile('Proposal Awal'),
            buildDownloadTile('Laporan Progres'),
            buildDownloadTile('Ringkasan Audit'),
          ],
        ),
      ),
    );
  }

  Widget buildDownloadTile(String label) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(label),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Download'),
        ),
      ),
    );
  }
}
