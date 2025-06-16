import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sekolah/models/proposal.dart'; // Pastikan path sesuai

class StatusProposal extends StatefulWidget {
  const StatusProposal({super.key});

  @override
  State<StatusProposal> createState() => _StatusProposalState();
}

class _StatusProposalState extends State<StatusProposal> {
  List<Proposal> proposals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProposals();
  }

  Future<void> fetchProposals() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.217:3000/api/all-proposals'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          proposals = data.map((json) => Proposal.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memuat daftar proposal: ${response.statusCode}',
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menentukan warna berdasarkan status
  Color getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.cyan; // Biru muda untuk "Dikirim ke Dinas"
      case 'Disetujui':
        return Colors.green; // Hijau untuk "Disetujui"
      case 'Ditolak':
        return Colors.red; // Merah untuk "Ditolak"
      default:
        return Colors.grey; // Abu-abu untuk status lain
    }
  }

  // Fungsi untuk menentukan teks status
  String getStatusText(String status) {
    switch (status) {
      case 'Menunggu':
        return 'Dikirim ke Dinas';
      case 'Disetujui':
        return 'Disetujui';
      case 'Ditolak':
        return 'Ditolak';
      default:
        return 'Tidak Diketahui';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Proposal Renovasi'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Berikut adalah daftar proposal yang pernah diajukan:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : proposals.isEmpty
                      ? const Center(
                        child: Text('Tidak ada proposal yang diajukan.'),
                      )
                      : ListView.builder(
                        itemCount: proposals.length,
                        itemBuilder: (context, index) {
                          final proposal = proposals[index];
                          final statusText = getStatusText(proposal.status);
                          final statusColor = getStatusColor(proposal.status);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        proposal.judulProposal,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Dikirim ${proposal.createdAt.day} ${_getMonthName(proposal.createdAt.month)} ${proposal.createdAt.year}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showStatusDialog(context, statusText);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: statusColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Center(child: Text('Kembali')),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detail Status Proposal'),
          content: Text('Status proposal saat ini: $status'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }
}
