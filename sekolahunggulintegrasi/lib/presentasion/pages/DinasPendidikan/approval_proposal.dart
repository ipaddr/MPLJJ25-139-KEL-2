// lib/screens/approval_proposal.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sekolah/models/proposal.dart';

class ApprovalProposal extends StatefulWidget {
  const ApprovalProposal({super.key});

  @override
  State<ApprovalProposal> createState() => _ApprovalProposalState();
}

class _ApprovalProposalState extends State<ApprovalProposal> {
  String? _selectedAction;
  Proposal? _selectedProposal;
  List<Proposal> _proposals = [];
  bool _isLoading = true;

  final List<String> _actions = [
    'Setuju dan kirim ke pusat',
    'Tolak dan kembalikan ke sekolah',
  ];

  @override
  void initState() {
    super.initState();
    _fetchProposals();
  }

  // lib/screens/approval_proposal.dart
  // lib/screens/approval_proposal.dart
  Future<void> _fetchProposals() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.217:3000/api/proposals'),
      );
      print('Fetch Proposals - Status Code: ${response.statusCode}');
      print('Fetch Proposals - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Fetch Proposals - Parsed Data: $data');
        setState(() {
          _proposals = data.map((json) => Proposal.fromJson(json)).toList();
          _selectedProposal = _proposals.isNotEmpty ? _proposals[0] : null;
          _isLoading = false;
        });
        if (_proposals.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tidak ada proposal dengan status Menunggu'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        String errorMessage = 'Unknown error';
        try {
          errorMessage = jsonDecode(response.body)['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = response.body;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memuat daftar proposal: ${response.statusCode} - $errorMessage',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Fetch Proposals - Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitAction() async {
    if (_selectedAction != null && _selectedProposal != null) {
      try {
        final status =
            _selectedAction == 'Setuju dan kirim ke pusat'
                ? 'Disetujui'
                : 'Ditolak';
        final response = await http.patch(
          Uri.parse(
            'http://192.168.18.217:3000/api/proposal/${_selectedProposal!.id}/status',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'status': status}),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Aksi berhasil: $_selectedAction'),
              backgroundColor: Colors.blue,
            ),
          );
          // Refresh daftar proposal setelah aksi
          _fetchProposals();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim aksi: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih aksi dan proposal terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📄 Approval Proposal Renovasi'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _proposals.isEmpty
              ? const Center(child: Text('Tidak ada proposal yang tersedia.'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Dropdown untuk memilih proposal
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📜 Pilih Proposal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<Proposal>(
                            value: _selectedProposal,
                            hint: const Text('Pilih Proposal'),
                            items:
                                _proposals
                                    .map(
                                      (proposal) => DropdownMenuItem(
                                        value: proposal,
                                        child: Text(proposal.judulProposal),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedProposal = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Informasi proposal
                    if (_selectedProposal != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedProposal!.namaSekolah,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jenis Proposal: ${_selectedProposal!.jenisProposal}',
                            ),
                            Text('Alamat: ${_selectedProposal!.alamatSekolah}'),
                            Text(
                              'Jumlah Siswa: ${_selectedProposal!.jumlahSiswa}',
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Fasilitas:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_selectedProposal!.fasilitas),
                            const SizedBox(height: 8),
                            const Text(
                              'Desain Rencana Renovasi:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_selectedProposal!.desainRencanaPath),
                            const SizedBox(height: 8),
                            const Text(
                              'Dokumen RAB:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_selectedProposal!.dokumenRABPath),
                            const SizedBox(height: 8),
                            const Text(
                              'Judul Proposal:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_selectedProposal!.judulProposal),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Dropdown Aksi Proposal
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📝 Pilih Aksi Proposal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text('Pilih Aksi:'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedAction,
                            hint: const Text('Aksi Proposal'),
                            items:
                                _actions
                                    .map(
                                      (action) => DropdownMenuItem(
                                        value: action,
                                        child: Text(action),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedAction = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitAction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text('Kirim'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
