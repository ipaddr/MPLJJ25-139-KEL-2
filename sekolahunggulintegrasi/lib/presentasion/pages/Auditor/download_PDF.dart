import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadPDF extends StatefulWidget {
  const DownloadPDF({super.key});

  @override
  _DownloadPDFState createState() => _DownloadPDFState();
}

class _DownloadPDFState extends State<DownloadPDF> {
  List<Map<String, dynamic>> documents = [];

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      final List<Future<http.Response>> futures = [
        http.get(Uri.parse('http://192.168.18.217:3000/api/all-proposals')),
        http.get(Uri.parse('http://192.168.18.217:3000/api/proyek')),
        http.get(Uri.parse('http://192.168.18.217:3000/api/progress')),
        http.get(Uri.parse('http://192.168.18.217:3000/api/audit')),
      ];

      final responses = await Future.wait(futures);
      final List<dynamic> allData = [];

      for (var response in responses) {
        if (response.statusCode == 200) {
          allData.addAll(json.decode(response.body));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal memuat data ${response.request?.url}: ${response.statusCode}',
              ),
            ),
          );
        }
      }

      setState(() {
        documents =
            allData.map((item) {
              String type;
              String label;
              if (item.containsKey('jenisProposal'))
                type = 'Proposal';
              else if (item.containsKey('namaSekolah'))
                type = 'Proyek';
              else if (item.containsKey('minggu'))
                type = 'Progress';
              else if (item.containsKey('namaProyek'))
                type = 'Audit';
              else
                type = 'Unknown';

              switch (type) {
                case 'Proposal':
                  label = '${item['judulProposal']} - Proposal';
                  break;
                case 'Proyek':
                  label = '${item['namaSekolah']} - Proyek';
                  break;
                case 'Progress':
                  label = 'Progress Minggu ${item['minggu']}';
                  break;
                case 'Audit':
                  label = '${item['namaProyek']} - Audit';
                  break;
                default:
                  label = 'Dokumen Tidak Dikenal';
              }
              return {'type': type, 'label': label, 'data': item};
            }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _downloadPDF(String type, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.217:3000/api/generate-pdf'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'type': type.toLowerCase(), 'data': data}),
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath =
            '${directory.path}/${type.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF berhasil diunduh! Cek folder aplikasi.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh PDF: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

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
        child:
            documents.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return buildDownloadTile(
                      doc['label'],
                      doc['type'],
                      doc['data'],
                    );
                  },
                ),
      ),
    );
  }

  Widget buildDownloadTile(
    String label,
    String type,
    Map<String, dynamic> data,
  ) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(label),
        trailing: ElevatedButton(
          onPressed: () => _downloadPDF(type, data),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Download'),
        ),
      ),
    );
  }
}
