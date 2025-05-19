import 'package:flutter/material.dart';

class StatusProposal extends StatefulWidget {
  const StatusProposal({super.key});

  @override
  State<StatusProposal> createState() => _StatusProposalState();
}

class _StatusProposalState extends State<StatusProposal> {
  // Data dummy untuk daftar proposal (bisa diganti dengan data dari API atau database)
  final List<Map<String, dynamic>> proposals = [
    {
      'title': 'Renovasi Ruang Kelas',
      'date': 'Dikirim 20 Apr 2025',
      'status': 'Dikirim ke Dinas',
      'statusColor': Colors.cyan,
    },
    {
      'title': 'Renovasi Ruang Kelas',
      'date': 'Dikirim 21 Apr 2025',
      'status': 'Disetujui',
      'statusColor': Colors.yellow,
    },
    {
      'title': 'Renovasi Ruang Kelas',
      'date': 'Dikirim 22 Apr 2025',
      'status': 'Ditolak',
      'statusColor': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Proposal Renovasi'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Berikut adalah daftar proposal yang pernah diajukan:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: proposals.length,
                itemBuilder: (context, index) {
                  final proposal = proposals[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                proposal['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                proposal['date'],
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Logika untuk melihat detail status
                              _showStatusDialog(context, proposal['status']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: proposal['statusColor'],
                              padding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: Text(
                              proposal['status'],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.blue),
              ),
              child: Center(child: Text('Kembali')),
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
          title: Text('Detail Status Proposal'),
          content: Text('Status proposal saat ini: $status'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}