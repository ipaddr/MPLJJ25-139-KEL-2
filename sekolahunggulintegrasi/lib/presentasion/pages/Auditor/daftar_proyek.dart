import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarProyek extends StatefulWidget {
  const DaftarProyek({super.key});

  @override
  State<DaftarProyek> createState() => _DaftarProyekState();
}

class _DaftarProyekState extends State<DaftarProyek> {
  List<Map<String, dynamic>> proyekList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProyek();
  }

  Future<void> fetchProyek() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.18.217:3000/api/proyek',
        ), // Ganti IP/port sesuai kebutuhan
      );
      if (response.statusCode == 200) {
        setState(() {
          proyekList = List<Map<String, dynamic>>.from(
            jsonDecode(response.body),
          );
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget buildProjectCard(Map<String, dynamic> proyek) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              proyek['namaSekolah'] ?? 'Nama Tidak Tersedia',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text('Lokasi: ${proyek['lokasi'] ?? 'Lokasi Tidak Tersedia'}'),
            Text('Status: ${proyek['status'] ?? 'Status Tidak Tersedia'}'),
            Text('Periode: ${proyek['jadwal'] ?? 'Jadwal Tidak Tersedia'}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Daftar Proyek Sekolah'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : proyekList.isEmpty
                ? const Center(child: Text('Tidak ada proyek tersedia.'))
                : ListView.builder(
                  itemCount: proyekList.length,
                  itemBuilder: (context, index) {
                    return buildProjectCard(proyekList[index]);
                  },
                ),
      ),
    );
  }
}
